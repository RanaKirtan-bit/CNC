import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/models/order_model.dart' as LocalOrder;
import 'package:intl/intl.dart';

import '../../../models/order_model.dart';
import '../../../models/product_model.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final FirebaseService _service = FirebaseService();
  List<LocalOrder.LocalOrder> orders = [];
  String selectedCancellationReason = ' ' ;
  int selectedCancellationReasonIndex = -1;

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
        print('User UID: ${user.uid}');

        // Fetch past orders for the logged-in user
        List<LocalOrder.LocalOrder>? userOrders = await _service.getUserOrders(user.uid);

        if (userOrders != null) {
          print('Fetched ${userOrders.length} orders');
        } else {
          print('No orders fetched');
        }

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
              EdgeInsets.symmetric(vertical: 8, horizontal: 3),
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
                      'Order Date: ${order.timestamp}',
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
    bool orderCancelled = order.status == 'Cancelled';
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      elevation: 4,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.productName!,
              style: TextStyle(fontSize: 12),
            ),
            IconButton(
              icon: Icon(Icons.remove_red_eye),
              onPressed: () => _showProductDetailsDialog(order,product),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteOrder(order),
            ),
            if (!orderCancelled)
              IconButton(
                icon: Icon(Icons.cancel), // Replace with a relevant cancel icon
                onPressed: () => _cancelOrder(order, product),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            // Other product details go here
            if (orderCancelled)
              Text(
                'Order Cancelled',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
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

  void _cancelOrder(LocalOrder.LocalOrder order, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Cancel Order'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Are you sure you want to cancel this order?'),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      cancellationReasons.length,
                          (index) {
                        return Row(
                          children: [
                            Radio<int>(
                              value: index,
                              groupValue: selectedCancellationReasonIndex,
                              onChanged: (value) {
                                setState(() {
                                  selectedCancellationReasonIndex = value!;
                                });
                              },
                            ),
                            Text(cancellationReasons[index]),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Check if it's within 24 hours to allow cancellation
                    if (_isWithin24Hours(order.timestamp)) {
                      _confirmCancelOrder(order, product);
                    } else {
                      print('Cannot cancel order after 24 hours.');
                      // You might want to show an error message or handle this case accordingly
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Helper method to check if the order is within 24 hours
  bool _isWithin24Hours(DateTime orderDateTime) {
    DateTime currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(orderDateTime);
    return difference.inHours < 24;
  }





  void _confirmCancelOrder(LocalOrder.LocalOrder order, Product product) async {
    try {
      // Ensure that a cancellation reason is selected
      if (selectedCancellationReasonIndex != -1) {
        String cancellationReason = cancellationReasons[selectedCancellationReasonIndex];
        // Implement the logic to update the order status to cancelled in Firebase
        await _service.cancelOrder(order.orderId, cancellationReason);
        // Reload the orders after cancellation
        await _loadOrders();
      } else {
        print('Please select a cancellation reason.');
        // You might want to show an error message or handle this case accordingly
      }
    } catch (e) {
      print('Error cancelling order: $e');
    }
  }


  final List<String> cancellationReasons = [
    'Item out of stock',
    'Changed my mind',
    'Found a better deal',
    'Other',
  ];

}
