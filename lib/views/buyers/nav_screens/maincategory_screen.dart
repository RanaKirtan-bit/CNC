import 'package:clickncart/views/buyers/nav_screens/sub_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';

import '../../../firebase_service.dart';
import '../../../models/main_category_model.dart';
import '../../../models/sub_category_model.dart';

class CustomerMainCategoryScreen extends StatefulWidget {
  final String? selectedCart;


  CustomerMainCategoryScreen({this.selectedCart});

  @override
  _CustomerMainCategoryScreenState createState() => _CustomerMainCategoryScreenState();
}

class _CustomerMainCategoryScreenState extends State<CustomerMainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  List<String> mainCategories = [];
  String? selectedMainCategory;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirestoreListView<MainCategory>(
        query: mainCategoryCollection(widget.selectedCart),
        itemBuilder: (context, snapshot) {
          MainCategory mainCategory = snapshot.data();
          return ExpansionTile(
            title: Text(mainCategory.mainCategory!),
            children: [
              SubCategoryScreen(
                selectedSubCart: mainCategory.mainCategory,
              ),
            ],
          );
        },
      ),
    );
  }
}

