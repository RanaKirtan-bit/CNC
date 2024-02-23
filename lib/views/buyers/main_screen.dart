import 'package:clickncart/views/buyers/auth/login_screen.dart';
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
          future: AuthController().fetchUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null) {
                UserDetails userDetails = snapshot.data!;
                return CartScreen(userDetails: userDetails);
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Please log in to view your cart.',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the login screen
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          }));
                        },
                        child: Text('Log In'),
                      ),
                    ],
                  ),
                );
              }
            } else {
              // Loading indicator while waiting for the future to complete
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
