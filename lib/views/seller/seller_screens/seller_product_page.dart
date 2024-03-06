import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../firebase_service.dart';

class SellerProductsPage extends StatefulWidget {
  final String sellerId;

  SellerProductsPage({required this.sellerId});

  @override
  _SellerProductsPageState createState() => _SellerProductsPageState();
}

class _SellerProductsPageState extends State<SellerProductsPage> {
  final FirebaseService _firebaseService = FirebaseService();

  List<Map<String, dynamic>> _soldProducts = [];

  @override
  void initState() {
    super.initState();
    _loadSoldProducts();
  }

  Future<void> _loadSoldProducts() async {
    try {
      // Retrieve the currently logged-in user
      User? user = FirebaseAuth.instance.currentUser;

      // Check if the user is authenticated
      if (user != null) {
        // Get the seller ID from the authenticated user
        String sellerId = user.uid;

        // Fetch the seller's sold products using the seller ID
        List<Map<String, dynamic>> soldProducts =
        await _firebaseService.getSellerSoldProducts(sellerId);

        setState(() {
          _soldProducts = soldProducts;
        });
      } else {
        print('User not authenticated');
      }
    } catch (error) {
      print('Error loading sold products: $error');
    }
  }


  Future<Map<String, dynamic>> getBuyerDetails(String buyerId) async {
    try {
      Map<String, dynamic>? buyerDetails =
      await _firebaseService.getBuyerDetailsById(buyerId);
      return buyerDetails ?? {};
    } catch (error) {
      print('Error loading buyer details: $error');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sold Products'),
          backgroundColor: Colors.teal,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Active'), // Tab for 'Active' status
              Tab(text: 'Cancelled'), // Tab for 'Cancelled' status
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab View for 'Active' status
            _buildSoldProductsList(status: 'active'),
            // Tab View for 'Cancelled' status
            _buildSoldProductsList(status: 'Cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldProductsList({required String status}) {
    List<Map<String, dynamic>> filteredProducts = _soldProducts
        .where((product) => product['status'] == status)
        .toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> soldProduct = filteredProducts[index];
        String buyerId = soldProduct['buyerId'];
        Future<Map<String, dynamic>> buyerDetails = getBuyerDetails(buyerId);

        return Card(
          margin: EdgeInsets.all(10),
          elevation: 4,
          child: FutureBuilder<Map<String, dynamic>>(
            future: buyerDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error loading buyer details: ${snapshot.error}');
              } else {
                Map<String, dynamic> buyer = snapshot.data ?? {};
                String shopName = buyer['shopName'] ?? 'N/A';

                return ListTile(
                  title: Text(
                    soldProduct['productName'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales Price: \$${soldProduct['salesPrice']}',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        'Buyer Name: ${buyer['fullName']}',
                        style: TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Buyer\'s Delivery Address: ${buyer['address']}',
                        style: TextStyle(color: Colors.deepOrange),
                      ),
                      Text(
                        'Order Status: ${soldProduct['status']}',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Buyer Information'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Full Name: ${buyer['fullName']}'),
                              Text('Full Name: ${soldProduct['productName']}'),
                              Text('Address: ${buyer['address']}'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
