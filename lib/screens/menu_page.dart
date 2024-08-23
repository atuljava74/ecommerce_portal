import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';
import '../models/category_model.dart';
import '../widgets/custom_app_bar.dart';
import 'subcategory_page.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBar(title: 'Categories'),
      body: BlocProvider(
        create: (context) => CategoryBloc()..add(LoadCategories()),
        child: CategoryList(),
      ),
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
          return ListView.builder(
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return ListTile(
                title: Text(category.name),
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
              );
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
