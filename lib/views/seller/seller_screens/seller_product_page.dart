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
    String sellerId = widget.sellerId; // Use the sellerId passed to the widget
    try {
      List<Map<String, dynamic>> soldProducts =
      await _firebaseService.getSellerSoldProducts(sellerId);
      setState(() {
        _soldProducts = soldProducts;
      });
    } catch (error) {
      // Handle error
      print('Error loading sold products: $error');
    }
  }

  Future<Map<String, dynamic>> getBuyerDetails(String buyerId) async {
    try {
      Map<String, dynamic>? buyerDetails =
      await _firebaseService.getBuyerDetailsById(buyerId);
      return buyerDetails ?? {};
    } catch (error) {
      // Handle error
      print('Error loading buyer details: $error');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sold Products'),
        backgroundColor: Colors.teal, // Change the app bar color
      ),
      body: _buildSoldProductsList(),
    );
  }

  Widget _buildSoldProductsList() {
    return ListView.builder(
      itemCount: _soldProducts.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> soldProduct = _soldProducts[index];

        // Fetch buyer details using buyerId
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
                String shopName = buyer['shopName'] ?? 'N/A'; // Default to 'N/A' if shopName is null

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
                      // Add more buyer details as needed
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
                              // Add more buyer details as needed
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