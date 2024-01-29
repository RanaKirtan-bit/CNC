import 'package:flutter/material.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
            begin: FractionalOffset(0.5, 0.7),
          )
      ),
      child: Center(
        child: Text('Seller screen'),
      ),
    );
  }
}
