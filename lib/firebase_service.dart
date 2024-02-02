import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection(
      'categorise');
  CollectionReference mainCategorise = FirebaseFirestore.instance.collection(
            'mainCategorise');
        CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategorise');
        CollectionReference sellers = FirebaseFirestore.instance.collection('sellers');
  CollectionReference products = FirebaseFirestore.instance.collection('products');
/*
       Future<List<String>> getMainCategories() async {
                QuerySnapshot querySnapshot = await mainCart.get();
                List<String> categories = querySnapshot.docs.map((
                    doc) => doc['mainCategory'] as String).toList();
                return categories;
        }

        Future<List<String>> getSubCategories(String mainCategory) async {
                QuerySnapshot querySnapshot = await subCart
                    .where('mainCategory', isEqualTo: mainCategory)
                    .get();
                List<String> subCategories =
                querySnapshot.docs.map((doc) => doc['subCartName'] as String).toList();
                return subCategories;
        }
*/
  Future<DocumentSnapshot> getSellerById(String sellerId) async {
    try {
      return await _firestore.collection('sellers').doc(sellerId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching seller data by ID: $error");
      throw error;
    }
  }

  Future<DocumentSnapshot> getProductById(String productId) async {
    try {
      return await _firestore.collection('products').doc(productId).get();
    } catch (error) {
      // Handle errors
      print("Error fetching product data by ID: $error");
      throw error;
    }
  }



  String formatedDate(DateTime date){
        var outputFormat = DateFormat('dd/MM/yyyy hh:mm aa');
        var outputDate = outputFormat.format(date);
        return outputDate;
  }


  Widget formField({String? label, TextInputType? inputType, void Function(String)? onChanged, int? minLine,int? maxLine }) {
    return TextFormField(
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return label;
        }
      },
      onChanged: onChanged,
      minLines: minLine,
      maxLines: maxLine,
    );
  }
  scaffold(context, message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,),
      action: SnackBarAction(
        label: 'OK',
        onPressed: (){
          ScaffoldMessenger.of(context).clearSnackBars();
        },
      ),
    ));
  }

}


