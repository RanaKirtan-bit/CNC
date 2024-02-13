import 'package:clickncart/views/buyers/nav_screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import '../../../firebase_service.dart';
import '../../../models/product_model.dart';
import '../../../models/sub_category_model.dart';

class ProductsForSubCategoryScreen extends StatelessWidget {
  final SubCategory subCategory;

  const ProductsForSubCategoryScreen({required this.subCategory, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products for ${subCategory.subCartName}'),
      ),
      body: FirestoreQueryBuilder<Product>(
        query: productQuerySub(subCategory: subCategory.subCartName),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              Product product = snapshot.docs[index].data();
              return ListTile(
                onTap: () {
                  // Navigate to the ProductDetailsScreen with the selected product
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(product: product),
                    ),
                  );
                },
                title: Text(product.productName ?? 'No Name'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brand: ${product.brand ?? 'N/A'}'),
                    Text('Sales Price: ${product.salesPrice ?? 'N/A'}'),
                  ],
                ),
                leading: Container(
                  width: 60, // Adjust the width as needed
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      product.imageUrls?.isNotEmpty == true ? product.imageUrls![0] : 'assets/placeholder_image.png',
                      width: 60, // Adjust the width as needed
                      height: 60, // Adjust the height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Add other product details as needed
              );

            },
          );
        },
      ),
    );
  }
}
