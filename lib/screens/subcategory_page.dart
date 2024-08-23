import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/subcategory/subcategory_bloc.dart';
import '../blocs/subcategory/subcategory_event.dart';
import '../blocs/subcategory/subcategory_state.dart';
import '../models/subcategory_model.dart';
import '../widgets/custom_app_bar.dart';
import 'product_listing_page.dart';

class SubcategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const SubcategoryPage({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: categoryName
      ),
      body: BlocProvider(
        create: (context) => SubcategoryBloc()..add(LoadSubcategories(categoryId)),
        child: SubcategoryList(),
      ),
    );
  }
}

class SubcategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryBloc, SubcategoryState>(
      builder: (context, state) {
        if (state is SubcategoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is SubcategoryLoaded) {
          if (state.subcategories.isEmpty) {
            // If no subcategories, navigate directly to ProductListingPage
            return const Center(
              child: Text('No subcategories found.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: state.subcategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 3 / 4, // Width to height ratio
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) {
              final subcategory = state.subcategories[index];
              return SubcategoryItem(subcategory: subcategory);
            },
          );
        } else if (state is SubcategoryError) {
          return Center(child: Text(state.message));
        } else {
          return Center(child: Text('No subcategories available.'));
        }
      },
    );
  }
}

class SubcategoryItem extends StatelessWidget {
  final Subcategory subcategory;

  const SubcategoryItem({required this.subcategory});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ProductListingPage when a subcategory is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListingPage(
              subcategoryId: subcategory.id,
              subcategoryName: subcategory.name,
            ),
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
              child: ClipRRect(
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  subcategory.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                subcategory.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
