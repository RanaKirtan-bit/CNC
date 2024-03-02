import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/product_provider.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      // Handle tab changes if needed
    });

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
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Published'),
            Tab(text: 'Unpublished'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(isApproved: true),
          _buildProductList(isApproved: false),
        ],
      ),
    );
  }

  Widget _buildProductList({required bool isApproved}) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, _) {
        List<Map<String, dynamic>> products =
            productProvider.productDataList;

        List<Map<String, dynamic>> filteredProducts = products
            .where((product) => (product['approved'] == isApproved))
            .toList();

        return ListView.builder(
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> product = filteredProducts[index];

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
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editProduct(context, productProvider, product, index);
                },
              ),

              leading: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Call a method in your provider to delete the product
                  productProvider.deleteProduct(index);
                },
              ),

            );
          },
        );
      },
    );
  }
}

  void _editProduct(BuildContext context, ProductProvider productProvider,
      Map<String, dynamic> product, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Add form fields for editing product details
                    TextFormField(
                      initialValue: product['productName'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          product['productName'] = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Product Name'),
                    ),
                    TextFormField(
                      initialValue: product['regularPrice']?.toString() ?? '',
                      onChanged: (value) {
                        setState(() {
                          product['regularPrice'] = double.parse(value);
                        });
                      },
                      decoration: InputDecoration(labelText: 'Regular Price'),
                    ),
                    TextFormField(
                      initialValue: product['brand'] ?? '',
                      onChanged: (value) {
                        setState(() {
                          product['brand'] = value;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Brand'),
                    ),
                    // Add other form fields as needed

                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        // Save the changes
                        productProvider.updateProduct(index, product);
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



