import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clickncart/views/buyers/nav_screens/account_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/cart_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/category_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/home_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/search_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/store_screen.dart';
import '../../controllers/auth_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA6F1DF), Color(0xFFFFBBBB)],
          begin: FractionalOffset(0.5, 0.7),
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.deepPurple,
          selectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'HOME',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/explore.svg',
                width: 20,
              ),
              label: 'CATEGORIES',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/shop.svg',
                width: 20,
              ),
              label: 'ORDERS',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/shopping_cart.svg',
                width: 20,
              ),
              label: 'CART',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/search.svg',
                width: 20,
              ),
              label: 'SEARCH',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/account.svg',
                width: 20,
              ),
              label: 'ACCOUNTS',
            ),
          ],
        ),
        body: _buildPage(_pageIndex),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return CategoryScreen();
      case 2:
        return OrderScreen();
      case 3:
        return FutureBuilder<UserDetails?>(
          // Assuming you have a method to fetch user details, modify it accordingly
          future: AuthController().fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CartScreen(userDetails: snapshot.data!);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      case 4:
        return SearchScreen();
      case 5:
        return AccountScreen();
      default:
        return Container();
    }
  }
}
