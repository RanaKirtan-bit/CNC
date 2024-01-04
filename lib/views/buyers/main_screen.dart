

import 'package:clickncart/views/buyers/nav_screens/account_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/cart_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/category_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/home_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/search_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
int  _pageIndex = 0;

List<Widget>  _pages  =  [
  HomeScreen(),
  CategoryScreen(),
  StoreScreen(),
  CartScreen(),
  SearchScreen(),
  AccountScreen(),
];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
            begin: FractionalOffset(0.5, 0.7),
          )
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value){
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.deepPurple,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.home),label:  'HOME',),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/explore.svg',
            width: 20,
          ),
            label:  'CATEGORIES',
          ),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/shop.svg',
              width: 20,
            ),
              label:  'SHOP',
            ),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/shopping_cart.svg',
              width: 20,
            ),
              label:  'CART',
            ),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/search.svg',
              width: 20,
            ),
              label:  'SEARCH',
            ),
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/account.svg',
              width: 20,
            ),
              label:  'ACCOUNTS',
            ),
        ],),
            body: _pages [_pageIndex],
      ),
    );
  }
}
