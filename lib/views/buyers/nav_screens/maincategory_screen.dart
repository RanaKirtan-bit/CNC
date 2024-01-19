import 'package:clickncart/views/buyers/nav_screens/subcategory_screen.dart';
import 'package:flutter/material.dart';

import '../../../firebase_service.dart';

class CustomerMainCategoryScreen extends StatefulWidget {
  @override
  _CustomerMainCategoryScreenState createState() => _CustomerMainCategoryScreenState();
}

class _CustomerMainCategoryScreenState extends State<CustomerMainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  List<String> mainCategories = [];
  String? selectedMainCategory;

  @override
  void initState() {
    super.initState();
    _loadMainCategories();
  }

  _loadMainCategories() async {
    List<String> categories = await _service.getMainCategories();
    setState(() {
      mainCategories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Categories'),
      ),
      body: mainCategories.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: mainCategories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(mainCategories[index]),
            onTap: () {
              // Set the selectedMainCategory when a category is tapped
              setState(() {
                selectedMainCategory = mainCategories[index];
              });

              // Navigate to the subcategory screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategoryScreen(
                    mainCategory: selectedMainCategory!, subCategory: '',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
