import 'package:ecommerce_portal/screens/shipping_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/cart/cart_event.dart';
import '../utils/user_session.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: BlocProvider(
        create: (context) => CartBloc()..add(LoadCart(UserSession.userId!)),
        child: CartView(),
      ),
    );
  }
}

class CartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CartLoaded) {
          if (state.cartItems.isEmpty) {
            return Center(child: Text('Your cart is empty.'));
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = state.cartItems[index];
                    return ListTile(
                      leading: Image.network(item.imageUrl, width: 50, height: 50),
                      title: Text(item.name),
                      subtitle: Text('Quantity: ${item.quantity}'),
                      trailing: Text('\$${item.subtotal.toStringAsFixed(2)}'),
                      onLongPress: () {
                        // Remove item from cart on long press
                        context.read<CartBloc>().add(RemoveFromCart(item.id));
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${state.total.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShippingInfoPage()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Proceeding to checkout...')),
                    );
                    // You can navigate to a checkout page or trigger a checkout flow here
                  },
                  child: Text('Proceed to Checkout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                ),
              ),
            ],
          );
        } else if (state is CartError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('Failed to load cart.'));
        }
      },
    );
  }
}
