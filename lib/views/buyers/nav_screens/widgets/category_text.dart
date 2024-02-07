//import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../cart_screen.dart';

class CategoryText extends StatefulWidget {
  @override
  _CategoryTextState createState() => _CategoryTextState();
}

class _CategoryTextState extends State<CategoryText> {
  String selectedCategory = ""; // Track the selected category
  List<ProductInfo> cartItems = []; // Track items in the cart

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Categories',
            style: TextStyle(fontSize: 19),
          ),
          FutureBuilder(
            future: _getCategories(),
            builder: (context, AsyncSnapshot<List<String>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<String> categories = snapshot.data ?? [];

                return Container(
                  height: 100,
                  child: Row(
                    children: [

                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ActionChip(
                                backgroundColor: selectedCategory == categories[index]
                                    ? Colors.green // Highlight the selected category
                                    : Colors.yellow.shade900,
                                onPressed: () {
                                  setState(() {
                                    selectedCategory = categories[index];
                                  });
                                },
                                label: Center(
                                  child: Text(
                                    categories[index],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Products',
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(width: 170,),
              ElevatedButton(
                onPressed: () {
                  _viewAllProducts();
                },
                child: Text('View All'),
              ),
            ],
          ),
          // Inside your CategoryText widget
          FutureBuilder(
            future: _getProducts(selectedCategory),
            builder: (context, AsyncSnapshot<List<ProductInfo>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<ProductInfo> products = snapshot.data ?? [];

                return Column(
                  children: [
                    Wrap(
                      spacing: 18.0,
                      runSpacing: 18.0,
                      children: products.map((product) {
                        bool isInCart = cartItems.contains(product);

                        return ProductCard(
                          id: product.id,
                          productName: product.name,
                          imageUrls: product.imageUrls,
                          category: product.category,
                          addToCart: (bool isInCart) {
                            setState(() {
                              if (isInCart) {
                                cartItems.remove(product);
                              } else {
                                cartItems.add(product);
                              }
                            });
                          },
                          isInCart: isInCart,
                        );
                      }).toList(),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }


  Future<void> _viewAllProducts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('products')
          .where('approved', isEqualTo: true)
          .get();

      List<ProductInfo> allProducts = snapshot.docs.map((doc) {
        return ProductInfo(
          id: doc.id,
          name: doc['productName'] as String,
          imageUrls: List<String>.from(doc['imageUrls'] as List<dynamic>),
          category: doc['category'] as String,
        );
      }).toList();

      setState(() {
        // Update the product list with all approved products
        // and clear the selected category
        selectedCategory = "";
        cartItems.clear();
      });

    } catch (error) {
      print('Error fetching all products: $error');
    }
  }


  Future<List<String>> _getCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection('categorise').get();

      List<String> categories = snapshot.docs
          .map((doc) => doc['cartName'] as String)
          .toList();

      return categories;
    } catch (error) {
      print('Error fetching categories: $error');
      return [];
    }
  }

  Future<List<ProductInfo>> _getProducts(String category) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot;
      CollectionReference<Map<String, dynamic>> productsCollection =
      FirebaseFirestore.instance.collection('products');

      if (category.isNotEmpty) {
        // Fetch products based on category and approval status
        snapshot = await productsCollection
            .where('category', isEqualTo: category)
            .where('approved', isEqualTo: true)
            .get();
      } else {
        // Fetch all approved products when no category is selected
        snapshot = await productsCollection
            .where('approved', isEqualTo: true)
            .get();
      }
      print('Selected Category: $category');
      print('Document data count: ${snapshot.docs.length}');
      List<ProductInfo> products = snapshot.docs.map((doc) {
        print('Document ID: ${doc.id}'); // Print product ID for debugging
        print('Document data: ${doc.data()}'); // Print document data for debugging
        return ProductInfo(
          id: doc.id, // Include product ID
          name: doc['productName'] as String,
          imageUrls: List<String>.from(doc['imageUrls'] as List<dynamic>),
          category: doc['category'] as String,
        );
      }).toList();

      return products;
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }
}

class ProductInfo {
  final String id;
  final String name;
  final List<String> imageUrls;
  final String category;

  ProductInfo({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.category,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductInfo &&
        other.id == id &&
        other.name == name &&
        other.category == category &&
        listEquals(other.imageUrls, imageUrls);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ category.hashCode ^ imageUrls.hashCode;
}



class ProductCard extends StatelessWidget {
  final String id;
  final String productName;
  final List<String> imageUrls;
  final String category;
  final Function(bool) addToCart;
  final bool isInCart;

  ProductCard({
    required this.id,
    required this.productName,
    required this.imageUrls,
    required this.category,
    required this.addToCart,
    required this.isInCart,
  });

  void _showProductDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(productInfo: ProductInfo(
          id: id,
          name: productName,
          imageUrls: imageUrls,
          category: category,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () {
          _showProductDetails(context);
        },
        child: Column(
          children: [
            if (imageUrls.isNotEmpty)
              Image.network(
                imageUrls[0],
                height: 180,
                width: 120,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                productName,
                style: TextStyle(fontSize: 16),
              ),
            ),
            IconButton(
              onPressed: () {
                addToCart(!isInCart);
              },
              icon: Icon(isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart),
            ),
          ],
        ),
      ),
    );
  }
}
