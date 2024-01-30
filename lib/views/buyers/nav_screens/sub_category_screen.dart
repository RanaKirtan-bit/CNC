import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../../firebase_service.dart';
import '../../../models/main_category_model.dart';
import '../../../models/sub_category_model.dart';

class SubCategoryScreen extends StatelessWidget {
  final String? selectedSubCart;


  const SubCategoryScreen({this.selectedSubCart, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      FirestoreQueryBuilder<SubCategory>(
        query: subCategoryCollection(
          selectedSubCart: selectedSubCart,
        ),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('error ${snapshot.error}');
          }

          return GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1/1,
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

              SubCategory subCart = snapshot.docs[index].data();
              return Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    child: Container(
                      height: 80, // Adjust the height as needed
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder_image.png', // Placeholder image
                        image: subCart.image!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Text(subCart.subCartName!),
                  ),
                ],
              );



            },
          );
        },
      );

  }
}