import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:flutter/material.dart';

import '../../../models/product_model.dart';

class CartScreen extends StatelessWidget {
  final List<Product> cartItems;

  CartScreen({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            //title: Text(cartItems[index].productName),
            subtitle: Text('Category: ${cartItems[index].category}'),
          );
        },
      ),
    );
  }
}

