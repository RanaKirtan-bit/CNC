import 'package:flutter/material.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
   late Razorpay _razorpay;


  @override
  void initState() {
    super.initState();
    _loadCartItems();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> _loadCartItems() async {
    try {
      List<Product> items = await _service.getCartItems(widget.userDetails.buyerId);

      setState(() {
        cartItems = items;
      });
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  void removeFromCart(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove from Cart'),
        content: Text('Are you sure you want to remove this item from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Remove from Firebase
              await _service.removeFromCart(widget.userDetails.buyerId, product);

              // Remove locally
              setState(() {
                cartItems.remove(product);
              });

              Navigator.pop(context);
            },
            child: Text('Remove'),
          ),
        ],
      ),
    );
  }


  void _increaseQuantity(Product product) {
    setState(() {
      product.quantity++;
    });
  }

  void _decreaseQuantity(Product product) {
    if (product.quantity > 1) {
      setState(() {
        product.quantity--;
      });
    }
  }

  void _placeOrder() {
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
        child: Text(
          'Your cart is empty.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                Product product = cartItems[index];
                int itemPrice = ((product.salesPrice ?? 0) * product.quantity);
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 4,
                  child: ListTile(
                    title: Text(
                      product.productName ?? '',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Price: Rs. ${product.salesPrice}',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decreaseQuantity(product),
                            ),
                            Text(
                              '${product.quantity}',
                              style: TextStyle(fontSize: 16),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _increaseQuantity(product),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () => removeFromCart(product),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Rs. $itemPrice',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
                Text(
                  'Total: Rs. ${_calculateTotalPrice()}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: (){
                    launchPayment();
                  },
                  child: Text('Place Order'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    primary: Colors.green,
                    textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  void launchPayment() async {
    double amt =double.parse(_calculateTotalPrice());
    var options = {
      'key': 'rzp_test_UgjuCBp0lFcBCP', //<-- your razorpay api key/test or live mode goes here.
      'amount':  (amt * 100).toInt(),
      'name': 'ClickNCart',
      'description': 'Paymnet For Your Products',
      'prefill': {'contact': widget.userDetails.phoneNumber, 'email': widget.userDetails.email},
      'external': {'wallets': ['Gpay']}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e as String?);
    }
  }


  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Error ' + response.code.toString() + ' ' + response.message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Success ' + response.paymentId.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'Wallet Name ' + response.walletName.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.black,
        fontSize: 16.0);
  }






  String _calculateTotalPrice() {
    double total = 0;
    for (Product product in cartItems) {
      total += (product.salesPrice ?? 0) * product.quantity;
    }
    return total.toStringAsFixed(2);
  }
}