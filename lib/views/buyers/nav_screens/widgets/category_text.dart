import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
                      IconButton(
                        onPressed: () {
                          // Add selected products to the cart
                          if (selectedCategory.isNotEmpty) {
                            List<ProductInfo> productsToAdd = cartItems
                                .where((item) => item.category == selectedCategory)
                                .toList();
                            cartItems.addAll(productsToAdd);
                          }
                        },
                        icon: Icon(Icons.shopping_cart),
                      ),
                      // Add the cart icon here
                    ],
                  ),
                );
              }
            },
          ),
          SizedBox(height: 20),
          Text(
            'Products',
            style: TextStyle(fontSize: 19),
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

                return Wrap(
                  spacing: 18.0, // Adjust the spacing as needed
                  runSpacing: 18.0, // Adjust the run spacing as needed
                  children: products.map((product) {
                    return ProductCard(
                      productName: product.name,
                      imageUrls: product.imageUrls,
                      category: product.category,
                      addToCart: () {
                        setState(() {
                          cartItems.add(product);
                        });
                      },
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
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

      List<ProductInfo> products = snapshot.docs.map((doc) {
        print('Document data: ${doc.data()}'); // Print document data for debugging
        return ProductInfo(
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
  final String name;
  final List<String> imageUrls;
  final String category;

  ProductInfo({required this.name, required this.imageUrls, required this.category});
}

class ProductCard extends StatelessWidget {
  final String productName;
  final List<String> imageUrls;
  final String category;
  final VoidCallback addToCart;

  ProductCard({required this.productName, required this.imageUrls, required this.category, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          if (imageUrls.isNotEmpty) // Check if imageUrls is not empty
            Image.network(
              imageUrls[0], // Display the first image
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
            onPressed: addToCart,
            icon: Icon(Icons.add_shopping_cart),
          ),
        ],
      ),
    );
  }
}

