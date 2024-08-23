import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/orders/orders_bloc.dart';
import '../blocs/orders/orders_event.dart';
import '../screens/my_order_page.dart';
import '../screens/profile_page.dart';
import '../screens/cart_page.dart';
import '../screens/login.dart';
import '../utils/app_config.dart';
import '../utils/user_session.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 3,
      iconTheme: const IconThemeData(
        color: AppConfig.themeColor, // Set the color of the back arrow here
      ),
      backgroundColor :Colors.white,
      title: Text(title),
      actions: <Widget>[
        // Shopping Cart Icon with Item Count
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return IconButton(
              icon: Stack(
                children: <Widget>[
                  const Icon(Icons.shopping_cart_outlined, color: AppConfig.themeColor, size: 35,),
                  if (state is CartLoaded && state.cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Text(
                          '${state.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                // Navigate to Cart Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage()),
                );
              },
            );
          },
        ),
        // 3 Vertical Dot Menu Icon
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'Profile':
              // Navigate to Profile Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
                break;
              case  'My Orders' :
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => OrdersBloc()..add(LoadOrders(UserSession.userId!)),
                      child: MyOrdersPage(),
                    ),
                  ),
                );
                break;
              case 'Logout':
              // Log out and navigate to Login Page
                context.read<AuthBloc>().add(AuthLogoutRequested());
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Profile', 'My Orders', 'Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          icon: Icon(Icons.more_horiz, color: AppConfig.themeColor, size: 30,),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
