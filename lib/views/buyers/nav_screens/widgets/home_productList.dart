import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/product_model.dart';
import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

class HomeProductList extends StatelessWidget {
  final String? category;

  const HomeProductList({this.category, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FirestoreQueryBuilder<Product>(
      query: productQuery(category: category),
      builder: (context, snapshot, _) {
        // ...
        return GridView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.23,
          ),
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirestoreQueryBuilder to try to obtain more items.
              // It is safe to call this function from within the build method.
              snapshot.fetchMore();
            }
            var productIndex = snapshot.docs[index];
            Product product = productIndex.data();
            String productID = productIndex.id;

            return InkWell(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) =>  ProductDetailsScreen(product: product,productId: productID,))
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                height: 80,
                width: 80,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        height: 180,
                        width: 180,
                        child: CachedNetworkImage(
                          imageUrl: product.imageUrls![0],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      product.productName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
