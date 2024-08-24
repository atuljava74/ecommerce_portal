import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../models/cart_model.dart';
import '../widgets/custom_app_bar.dart';
import '../utils/app_config.dart';
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
        appBar: CustomAppBar(
          title: 'Order Summary',
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shipping Address',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text('$address, \n$city, $postalCode, \n$country'),
                        SizedBox(height: 15),
                        Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text('$paymentMethod'),
                        SizedBox(height: 15),
                        Text(
                          'Order Items',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.cartItems.length,
                            itemBuilder: (context, index) {
                              final CartItem item = state.cartItems[index];
                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: ListTile(
                                  contentPadding: EdgeInsets.only(left: 0 , top:5 , bottom :2, right: 10),
                                  leading: CachedNetworkImage(
                                    imageUrl: item.imageUrl,
                                    height: 60,
                                    fit: BoxFit.fitHeight,
                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                    errorWidget: (context, url, error) => const Icon(Icons.broken_image,size: 50,
                                      color: Colors.grey,),
                                  ),
                                  title: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Quantity: ${item.quantity}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    '₹${item.subtotal.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 100), // Space for the button
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
            // Sticky Total and Confirm Order Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        BlocBuilder<CartBloc, CartState>(
                          builder: (context, state) {
                            if (state is CartLoaded) {
                              return Text(
                                '₹${state.total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppConfig.themeColor,
                                ),
                              );
                            }
                            return Text('₹0.00');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(SubmitOrder(
                          address: address,
                          city: city,
                          postalCode: postalCode,
                          country: country,
                          paymentMethod: paymentMethod,
                          cartItems: (context.read<CartBloc>().state as CartLoaded).cartItems,
                          total: (context.read<CartBloc>().state as CartLoaded).total.toStringAsFixed(2),
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConfig.themeColor,
                        minimumSize: Size(double.infinity, 50), // Full-width button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: Text(
                        'Confirm Order',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
