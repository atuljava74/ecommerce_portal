import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  final int orderId;

  OrderConfirmationPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'Thank you for your purchase!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Your order ID is $orderId',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Home or Order History
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
