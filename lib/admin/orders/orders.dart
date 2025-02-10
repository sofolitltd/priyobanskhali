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
                inputDecorationTheme: const InputDecorationTheme(
                  contentPadding: EdgeInsets.only(left: 12),
                  isDense: true,
                  border: OutlineInputBorder(gapPadding: 0),
                  constraints: BoxConstraints(maxHeight: 40),
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
              // .orderBy('date', descending: true)
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
              return const Center(child: Text('No order found'));
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: docs.length,
              padding: const EdgeInsets.all(16),
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
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //order id
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //
                              Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 40),
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Text('${docs.length - index}')),

                              const SizedBox(width: 16),
                              //
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    Text('ORDER ID',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(height: 1)),

                                    //order
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        //
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
                                  ],
                                ),
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

                          const SizedBox(height: 10),

                          // book
                          Container(
                            height: 72,
                            width: double.infinity,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(4)),
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
                                          height: 64,
                                          width: 64,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              topRight: Radius.circular(8),
                                            ),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, downloadProgress) =>
                                                Container(
                                          height: 64,
                                          width: 64,
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
                                                maxLines: 2,
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
                                      Text('Date:',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall!
                                              .copyWith(
                                                color: Colors.blueGrey,
                                                height: 1.2,
                                              )),

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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'STATUS',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(height: 1),
                                    ),
                                  ),
                                  Text(
                                    data.get('status'),
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
