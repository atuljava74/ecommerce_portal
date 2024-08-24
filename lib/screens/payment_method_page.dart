import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'order_summary_page.dart';
import '../utils/app_config.dart';

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
      appBar: CustomAppBar(
        title: 'Select Payment Method',
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a payment method',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildPaymentOption(
                  context,
                  'Credit Card',
                  'assets/credit_card_icon.png', // Add an icon for credit card
                ),
                _buildPaymentOption(
                  context,
                  'Debit Card',
                  'assets/debit_card_icon.png', // Add an icon for debit card
                ),
                _buildPaymentOption(
                  context,
                  'Net Banking',
                  'assets/netbanking_icon.png', // Add an icon for net banking
                ),
                _buildPaymentOption(
                  context,
                  'UPI',
                  'assets/upi_icon.png', // Add an icon for UPI
                ),
                _buildPaymentOption(
                  context,
                  'PayPal',
                  'assets/paypal_icon.png', // Add an icon for PayPal
                ),
                _buildPaymentOption(
                  context,
                  'Cash on Delivery',
                  'assets/cash_on_delivery_icon.png', // Add an icon for Cash on Delivery
                ),
                SizedBox(height: 80), // Space for the button
              ],
            ),
          ),
          // Sticky Confirm and Review Order Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConfig.themeColor,
                  minimumSize: Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Confirm and Review Order',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, String iconPath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: ListTile(
        leading: Image.asset(
          iconPath,
          height: 60,
          fit: BoxFit.fitHeight,
        ),
        title: Text(title),
        trailing: Radio<String>(
          value: title,
          groupValue: _selectedPaymentMethod,
          onChanged: (value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
        ),
      ),
    );
  }
}
