// Choose Payment
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bkash/bkash.dart';
import '../../utils/repo.dart';

class ChoosePayment extends StatefulWidget {
  const ChoosePayment({
    super.key,
    required this.bookType,
    required this.bookId,
    required this.price,
    required this.address,
  });

  final String bookType;
  final String bookId;
  final int price;
  final String address;

  @override
  State<ChoosePayment> createState() => _ChoosePaymentState();
}

class _ChoosePaymentState extends State<ChoosePayment> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              // clean icon btn
              IconButton(
                style: IconButton.styleFrom(
                  visualDensity: VisualDensity(vertical: -2, horizontal: -2),
                ),
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const Divider(),

          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'price:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Text(
                        '${widget.price}',
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

              //
              isLoading ? const CircularProgressIndicator() : Container(),
            ],
          ),

          const SizedBox(height: 16),

          //bkash tile
          ListTile(
            tileColor: isLoading ? Colors.pink.shade50 : null,
            onTap: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);

                    //
                    await Bkash.payment(
                      production: AppRepo.kProduction,
                      amount: widget.price.toString(),
                      bookType: widget.bookType,
                      bookId: widget.bookId,
                      address: widget.address,
                    );

                    // Navigator.pop(context);
                    setState(() => isLoading = false);
                  },
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Image.asset(
              AppRepo.kBkashLogo,
              width: 56,
              height: 56,
            ),
            title: const Text('bkash'),
            subtitle: const Text('pay with your bkash number'),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
