import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../views/seller/seller_controllers/seller_auth_controller.dart';

class ProductProvider with ChangeNotifier{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? productData = {
    'approved' :false
  };
  final List<XFile>? imageFiles = [];
  List<Map<String, dynamic>> productDataList = [];
  List<Product> _products = [];
  List<Product> _searchResults = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;


  Future<void> saveProduct() async {
    try {
      // Upload images to Firebase Storage
      List<String> imageUrls = await _uploadImages();

      // Add image URLs to product data
      productData!['imageUrls'] = imageUrls;

      // Get the seller ID of the logged-in user
      String sellerId = SellerAuthController().getSellerId()!;

      // Save product data to Firestore with the seller's ID
      await _firestore.collection('products').add({
        ...productData!,
        'sellerId': sellerId,
        'approved': false, // Assuming you want to set the initial approval status
      });

      // Reset the form or clear the data in productData
      productData!.clear();
      // Notify listeners that the data has changed
      notifyListeners();
    } catch (error) {
      print('Error saving product: $error');
      // Handle error as needed
    }
  }


  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (XFile imageFile in imageFiles!) {
      File file = File(imageFile.path);

      // Generate a unique filename for each image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Upload image to Firebase Storage
      Reference storageReference =
      FirebaseStorage.instance.ref().child('product_images/$fileName');
      UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() async {
        // Get the download URL for the uploaded image
        String imageUrl = await storageReference.getDownloadURL();
        imageUrls.add(imageUrl);
      });
    }

    return imageUrls;
  }
  gerFormData(
      {
        String? productName,
        int? regularPrice,
        int? salesPrice,
        String? taxStatus,
        double? taxPercentage,
        String? category,
        String? mainCategory,
        String? subCategory,
        String? description,
        DateTime? scheduleDate,
        String? sku,
        bool? manageInventory,
        int? soh,
        int? reOrderLevel,
        bool? chargeShipping,
        int? shippingCharge,
        String? brand,
        List? sizeList,

      }){

    if(productName!=null) {
      productData! ['productName'] = productName;
    }
    if(regularPrice!=null){
      productData! ['regularPrice'] = regularPrice;
    }
    if(salesPrice!=null){
      productData! ['salesPrice'] = salesPrice;
    }
    if(taxStatus!=null){
      productData! ['taxStatus'] = taxStatus;
    }
    if(taxPercentage!=null){
      productData! ['taxValue'] = taxPercentage;
    }
    if(category!=null){
      productData! ['category'] = category;
    }
    if(mainCategory!=null){
      productData! ['mainCategory'] = mainCategory;
    }
    if(subCategory!=null){
      productData! ['subCategory'] = subCategory;
    }
    if(description!=null){
      productData! ['description'] = description;
    }
    if(scheduleDate!=null){
      productData! ['scheduleDate'] = scheduleDate;
    }
    if(sku!=null){
      productData! ['sku'] = sku;
    }
    if(manageInventory!=null){
      productData! ['manageInventory'] = manageInventory;
    }
    if(soh!=null){
      productData! ['soh'] = soh;
    }
    if(reOrderLevel!=null){
      productData! ['reOrderLevel'] = reOrderLevel;
    }
    if(chargeShipping!=null){
      productData! ['chargeShipping'] = chargeShipping;
    }
    if(shippingCharge!=null){
      productData! ['shippingCharge'] = shippingCharge;
    }
    if(brand!=null){
      productData! ['brand'] = brand;
    }
    if(sizeList!=null){
      productData! ['sizeList'] = sizeList;
    }
    notifyListeners();
  }
  getImageFile(image){
    imageFiles!.add(image);
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    try {
      // Get the seller ID of the logged-in user
      String sellerId = SellerAuthController().getSellerId()!;

      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('products').where('sellerId', isEqualTo: sellerId).get();

      productDataList = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data()!;
        data['documentId'] = doc.id; // Assuming the documentId is needed for deletion
        return data;
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
      // Handle error as needed
    }
  }


  Future<void> deleteProduct(int index) async {
    try {
      String documentId = productDataList[index]['documentId'];
      await _firestore.collection('products').doc(documentId).delete();
      productDataList.removeAt(index);
      notifyListeners();
    } catch (error) {
      print('Error deleting product: $error');
      // Handle error as needed
    }
  }

  Future<void> searchProducts(String query) async {
    try {
      _isLoading = true;
      notifyListeners();

      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('products')
          .get();

      _searchResults = snapshot.docs
          .map((doc) => Product.fromJson(doc.data()))
          .where((product) =>
          product.productName!
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error searching products: $error');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Inside ProductProvider
  Future<void> fetchSoldProducts() async {
    try {
      // Get the seller ID of the logged-in user
      String sellerId = SellerAuthController().getSellerId()!;

      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _firestore.collection('products').where('sellerId', isEqualTo: sellerId).get();

      productDataList = snapshot.docs
          .map((doc) {
        Map<String, dynamic> data = doc.data()!;
        data['documentId'] = doc.id;
        return data;
      })
          .cast<Map<String, dynamic>>() // Cast the List<dynamic> to List<Map<String, dynamic>>
          .toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching products and buyers: $error');
      // Handle error as needed
    }
  }



  // Method to fetch random products
  Future<void> fetchRandomProducts() async {
    try {
      _isLoading = true;
      notifyListeners();
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection('products')
          .limit(10) // Fetch 10 random products
          .get();

      _products = snapshot.docs
          .map((doc) => Product.fromJson(doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print('Error fetching random products: $error');
      _isLoading = false;
      notifyListeners();
    }
  }
}