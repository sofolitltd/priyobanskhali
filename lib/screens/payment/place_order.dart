import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/repo.dart';
import 'bkash_dialog.dart';

class PlaceOrder extends StatelessWidget {
  const PlaceOrder({
    super.key,
    required this.method,
    required this.id,
    required this.title,
    required this.month,
    required this.year,
    required this.price,
  });
  final String method;
  final String id;
  final String title;
  final String month;
  final String year;
  final int price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$method payment',
          style: const TextStyle(color: Colors.black),
        ),
      ),

      //
      body: ListView(
        // shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        children: [
          //title
          Text(
            'Please complete your $method payment first.',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          //
          const Text('* Send money to the following number.'),
          Text(
              '* Then place order with $method Number and $method Transaction .'),
          const SizedBox(height: 16),

          //
          const Text('Send Money to: '),
          const SizedBox(height: 4),

          // number
          Container(
            padding: const EdgeInsets.only(left: 8, right: 4),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                const Text(
                  AppRepo.kAdminNumber,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(width: 8),

                //
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(88, 40),
                  ),
                  onPressed: () {
                    //
                    Clipboard.setData(
                            const ClipboardData(text: AppRepo.kAdminNumber))
                        .then((value) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Copy to clipboard'),
                          ),
                        );
                    });
                  },
                  child: const Text('Copy'),
                )
              ],
            ),
          ),

          const SizedBox(height: 32),

          //
          Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // book title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Text(
                        'Book',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),

                      //
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w700, color: Colors.black),
                      )
                    ],
                  ),

                  //
                  Text(
                    '$month - $year',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.purple,
                          fontWeight: FontWeight.w400,
                        ),
                  ),

                  const Divider(),

                  // price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //
                      Text(
                        'Price',
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      //
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //
                          Text(
                            price.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2),
                          ),
                          const SizedBox(width: 4),

                          //
                          Text(
                            AppRepo.kTkSymbol,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // place order
          ElevatedButton(
            onPressed: () {
              //
              String orderId = DateTime.now().millisecondsSinceEpoch.toString();
              //
              showDialog(
                context: context,
                builder: (context) =>
                    // method == 'Bkash'
                    BkashDialog(
                  orderId: orderId,
                  bookId: id,
                  total: price,
                ),
              );
            },
            child: const Text('Place order'),
          )
        ],
      ),
    );
  }
}
