//import 'package:clickncart/views/seller/seller_screens/past_orders_screen.dart';
import 'package:clickncart/views/seller/seller_screens/seller_product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/seller_provider.dart';
import '../../buyers/nav_screens/store_screen.dart';
import '../seller_screens/add_product_screen.dart';
import '../seller_screens/product_screen.dart';
import '../seller_screens/vendor_home.dart'; // Import your SellerProvider


class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the Provider to get an instance of SellerProvider
    SellerProvider? sellerProvider = Provider.of<SellerProvider?>(context);
    if (sellerProvider != null) {
      print(
          "Shop Name: ${sellerProvider.doc?.get('shopName')}"); // Add this line


      return Drawer(
        child: Column(
          children: [
            Container(
              height: 96,
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Row(
                children: [
                  DrawerHeader(
                    child: Text(
                      // Access the shop name from the SellerProvider's _doc property
                      sellerProvider.doc?['shopName'] ?? ' Default Shop Name ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.home_outlined),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return SellerHome();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text('Products'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return ProductListScreen();
                      }));
                    },
                  ),
                  // Placeholder for creating products, you can replace this with your logic
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add Product'),
                    onTap: () {
                      // Navigate to the screen where you can add a new product
                      // Replace ProductAddScreen with the actual screen for adding products
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return AddProductScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text('show orders'),
                    onTap: () {
                      // Navigate to the screen where you can add a new product
                      // Replace ProductAddScreen with the actual screen for adding products
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) {
                        return SellerProductsPage(sellerId: 'Anpe2JAKiOgCEeJzFrEwfGLlxPx1');
                      }));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    else {
      return CircularProgressIndicator(); // Add a loading indicator or handle the case when the sellerProvider is null.
    }
  }
}
