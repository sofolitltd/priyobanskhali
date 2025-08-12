import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/utils/date_time_formatter.dart';
import '../../utils/open_app.dart';

const List<String> list = <String>['Book', 'Ebook'];

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: DropdownMenu<String>(
                width: 120,
                initialSelection: list.first,
                inputDecorationTheme: InputDecorationTheme(
                  contentPadding: const EdgeInsets.only(left: 16),
                  isDense: true,
                  border: OutlineInputBorder(
                      gapPadding: 0, borderRadius: BorderRadius.circular(50)),
                  constraints: const BoxConstraints(maxHeight: 40),
                ),
                onSelected: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                dropdownMenuEntries:
                    list.map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(value: value, label: value);
                }).toList(),
              ),
            ),
          ),
        ],
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('bookType', isEqualTo: dropdownValue.toLowerCase())
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Something wrong'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return Center(child: Text('No $dropdownValue order found!'));
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: docs.length,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 16),
              itemBuilder: (_, index) {
                var data = docs[index];
                //
                return GestureDetector(
                  onTap: () {
                    //
                  },
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //order id
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Text(
                                    '${docs.length - index}',
                                    style: TextStyle(height: 1),
                                  )),

                              const SizedBox(width: 16),
                              //
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 2,
                                  children: [
                                    //title
                                    Text('ORDER ID',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              height: 1,
                                              fontSize: 10,
                                            )),

                                    //order
                                    Text(
                                      data.get('orderId'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              height: 1),
                                    ),
                                  ],
                                ),
                              ),

                              //
                              IconButton(
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text(
                                          'Are you sure you want to delete this order?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Delete',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(data.get('paymentId'))
                                          .delete();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Order deleted')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('Failed to delete: $e')),
                                      );
                                    }
                                  }
                                },
                                icon: const Icon(Icons.delete),
                              ),

                              //
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: data.get('bookType') == 'book'
                                      ? Colors.green.withValues(alpha: 1)
                                      : Colors.red.shade500
                                          .withValues(alpha: .8),
                                ),
                                child: Text(
                                  data.get('bookType'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ],
                          ),

                          const Divider(height: 10),

                          // book
                          SizedBox(
                            height: 48,
                            width: double.infinity,
                            child: StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(dropdownValue.toLowerCase())
                                    .doc(data.get('bookId'))
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return const SizedBox();
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox();
                                  }
                                  var data = snapshot.data!;

                                  if (!data.exists) {
                                    return const SizedBox();
                                  }

                                  // card
                                  return Row(
                                    children: [
                                      //
                                      CachedNetworkImage(
                                        imageUrl: data.get('image'),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),

                                      //
                                      //title
                                      Expanded(
                                        child: Container(
                                          constraints: const BoxConstraints(
                                              minHeight: 64),
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              // title
                                              Text(
                                                data.get('title'),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.hindSiliguri(
                                                  textStyle: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall,
                                                  height: 1,
                                                ),
                                              ),

                                              const Spacer(),

                                              // author
                                              Text(
                                                dropdownValue.toLowerCase() ==
                                                        'book'
                                                    ? '${data.get('author')}'
                                                    : '${data.get('month')}-${data.get('year')}',
                                                style:
                                                    GoogleFonts.hindSiliguri()
                                                        .copyWith(
                                                  fontSize: 12,
                                                  height: 1,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),

                          const SizedBox(height: 8),

                          //address, mobile

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //add
                              if (dropdownValue.toLowerCase() == 'book')
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    Text('Address: ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              height: 1.2,
                                              color: Colors.blueGrey,
                                            )),

                                    const SizedBox(height: 4),

                                    //address
                                    Text(
                                      data.get('address'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            height: 1.2,
                                          ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 4),

                              // mobile, date
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // mobile,
                                  InkWell(
                                    onTap: () {
                                      OpenApp.withNumber(data.get('mobile'));
                                    },
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        //icon
                                        const Icon(
                                          Icons.phone_android_outlined,
                                          color: Colors.blueGrey,
                                        ),

                                        //
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //title
                                            Text('Mobile :  ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.blueGrey,
                                                      height: 1.2,
                                                    )),

                                            //mobile
                                            Text(
                                              data.get('mobile'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    height: 1.2,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // date,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        'Date:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.blueGrey,
                                              height: 1.2,
                                            ),
                                      ),

                                      //mobile
                                      Text(
                                        DTFormatter.dateTimeFormat(
                                            data.get('date')),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                            ),
                                      ),
                                    ],
                                  ),

                                  // price,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      //title
                                      Text(
                                        'Price:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.blueGrey,
                                              height: 1.2,
                                            ),
                                      ),

                                      //mobile
                                      Text(
                                        data.get('price'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.w400,
                                              height: 1.2,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const Divider(),
                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //status
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //
                                  Text(
                                    'Status:  ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(height: 1),
                                  ),

                                  //
                                  Text(
                                    data.get('status').toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: data.get('status') == "Pending"
                                              ? Colors.orange
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2,
                                        ),
                                  ),
                                ],
                              ),

                              // btn
                              if (data.get('bookType') == 'book')
                                GestureDetector(
                                  onTap: data.get('status') == 'Pending'
                                      ? () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(data.get('paymentId'))
                                              .update({'status': 'Complete'});
                                        }
                                      : () async {
                                          await FirebaseFirestore.instance
                                              .collection('orders')
                                              .doc(data.get('paymentId'))
                                              .update({'status': 'Pending'});
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: data.get('status') == 'Pending'
                                          ? Colors.blueAccent
                                          : Colors.red,
                                    ),
                                    child: Text(
                                      data.get('status') == 'Pending'
                                          ? 'Confirm'
                                          : 'Cancel',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
