import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/utils/show_snackBar.dart';
import 'package:clickncart/views/buyers/auth/login_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';



class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final String? productId;
  const ProductDetailsScreen({
    required this.product,
    this.productId,
  });



  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}
class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
   final FirebaseService _service = FirebaseService();
  int? pageNumber = 0;
   late Razorpay _razorpay;



   final AuthController _authController = AuthController();
   UserDetails? _userDetails;

   @override
   void initState() {
     super.initState();
     _loadUserData();
     _razorpay = Razorpay();
     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
   }






   Future<void> _loadUserData() async {
     try {
       UserDetails? userDetails = await _authController.fetchUserDetails();

       setState(() {
         _userDetails = userDetails;
       });
     } catch (e) {
       // Handle errors
       print('Error loading user data: $e');
     }
   }

   @override
  Widget build(BuildContext context) {
    print('Regular Price: ${widget.product.regularPrice}');
    print('Product ID: ${widget.product.id}');
    print('Brand: ${widget.product.brand}');



    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 400,
              color: Colors.white,
              child: Stack(
                children: [
                  PageView(
                    onPageChanged: (value) {
                      setState(() {
                        pageNumber = value;
                      });
                    },
                    children: widget.product.imageUrls!.map((e) {
                      return CachedNetworkImage(
                        imageUrl: e,
                        fit: BoxFit.contain,
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    right: MediaQuery.of(context).size.width / 2.1,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black12,
                      child: Text(
                        '${pageNumber! + 1}/${widget.product.imageUrls?.length}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Text(
                    'Rs.  ${widget.product.salesPrice != null ? _service.formatedNumber(widget.product!.salesPrice) : _service.formatedNumber(widget.product.regularPrice!)}',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if(widget.product.salesPrice!= null)
                    Row(
                      children: [
                        Text('Rs.  ${_service.formatedNumber(widget.product.regularPrice!)}',
                          style:
                          TextStyle(
                            decoration: TextDecoration.lineThrough, color: Colors.grey,fontSize: 14
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text('${(((widget.product.regularPrice!-widget.product.salesPrice!)/widget.product.regularPrice!) * 100).toStringAsFixed(0)}% Off' ,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10,),
                  Text(
                    widget.product.productName!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(IconlyBold.star, color: Colors.red, size: 14,),
                      Icon(IconlyBold.star, color: Colors.red, size: 14,),
                      Icon(IconlyBold.star, color: Colors.red, size: 14,),
                      Icon(IconlyBold.star, color: Colors.red, size: 14,),
                      Icon(IconlyBold.star, color: Colors.red, size: 14,),
                      SizedBox(width: 5,),
                      Text('(5)', style: TextStyle(fontSize: 12),)
                    ],
                  ),
                  Divider(color: Colors.grey, thickness: 1,),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (innerContext) => Container(
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Text(
                                'Description: ${widget.product.description!}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                'Brand: ${widget.product.brand!}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10,),
                            ],
                          ),

                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Specifications', style: TextStyle(fontSize: 12, color: Colors.grey),),
                        Icon(IconlyLight.arrowRight2, size: 14, color: Colors.grey,),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey, thickness: 1,),
                  // Inside the Text widget where you are displaying Buyer ID
                  Text('Address: ${_userDetails != null ? _userDetails!.address : 'Loading...'}')



                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _addToCart();
              },
              child: Text('Add to Cart'),
            ),

            // Buy Now Button
            ElevatedButton(
              onPressed: () {
                if(_userDetails!=null){
                  launchPayment();
                }
                else{
                  showSnack(context, 'Please Make Login');
                }

              },
              child: Text('Buy Now'),
            ),

          ],
        ),
      ),
    );
  }


   void _addToCart() async {
     // Check if the user is logged in
     if (_userDetails != null) {
       try {
         // Set the product ID before adding it to the cart
         Product productToAdd = Product(
           id: widget.productId ?? '', // Assuming widget.productId is the ID
           productName: widget.product.productName,
           salesPrice: widget.product.salesPrice,
           brand: widget.product.brand,
           sellerId: widget.product.sellerId,
           // Copy other fields as needed
         );

         // Check if the product with the same ID is already in the cart
         List<Product> cartItems = await _service.getCartItems(_userDetails!.buyerId);
         bool isProductInCart = cartItems.any((item) => item.id == productToAdd.id);

         if (isProductInCart) {
           // Product with the same ID is already in the cart, show a message
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Product is already in the cart.'),
             ),
           );
         } else {
           // Product is not in the cart, proceed to add it
           await _service.addToCart(_userDetails!.buyerId, productToAdd);

           // Show a snackbar or navigate to the CartScreen
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Product added to cart!'),
             ),
           );
         }
       } catch (e) {
         print('Error checking or adding product to cart: $e');
       }
     } else {
       // User is not logged in, prompt them to log in
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Please log in to add products to the cart.'),
         ),
       );
       Navigator.pushReplacement(context, MaterialPageRoute(
           builder: (context) => LoginScreen(

       ),
       )
     );
     }
   }

   void launchPayment() async {
     var options = {
       'key': 'rzp_test_UgjuCBp0lFcBCP', //<-- your razorpay api key/test or live mode goes here.
       'amount': widget.product.salesPrice! * 100,
       'name': 'flutterdemorazorpay',
       'description': 'Test payment from Flutter app',
       'prefill': {'contact': '', 'email': ''},
       'external': {'wallets': []}
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

   void _handlePaymentSuccess(PaymentSuccessResponse response) async {
     try {
       // Check if the user is logged in
       if (_userDetails != null) {
         // Prepare order details
         List<Product> products = [widget.product]; // You can extend this list if needed
         String paymentId = response.paymentId.toString();
         String totalAmount = widget.product.salesPrice != null
             ? widget.product.salesPrice.toString()
             : widget.product.regularPrice.toString();

         // Create the order
         await _service.createOrder(
           buyerId: _userDetails!.buyerId,
           products: products,
           paymentId: paymentId,
           totalAmount: totalAmount, sellerId: widget.product.sellerId,
         );
         sendMail(
           recipientEmail: _userDetails!.email,
           mailMessage: 'Thank you for your purchase!',
           productName: widget.product.productName!,
           productImage: widget.product.imageUrls!.first, // Assuming the product has at least one image
           totalPaidAmount: widget.product.salesPrice != null
               ? widget.product.salesPrice.toString()
               : widget.product.regularPrice.toString(),
           appName: 'ClickNCart',
           Name: _userDetails!.fullName,
         );
         // Show a success message
         Fluttertoast.showToast(
           msg: 'Payment Success $paymentId',
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.CENTER,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.green,
           textColor: Colors.black,
           fontSize: 16.0,
         );

         // Optional: Navigate to the order confirmation screen or any other screen
         // Navigator.push(context, MaterialPageRoute(builder: (context) => OrderConfirmationScreen()));
       } else {
         // User is not logged in, prompt them to log in
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
             content: Text('Please log in to complete the order.'),
           ),
         );
         Navigator.pushReplacement(
           context,
           MaterialPageRoute(
             builder: (context) => LoginScreen(),
           ),
         );
       }
     } catch (e) {
       // Handle errors
       print('Error handling payment success: $e');
     }
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


   void sendMail({
     required String recipientEmail,
     required String mailMessage,
     required String productName,
     required String productImage,
     required String totalPaidAmount,
     required String appName,
     required String Name,
   }) async {
     // change your email here
     String username = 'ranakirtan9@gmail.com';
     // change your password here
     String password = 'kmujitoekdzkgyut';
     final smtpServer = gmail(username, password);
     final message = Message()
       ..from = Address(username, 'Mail Service')
       ..recipients.add(recipientEmail)
       ..subject = 'Order Confirmation'
       ..html = '''
      <h3>Order Details</h3>
      <p><strong>Product Name:</strong> $productName</p>
      <p><strong>Product Image:</strong> <br> <img src="$productImage" align="left" alt="Product Image" style="max-width: 100px;"></p>
      <p><strong>Total Paid Amount:</strong> Rs. $totalPaidAmount /- </p>
      <p><strong>App Name:</strong> $appName</p>
      <p><strong>Name:</strong> $Name</p>
      <p>$mailMessage</p>
      <h5 style="text-align: center;">Thank you for Purchase $productName  with ClickNCart. Enjoy your day!</h5>
        <h6 style="text-align: center;">If you cancel  Your Order call this Custome service Number +91 9978427943 or +91 9313226480</h6>
        <h6 style="text-align: center;">Copyright © 2024 ClickNCart Private Limited (formerly known as ClickNCart Shopping Private Limited), India. All rights reserved.</h6>
    ''';

     try {
       await send(message, smtpServer);
       print('Email sent successfully');
     } catch (e) {
       if (kDebugMode) {
         print(e.toString());
       }
     }
   }
}






