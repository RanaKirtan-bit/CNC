import 'package:clickncart/views/seller/seller_widget/custom_drawer.dart';
import 'package:flutter/material.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Add Product Screen'),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: Center(child: Text('Add Products Screen'),),
    );
  }
}
