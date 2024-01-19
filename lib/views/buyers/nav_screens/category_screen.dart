import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'maincategory_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CollectionReference categories = FirebaseFirestore.instance.collection('categorise');

  String? selectedCategory;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Categories'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: categories.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No Categories available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var category = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(category['cartName']),
                subtitle: category['image'] != null
                    ? GestureDetector(
                  onTap: () {
                    // Navigate to the main category screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerMainCategoryScreen(
                          //mainCategories: mainCategory['cartName'],
                        ),
                      ),
                    );
                  },
                  child: Image.network(category['image']),
                )
                    : Text('No Image'),
              );
            },
          );
        },
      ),
    );
  }
}
