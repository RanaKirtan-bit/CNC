import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
                launchPayment();
                //_buyNow();

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





   }






