import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductInfo productInfo;

  const ProductDetailsScreen({
    required this.productInfo,
    //required this.id,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  int? pageNumber = 0;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.grey
          ),
          actions: [
            CircleAvatar(
              radius: 18,
                backgroundColor: Colors.orange,
                child: Icon(
                    IconlyLight.buy, color: Colors.white,
                ),
            ),
            SizedBox(width: 8,),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.more_horiz, color: Colors.white,
              ),
            ),
            SizedBox(width: 10,),
          ],
        ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 400,
                  //width: 300,
                  color: Colors.orange,
                  child: Stack(
                    children: [
                      PageView(
                        onPageChanged: (value){
                          setState(() {
                              pageNumber = value;
                          });
                        },
                        children: widget.productInfo!.imageUrls!.map((e) {
                          return CachedNetworkImage(imageUrl: e,fit: BoxFit.cover,);
            }).toList()

                      ),
                      Positioned(
                          bottom: 10,
                          right: MediaQuery.of(context).size.width/2.1,
                          child: CircleAvatar(
                            radius: 14,
                              backgroundColor: Colors.black12,
                              child: Text('${pageNumber!+1}/${widget.productInfo!.imageUrls.length}', style: TextStyle(fontSize: 14),)),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                ),

              ],
            ),
          ),
      );



    /*
    return Scaffold(

      appBar: AppBar(
        title: Text('Product Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(productInfo.imageUrls[0], height: 180, width: 120, fit: BoxFit.cover),
            SizedBox(height: 10),
            Text('Product Name: ${productInfo.name}'),
            Text('Category: ${productInfo.category}'),
            // Add more details as needed
          ],
        ),
      ),
    );
     */
  }
}
