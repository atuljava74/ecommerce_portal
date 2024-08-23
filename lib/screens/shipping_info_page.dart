import 'package:ecommerce_portal/screens/payment_method_page.dart';
import 'package:flutter/material.dart';

class ShippingInfoPage extends StatefulWidget {
  @override
  _ShippingInfoPageState createState() => _ShippingInfoPageState();
}

class _ShippingInfoPageState extends State<ShippingInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String _address = '';
  String _city = '';
  String _postalCode = '';
  String _country = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onChanged: (value) {
                  setState(() {
                    _address = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                onChanged: (value) {
                  setState(() {
                    _city = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Postal Code'),
                onChanged: (value) {
                  setState(() {
                    _postalCode = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Country'),
                onChanged: (value) {
                  setState(() {
                    _country = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your country';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(
                          address: _address,
                          city: _city,
                          postalCode: _postalCode,
                          country: _country,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Continue to Payment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
