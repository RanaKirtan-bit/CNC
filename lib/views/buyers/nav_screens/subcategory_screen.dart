import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  final String mainCategory;
  final String subCategory;

  SubCategoryScreen({required this.mainCategory, required this.subCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcategory: $subCategory'),
      ),
      body: Center(
        child: Text(
          'Content for Subcategory: $subCategory\nMain Category: $mainCategory',
        ),
      ),
    );
  }
}
