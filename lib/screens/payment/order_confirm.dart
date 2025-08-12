import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/screens/dashboard.dart';

class OrderConfirm extends StatelessWidget {
  const OrderConfirm({super.key, required this.trxId});

  final String trxId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Order',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Icon(
                Icons.check_circle_outline_rounded,
                size: 120,
                color: Colors.green.shade400.withValues(alpha: .8),
              ),

              const SizedBox(height: 24),
              //
              Text(
                'Order Placed Successfully!',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 8),

              //
              Text(
                'Congratulations! your order has been placed.',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: .2,
                    ),
              ),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your can track your order',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: .2,
                        ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: trxId),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '# $trxId',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 64),

              //
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Buy another book')),

                  const SizedBox(width: 16),

                  //
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Dashboard()),
                            (route) => false);
                      },
                      child: const Text('Home')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
