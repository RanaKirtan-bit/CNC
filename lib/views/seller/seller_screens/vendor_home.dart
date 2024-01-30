import 'package:flutter/material.dart';

import '../seller_widget/custom_drawer.dart';

class SellerHome extends StatelessWidget {
  static const String id = 'seller_Home';

  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Dashboard'),
      ),
      drawer: CustomDrawer(),

      body: Center(child: Text('Dashboard', style: TextStyle(fontSize: 22),),),

    );
  }
}
