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
            ElevatedButton(
              onPressed: () => _cancelOrder(order, product),
              child: Text('Cancel Order'),
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
                    // Handle cancel order action
                    _confirmCancelOrder(order, product);
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



  void _confirmCancelOrder(LocalOrder.LocalOrder order, Product product) async {
    try {
      // Implement the logic to update the order status to cancelled in Firebase
      await _service.cancelOrder(order.orderId, selectedCancellationReason);
      // Reload the orders after cancellation
      await _loadOrders();
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
