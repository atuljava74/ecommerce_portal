import 'package:flutter/material.dart';

import 'order_summary_page.dart';

class PaymentMethodPage extends StatefulWidget {
  final String address;
  final String city;
  final String postalCode;
  final String country;

  PaymentMethodPage({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String _selectedPaymentMethod = 'Credit Card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Method'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('Credit Card'),
            leading: Radio<String>(
              value: 'Credit Card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ),
          ListTile(
            title: Text('PayPal'),
            leading: Radio<String>(
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderSummaryPage(
                    address: widget.address,
                    city: widget.city,
                    postalCode: widget.postalCode,
                    country: widget.country,
                    paymentMethod: _selectedPaymentMethod,
                  ),
                ),
              );
            },
            child: Text('Confirm and Review Order'),
          ),
        ],
      ),
    );
  }
}
