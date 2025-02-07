import 'package:flutter/material.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String orderNo;

  const PaymentSuccessPage({super.key, required this.orderNo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Order No: $orderNo",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, '/dashboard'); // Navigate to Dashboard
                },
                child: const Text("Go to Dashboard"),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home'); // Navigate to Home
                },
                child: const Text("Go to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
