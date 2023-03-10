import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Orders extends StatelessWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
      ),

      //
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy(
                'orderId',
                descending: true,
              )
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
              return const Center(child: Text('No admin found'));
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //title
                              Text('order id:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(height: 1)),

                              const SizedBox(width: 8),

                              //order
                              Text(
                                data.get('orderId'),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // payment
                          Text('payment:',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(height: 1)),

                          //mobile and trans
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //title
                                    Text('Mobile No:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),

                                    const SizedBox(width: 8),

                                    //mobile
                                    Text(
                                      data.get('mobileNo'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),

                                //transactionId
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    //title
                                    Text('Transaction Id:',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),

                                    const SizedBox(width: 8),

                                    //mobile
                                    Text(
                                      data.get('transactionId'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          //
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //status
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'status:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(height: 1),
                                    ),
                                  ),
                                  Text(
                                    data.get('status'),
                                    style: TextStyle(
                                        color: data.get('status') == 'Confirm'
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),

                              //Confirm
                              if (data.get('status') != 'Confirm')
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: const Size(48, 32),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  onPressed: () async {
                                    //
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(data.get('orderId'))
                                        .update({
                                      'status': 'Confirm',
                                    }).then((value) async {
                                      // add to user/books
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(data.get('userId'))
                                          .collection('books')
                                          .doc(data.get('bookId'))
                                          .set({
                                        'bookId': data.get('bookId'),
                                      }).then((value) {
                                        // toast
                                        Fluttertoast.showToast(
                                            msg: 'Order confirmed.');
                                      });
                                    });
                                  },
                                  child: const Text('Confirm'),
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
