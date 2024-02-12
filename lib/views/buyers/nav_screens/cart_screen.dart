import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:clickncart/firebase_service.dart';

import '../../../controllers/auth_controller.dart';

class CartScreen extends StatefulWidget {
  final UserDetails userDetails;

  const CartScreen({required this.userDetails});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseService _service = FirebaseService();
  List<Product> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      List<Product> items = await _service.getCartItems(widget.userDetails.buyerId);

      print('Buyer ID: ${widget.userDetails.buyerId}');
      print('Cart Items: $items');

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      // Handle errors
      print('Error loading cart items: $e');
    }
  }

  // Assuming you have a method like removeFromCart in FirebaseService

  void removeFromCart(Product product) {
    String? buyerId = widget.userDetails.buyerId;
    String? productId = product.id;

    if (buyerId != null && productId != null) {
      FirebaseFirestore.instance
          .collection('buyers')
          .doc(buyerId)
          .collection('cart')
          .doc(productId)
          .delete()
          .then((value) {
        print('Product removed from cart successfully');
      })
          .catchError((error) {
        print('Error removing product from cart: $error');
      });
    } else {
      print('Invalid buyerId or productId');
    }
  }








  void _placeOrder() {
    // You can implement the logic for placing the order here
    // For example, navigate to the order confirmation screen
    // or show a dialog with order details and confirmation button
    // This will depend on your specific app flow
    print('Placing order...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
        child: Text('Your cart is empty.'),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Product product = cartItems[index];
                return ListTile(
                  title: Text(product.productName ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rs. ${_service.formatedNumber(product.salesPrice ?? product.regularPrice ?? 0)}'),
                      //if (product.brand != null && product.brand!.isNotEmpty)
                        Text('Brand: ${product.brand}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeFromCart(product),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total: Rs. ${_calculateTotalPrice()}'),
                ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text('Place Order'),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }

  String _calculateTotalPrice() {
    double total = 0;
    for (Product product in cartItems) {
      total += product.salesPrice ?? product.regularPrice ?? 0;
    }
    return _service.formatedNumber(total);
  }
}
