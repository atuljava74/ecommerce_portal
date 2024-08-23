import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../models/cart_model.dart';
import 'order_confirmation_page.dart';

class OrderSummaryPage extends StatelessWidget {
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String paymentMethod;

  OrderSummaryPage({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is OrderSubmitted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order Confirmed!')),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => OrderConfirmationPage(orderId: state.orderId)),
                (route) => false,
          );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to place order: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Summary'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Shipping Address: $address, $city, $postalCode, $country'),
                    SizedBox(height: 10),
                    Text('Payment Method: $paymentMethod'),
                    SizedBox(height: 20),
                    Text('Order Items:'),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.cartItems.length,
                        itemBuilder: (context, index) {
                          final CartItem item = state.cartItems[index];
                          return ListTile(
                            leading: Image.network(item.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            title: Text(item.name),
                            subtitle: Text('Quantity: ${item.quantity}'),
                            trailing: Text('\$${item.subtotal.toStringAsFixed(2)}'),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Total: \$${state.total.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(SubmitOrder(
                          address: address,
                          city: city,
                          postalCode: postalCode,
                          country: country,
                          paymentMethod: paymentMethod,
                          cartItems : state.cartItems,
                          total : state.total.toStringAsFixed(2)
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Full-width button
                      ),
                      child: const Text('Confirm Order'),
                    ),
                  ],
                );
              } else if (state is CartLoading) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(child: Text('Failed to load cart items.'));
              }
            },
          ),
        ),
      ),
    );
  }
}
