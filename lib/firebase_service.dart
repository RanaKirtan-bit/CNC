import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'models/product_model.dart';
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference categories = FirebaseFirestore.instance.collection(
      'categorise');
  CollectionReference mainCategorise = FirebaseFirestore.instance.collection(
            'mainCategorise');
        CollectionReference subCategories = FirebaseFirestore.instance.collection('subCategorise');
        CollectionReference sellers = FirebaseFirestore.instance.collection('sellers');
  CollectionReference products = FirebaseFirestore.instance.collection('products');



  String formatedNumber(number){
    var f = NumberFormat('#,##,###');
    String formattedNumber = f.format(number);
    return formattedNumber;
  }




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


  Widget formField({String? label, TextInputType? inputType, void Function(String)? onChanged, int? minLine,int? maxLine}) {
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


  Future<List<Product>> getCartItems(String userId) async {
    try {
      List<Product> cartItems = [];

      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('buyers').doc(userId).collection('cart').get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Product product = Product.fromJson(data);
        cartItems.add(product);
      }

      return cartItems;
    } catch (error) {
      // Handle errors
      print('Error fetching cart items: $error');
      throw error;
    }
  }

  Future<void> addToCart(String buyerId, Product product) async {
    try {
      // ... existing code ...

      // Create a new Product instance with the provided ID and additional details
      Product productWithDetails = Product(
        id: product.id,
        productName: product.productName,
        imageUrls: product.imageUrls,
        brand: product.brand,
        salesPrice: product.salesPrice,
        // ... copy other properties ...
      );

      // Add the product to the cart
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(buyerId)
          .collection('cart')
          .doc(product.id)
          .set(productWithDetails.toJson());

      print('Product added to cart. ProductId: ${product.id}');
    } catch (e) {
      print('Error adding product to cart: $e');
      throw e;
    }
  }




  // Inside the FirebaseService class
  Future<void> removeFromCart(String userId, Product product) async {
    try {
      // Assuming 'cart' is the name of the collection storing user carts
      // and 'items' is the name of the subcollection containing cart items
      await FirebaseFirestore.instance
          .collection('buyers')
          .doc(userId)
          .collection('cart')
          .doc(product.id) // Assuming each product has a unique ID
          .delete();

      print('Product removed from cart: ${product.productName}');
    } catch (e) {
      // Handle errors
      print('Error removing product from cart: $e');
      throw e;
    }
  }



}




