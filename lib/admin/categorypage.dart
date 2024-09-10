import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Electronics', 'icon': Icons.electrical_services},
    {'id': 2, 'name': 'Clothing', 'icon': Icons.shopping_bag},
    {'id': 3, 'name': 'Books', 'icon': Icons.book},
  ]; // This would typically come from your backend

  void _addCategory() {
    // Function to handle adding a new category
    // Navigate to a form page or show a dialog
  }

  void _editCategory(int id) {
    // Function to handle editing a category
    // Navigate to a form page or show a dialog with pre-filled data
  }

  void _deleteCategory(int id) {
    // Function to handle deleting a category
    setState(() {
      _categories.removeWhere((category) => category['id'] == id);
    });
    // Perform a DELETE request to your backend here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return ListTile(
                leading: Icon(category['icon']),
                title: Text(category['name']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editCategory(category['id']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteCategory(category['id']),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        FloatingActionButton(
          onPressed: _addCategory,
          child: Icon(Icons.add),
        ),
      ],
    );
  }
}
