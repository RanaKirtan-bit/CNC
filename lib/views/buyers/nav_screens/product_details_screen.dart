import 'package:clickncart/views/buyers/nav_screens/widgets/category_text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/product_model.dart';

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
  int? pageNumber = 0;

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
              color: Colors.orange,
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
                        fit: BoxFit.cover,
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
                  Text(
                    'Category: ${widget.product.category ?? "N/A"}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Brand: ${widget.product.brand ?? "N/A"}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Regular Price: ${widget.product.regularPrice != null ? widget.product.regularPrice.toString() : "N/A"}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Product ID: ${widget.product.id ?? "N/A"}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}
