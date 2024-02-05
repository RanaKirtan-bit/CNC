import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch products when the screen is initialized
    ProductProvider productProvider =
    Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, _) {
          List<Map<String, dynamic>> products =
              productProvider.productDataList;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> product = products[index];

              // Check if the product is approved
              bool isApproved = product['approved'] ?? false;

              // Only display approved products
              if (isApproved) {
                return ListTile(
                  title: Text(product['productName'] ?? 'No Name'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Regular Price: ${product['regularPrice'] ?? 'N/A'}'),
                      Text('Brand: ${product['brand'] ?? 'N/A'}'),
                      // Display product images
                      SizedBox(
                        height: 80, // Adjust the height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: product['imageUrls']?.length ?? 0,
                          itemBuilder: (context, imgIndex) {
                            return Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Image.network(
                                product['imageUrls'][imgIndex],
                                width: 60, // Adjust the width as needed
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Add other product details as needed
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Call a method in your provider to delete the product
                      productProvider.deleteProduct(index);
                    },
                  ),
                );
              } else {
                // If the product is not approved, return an empty container
                return Container();
              }
            },
          );
        },
      ),
    );
  }
}
