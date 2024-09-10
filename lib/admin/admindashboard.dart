import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'categorypage.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Handle logout
            },
          ),
        ],
      ),
      body: ScreenTypeLayout(
        mobile: MobileDashboard(),
        tablet: DesktopDashboard(),
        desktop: DesktopDashboard(),
      ),
    );
  }
}

class MobileDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(16),
            child: ListView(
              children: const [
                ListTile(title: Text('Home')),
                ListTile(title: Text('Add/Edit/Delete Category')),
                ListTile(title: Text('Add/Edit/Delete Subcategory')),
                ListTile(title: Text('Add Product')),
                ListTile(title: Text('Report')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class DesktopDashboard extends StatefulWidget {
  @override
  _DesktopDashboardState createState() => _DesktopDashboardState();
}

class _DesktopDashboardState extends State<DesktopDashboard> {
  int _selectedIndex = 0; // Track the selected index

  // Define a method to return the widget based on the selected index
  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return Home();
      case 1:
        return CategoryPage();
      case 2:
        return SubcategoryPage();
      case 3:
        return AddProductPage();
      case 4:
        return ReportPage();
      default:
        return Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          backgroundColor: Colors.white,
          extended: true,
          destinations: [
            NavigationRailDestination(
              icon: const Icon(Icons.home),
              label: Container(
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.category),
              label: Container(
                child: Text(
                  'Add/Edit/Delete Category',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.subdirectory_arrow_right),
              label: Text(
                'Add/Edit/Delete Subcategory',
                style: TextStyle(
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.add_box),
              label: Text(
                'Add Product',
                style: TextStyle(
                  color: _selectedIndex == 3 ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            NavigationRailDestination(
              icon: const Icon(Icons.report),
              label: Text(
                'Report',
                style: TextStyle(
                  color: _selectedIndex == 4 ? Colors.blue : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          selectedIndex: _selectedIndex, // Highlight the selected item
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected index
            });
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.grey[200],
              child: Center(
                child: _getSelectedPage(), // Display the selected page
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Define the different pages to be displayed in the sidebar

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Home Page'));
  }
}

// class CategoryPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text('Add/Edit/Delete Category'));
//   }
// }

class SubcategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Add/Edit/Delete Subcategory'));
  }
}

class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Add Product'));
  }
}

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Report Page'));
  }
}
