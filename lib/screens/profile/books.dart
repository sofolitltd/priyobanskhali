import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:priyobanskhali/utils/date_time_formatter.dart';

class Books extends StatelessWidget {
  const Books({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Books',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where('bookType', isEqualTo: 'book')
              // .orderBy(
              //   'orderId',
              //   descending: true,
              // )
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
                              Column(
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

                              //
                              // date,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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

                          const SizedBox(height: 10),

                          // book
                          if (data.get('bookType') == 'book')
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
                                      .collection('book')
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
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      GoogleFonts.hindSiliguri(
                                                    textStyle: Theme.of(context)
                                                        .textTheme
                                                        .titleSmall,
                                                    height: 1,
                                                  ),
                                                ),

                                                const SizedBox(height: 8),
                                                // author
                                                Text(
                                                  '${data.get('author')}',
                                                  style:
                                                      GoogleFonts.hindSiliguri()
                                                          .copyWith(
                                                    height: 1.3,
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

                                  //status
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              color: data.get('status') ==
                                                      "Pending"
                                                  ? Colors.orange
                                                  : Colors.green,
                                              fontWeight: FontWeight.bold,
                                              height: 1.2,
                                            ),
                                      ),
                                    ],
                                  ),

                                  //
                                  const SizedBox(),
                                ],
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
