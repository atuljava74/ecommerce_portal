import 'package:ecommerce_portal/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../models/product_model.dart';
import 'product_detail_page.dart';

class ProductListingPage extends StatelessWidget {
  final String subcategoryId;
  final String subcategoryName;

   const ProductListingPage({super.key,
    required this.subcategoryId,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: subcategoryName,
      ),
      body: BlocProvider(
        create: (context) => ProductBloc()..add(LoadProducts(subcategoryId)),
        child: ProductList(), // Pass userId to ProductList
      ),
    );
  }
}

class ProductList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return Center(child: Text('No products available.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(5.0),
            itemCount: state.products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 2 / 3, // Width to height ratio
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              final product = state.products[index];
              return ProductItem(product: product); // Pass userId to ProductItem
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No products available.'));
        }
      },
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  const ProductItem({required this.product}); // Receive userId

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductDetailPage when a product is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.fitHeight,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '\$${product.price}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
