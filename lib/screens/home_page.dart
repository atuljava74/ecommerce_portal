import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_portal/screens/profile_page.dart';
import 'package:ecommerce_portal/utils/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../blocs/orders/orders_bloc.dart';
import '../blocs/orders/orders_event.dart';
import '../models/category_model.dart';
import '../utils/user_session.dart';
import '../widgets/custom_app_bar.dart';
import 'cart_page.dart';
import 'login.dart';
import 'my_order_page.dart';
import 'subcategory_page.dart'; // Import SubcategoryPage

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: BlocProvider(
        create: (context) => CategoryBloc()..add(LoadCategories()),
        child: CategoryList(),
      ),
    );
  }

  getAppBar(context) {
    return AppBar(
      elevation: 3,
      backgroundColor : Colors.white,
      leading: Container( margin: EdgeInsets.only(left: 15),
        child: Image.asset(
          'assets/top_logo.png', // Add your image to the assets folder and update this path
          height: 60,
        ),
      ),
      title: Container(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            filled: false, // No background color filled inside the text field
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1), // Light border color
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[400]!, width: 1), // Slightly darker border on focus
            ),
          ),
          onSubmitted: (query) {
            // Handle the search query submission
            print('Search query: $query');
          },
        ),
      ),

      actions: <Widget>[
        // Shopping Cart Icon with Item Count
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return IconButton(
              icon: Stack(
                children: <Widget>[
                  const Icon(Icons.shopping_cart_outlined, color: AppConfig.themeColor, size: 30,),
                  if (state is CartLoaded && state.cartItems.isNotEmpty)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Text(
                          '${state.cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
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
            return { 'My Orders', 'Logout'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
          icon: const Icon(Icons.more_horiz, size: 30, color: AppConfig.themeColor,),
        ),
      ],
    );
  }
}

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CategoryLoaded) {
          return GridView.builder(
            padding: const EdgeInsets.all(5.0),
            itemCount: state.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, // Number of columns
              childAspectRatio: 3 / 2, // Width to height ratio
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (ctx, index) {
              final category = state.categories[index];
              return CategoryItem(category: category);
            },
          );
        } else if (state is CategoryError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No categories available.'));
        }
      },
    );
  }
}
class CategoryItem extends StatelessWidget {
  final Category category;

  const CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubcategoryPage(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: category.imageUrl,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                      errorWidget: (context, url, error) => const Icon(Icons.broken_image,size: 50,
                        color: Colors.grey,),
                    ),
                  ),
                ),
              ],
            ),
            // Circular Gradient Bubble at the Bottom

          ],
        ),
      ),
    );
  }
}


