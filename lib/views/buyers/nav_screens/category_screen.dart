
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clickncart/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutterfire_ui/firestore.dart';

import 'maincategory_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _title = 'Categories';
  final CollectionReference categories = FirebaseFirestore.instance.collection('categorise');

  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          selectedCategory == null? _title : selectedCategory!, style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),),
            elevation: 0,
        backgroundColor: Colors.purple.shade50,

        iconTheme: IconThemeData(
          color: Colors.black54,

        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(IconlyLight.buy),
            onPressed: (){},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: (){},
          ),
        ],
      ),
      body: Row(
        children: [
          Container(
            width: 120,
            color: Colors.orange.shade200,

            child: FirestoreListView<Category>(
              query: categoryCollection,
              itemBuilder: (context, snapshot) {
                Category category = snapshot.data();
                return InkWell(
                  onTap: (){
                    setState(() {
                      _title = category.cartName!;
                      selectedCategory = category.cartName;
                    });
                  },
                  child: SingleChildScrollView(
                    child: Container(
                      height: 240,
                      color: selectedCategory == category.cartName ? Colors.white : Colors.grey.shade300,

                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 130,
                                  child: CachedNetworkImage(
                                      imageUrl: category.image!,
                                      //color: selectedCategory ==  category.cartName? Theme.of(context).primaryColor:Colors.grey,
                                  ),
                              ),
                              Text(category.cartName!, style: TextStyle(fontSize: 14, color: selectedCategory ==  category.cartName? Theme.of(context).primaryColor:Colors.grey,),
                              textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          CustomerMainCategoryScreen(selectedCart: selectedCategory,)
        ],
      ),

    );
  }
}

/*
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
*/


