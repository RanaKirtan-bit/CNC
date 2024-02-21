import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:clickncart/firebase_service.dart';

import '../seller_widget/custom_drawer.dart';

class SellerHome extends StatelessWidget {
  static const String id = 'seller_Home';

  const SellerHome({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        String sellerId = ''; // Set the actual sellerId here

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Dashboard'),
          ),
          drawer: CustomDrawer(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Seller's Sold Products",
                style: TextStyle(fontSize: 22),
              ),
              // Display the fetched sold products here
              Expanded(
                child: FutureBuilder(
                  // Fetch sold products using FirebaseService with the sellerId
                  future: FirebaseService().getSellerSoldProducts(sellerId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Map<String, dynamic>> soldProducts = snapshot.data as List<Map<String, dynamic>>;

                      return ListView.builder(
                        itemCount: soldProducts.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> productData = soldProducts[index];

                          return ListTile(
                            title: Text(productData['productName']),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Price: ${productData['salesPrice']}'),
                                // Display buyer information
                                // Add more details as needed
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
