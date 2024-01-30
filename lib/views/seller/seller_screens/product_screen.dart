import 'package:flutter/material.dart';

import '../seller_widget/custom_drawer.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Product Screen'),
        elevation: 0,
      ),
      drawer: CustomDrawer(),
      body: Center(child: Text('Product Screen'),),
    );
  }
}
