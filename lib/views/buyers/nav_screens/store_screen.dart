import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/models/order_model.dart' as LocalOrder;

import '../../../models/order_model.dart';
import '../../../models/product_model.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseService _service = FirebaseService();
  List<LocalOrder.LocalOrder> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      // Get the currently signed-in user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch past orders for the logged-in user
        List<LocalOrder.LocalOrder>? userOrders =
        await _service.getUserOrders(user.uid);

        // Check if the widget is still mounted before calling setState
        if (mounted) {
          setState(() {
            orders = userOrders ?? [];
            print(orders);
          });
        }
      } else {
        // Handle the case when no user is signed in
        print('No user signed in.');
      }
    } catch (e) {
      // Handle errors
      print('Error loading user orders: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFA6F1DF), Color(0xFFFFBBBB)],
            begin: FractionalOffset(0.5, 0.7),
          ),
        ),
        child: orders.isEmpty
            ? Center(
          child: Text(
            'No past orders available.',
            style: TextStyle(fontSize: 18),
          ),
        )
            : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            LocalOrder.LocalOrder order = orders[index];
            return Card(
              margin:
              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                title: Text(
                  'Order ID: ${order.orderId}',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      'Total Amount: Rs. ${order.totalAmount}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Payment ID: ${order.paymentId}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Order Date: ${order.orderDate}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Products:',
                      style: TextStyle(fontSize: 14),
                    ),
                    // Nested ListView.builder for Products
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: order.products.length,
                      itemBuilder: (context, productIndex) {
                        return _buildProductCard(order, order.products[productIndex]);
                      },
                    ),

                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _deleteOrder(LocalOrder.LocalOrder order) async {
    try {
      // Implement the logic to delete the order from Firebase
      await _service.deleteOrder(order.orderId);
      // Reload the orders after deletion
      await _loadOrders();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  Widget _buildProductCard(LocalOrder.LocalOrder order, Product product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.productName!,
              style: TextStyle(fontSize: 14),
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () => _showProductDetailsDialog(order,product),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteOrder(order),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            // Other product details go here
          ],
        ),
      ),
    );
  }




  void _showProductDetailsDialog(LocalOrder.LocalOrder order, Product  product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Product Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${product.productName}'),
              Text('Brand: ${product.brand}'),
              Text('Regular Price: ${product.regularPrice}'),
              Text('Sales Price: ${product.salesPrice}'),
              Text('Quantity: ${product.quantity}'),

              SizedBox(height: 8),  // Add some spacing
              // Add other product details as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
            TextButton(
              onPressed: () {
                // Handle delete action
                _deleteOrder(order);
                Navigator.pop(context);
              },
              child: Text('Delete Order'),
            ),
          ],
        );
      },
    );
  }




}
