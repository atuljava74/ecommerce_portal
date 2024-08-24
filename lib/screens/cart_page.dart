import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_portal/screens/shipping_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_event.dart';
import '../blocs/cart/cart_state.dart';
import '../models/cart_model.dart';
import '../screens/product_detail_page.dart';
import '../utils/app_config.dart';
import '../widgets/custom_app_bar.dart';
import 'order_summary_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Your Cart'),
      body: Stack(
        children: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is CartLoaded) {
                if (state.cartItems.isEmpty) {
                  return Center(child: Text('Your cart is empty.'));
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 10, bottom: 80.0), // Space for the checkout button
                  itemCount: state.cartItems.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.grey[300], thickness: 1),
                  itemBuilder: (context, index) {
                    final cartItem = state.cartItems[index];

                    return Dismissible(
                      key: Key(cartItem.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        context.read<CartBloc>().add(RemoveFromCart(cartItem.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${cartItem.name} removed from cart')),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: cartItem.imageUrl, height: 60, fit: BoxFit.fitHeight,
                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image,size: 50,
                              color: Colors.grey,),
                          ),
                          title: Text(cartItem.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          subtitle: Text('₹${cartItem.price.toStringAsFixed(2)} x ${cartItem.quantity}'),
                          trailing: Text('₹${cartItem.subtotal.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onTap: () {
                          },
                        ),
                      ),
                    );
                  },
                );
              } else if (state is CartError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text('No items in your cart.'));
              }
            },
          ),
          // Sticky Checkout Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      BlocBuilder<CartBloc, CartState>(
                        builder: (context, state) {
                          if (state is CartLoaded) {
                            return Text(
                              '₹${state.total.toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }
                          return Text('₹0.00');
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShippingInfoPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.themeColor,
                      minimumSize: Size(150, 50), // Size of the button
                    ),
                    child: const Text(
                      'Proceed to Checkout',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
