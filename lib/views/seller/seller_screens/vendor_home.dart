import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/product_provider.dart';
// Adjust the import based on your project structure

import '../seller_widget/custom_drawer.dart';

class SellerHome extends StatelessWidget {

  static const String id = 'seller_Home';

  const SellerHome({super.key});

  // Inside SellerHome
  @override
  Widget build(BuildContext context) {

    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        productProvider.fetchSoldProducts();
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
                'Dashboard',
                style: TextStyle(fontSize: 22),
              ),
              // Display the fetched products here
              // For example, you might use a ListView.builder
              Expanded(
                child: ListView.builder(
                  itemCount: productProvider.productDataList.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> productData = productProvider.productDataList[index];

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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}