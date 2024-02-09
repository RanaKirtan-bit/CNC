import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

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



   final AuthController _authController = AuthController();
   UserDetails? _userDetails;

   @override
   void initState() {
     super.initState();
     _loadUserData();
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


          ],
        ),
      ),
    );
  }
}
