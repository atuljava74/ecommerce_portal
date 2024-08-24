import 'package:ecommerce_portal/utils/app_config.dart';
import 'package:ecommerce_portal/widgets/celebration_animation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // For the celebration animation

class OrderConfirmationPage extends StatelessWidget {
  final int orderId;

  OrderConfirmationPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 100, color: AppConfig.themeColor),
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
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Home or Order History
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.themeColor,
                minimumSize: Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          CelebrationAnimation()
        ],
      ),
    );
  }
}
