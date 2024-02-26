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

        return FutureBuilder<Map<String, dynamic>>(
          future: buyerDetails,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error loading buyer details');
            } else {
              Map<String, dynamic> buyer = snapshot.data ?? {};
              return ListTile(
                title: Text(soldProduct['productName']),
                subtitle: Column(
                  children: [
                    Text('Sales Price: \$${soldProduct['salesPrice']}'),
                    Text('Buyer Name: ${buyer['address']}'), // Replace 'name' with actual field
                    // Add more buyer details as needed
                  ],
                ),
                onTap: () {
                  // Handle item tap if needed
                },
              );
            }
          },
        );
      },
    );
  }
}