//import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:clickncart/models/category_model.dart';
import 'package:clickncart/views/buyers/main_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/home_productList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../../../models/product_model.dart';
import '../cart_screen.dart';

// import statements...

class CategoryWidget extends StatefulWidget {
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String _selectedCategory = '';
  bool _showAllProducts = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 18,),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products for you',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = ''; // Show all products
                      _showAllProducts = true;
                    });
                  },
                  child: Text(
                    'View all..',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: FirestoreListView<Category>(
                      scrollDirection: Axis.horizontal,
                      query: categoryCollection,
                      itemBuilder: (context, snapshot) {
                        Category category = snapshot.data();
                        bool isSelected = _selectedCategory == category.cartName;
                        return Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: ActionChip(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            backgroundColor: isSelected
                                ? Colors.green // Selected category color
                                : Colors.red,
                            label: Text(
                              category.cartName!,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.black // Text color for selected category
                                    : Colors.white,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedCategory = category.cartName!;
                                _showAllProducts = false; // Hide all products
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey.shade400),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) =>
                          const MainScreen()),
                        );
                      },
                      icon: Icon(IconlyLight.arrowDown),
                    ),
                  )
                ],
              ),
            ),
          ),
          HomeProductList(
            category: _showAllProducts ? null : _selectedCategory,
          ),
        ],
      ),
    );
  }
}
