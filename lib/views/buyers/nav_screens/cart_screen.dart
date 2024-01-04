import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
                    begin: FractionalOffset(0.5, 0.7),
                  )
              ),
            ),
    );
  }
}
