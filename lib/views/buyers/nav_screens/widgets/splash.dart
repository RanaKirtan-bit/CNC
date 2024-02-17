import 'package:clickncart/views/buyers/auth/login_screen.dart';
import 'package:clickncart/views/buyers/main_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/account_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/cart_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/category_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/home_screen.dart';
import 'package:clickncart/views/seller/seller_auth/login_screen.dart';
import 'package:clickncart/views/seller/seller_screens/add_product_screen.dart';
import 'package:flutter/material.dart';

import '../../../seller/seller_screens/vendor_home.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
    void initState() {
    super.initState();
    _navigatehome();
  }

  _navigatehome() async {
    await Future.delayed(Duration(seconds: 2), ()  {} );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(

        ),
      ),);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/Click & cart.png',fit: BoxFit.cover,),
              ],
            ),
        ),
    );
  }
}


