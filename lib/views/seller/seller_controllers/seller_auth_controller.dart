// seller_auth_controller.dart

import 'dart:io' as io;


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SellerAuthController {
  final FirebaseAuth _auths = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;


  Future<String> signUpSellers(
      String email,
      String shopName,
      String phoneNumber,
      String password,
      XFile? shopImage,
      XFile? logo,
      String gstNumber,
      String address,
      String pinCode,
      String landmark,
      String? countryValue,
      String? stateValue,
      String? cityValue,
      ) async {
    String res1 = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          shopName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty &&
          shopImage != null &&
          logo != null &&
          countryValue != null &&
          stateValue != null &&
          cityValue != null) {

        // Create user in Firebase Authentication
        UserCredential cred = await _auths.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Upload shop image and logo to Firebase Storage
        String shopImageUrl = await _uploadImage(shopImage, 'shop_images');
        String logoUrl = await _uploadImage(logo, 'logos');

        // Store seller details in Firestore
        await _firestore.collection('sellers').doc(cred.user!.uid).set({
          'email': email,
          'shopName': shopName,
          'phoneNumber': phoneNumber,
          'sellerId': cred.user!.uid,
          'address': address,
          'pinCode': pinCode,
          'landmark': landmark,
          'country': countryValue,
          'state': stateValue,
          'city': cityValue,
          'gstNumber': gstNumber,
          'shopImageUrl': shopImageUrl,
          'logoUrl': logoUrl,
        });

        res1 = 'success';
      } else {
        res1 = 'Please provide all the details';
      }
    } catch (e) {
      print('Error: $e');
      res1 = 'An unexpected error occurred';
    }
    return res1;
  }
  Future<String> _uploadImage(XFile image, String folderName) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageReference =
      _storage.ref().child('$folderName/$fileName');

      // Convert XFile to File
      io.File file = io.File(image.path!);

      // Upload the file
      await storageReference.putFile(file);

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image');
    }
  }


  Future<String> loginBuyer(String email, String password) async {
    return _loginUser(email, password, 'buyers');
  }

  Future<String> loginSeller(String email, String password) async {
    return _loginUser(email, password, 'sellers');
  }

  Future<String> _loginUser(String email, String password, String collection) async {
    String res = 'Error Occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auths.signInWithEmailAndPassword(email: email, password: password);

        var userDoc = await _firestore.collection(collection).doc(_auths.currentUser!.uid).get();

        if (userDoc.exists) {
          res = 'success';
        } else {
          await _auths.signOut(); // Sign out if the user is not found in the specified collection
          res = 'Invalid credentials';
        }
      } else {
        res = 'Something went wrong';
      }
    } catch (e) {
      res = 'PLEASE PROVIDE VALID EMAIL OR PASSWORD';
    }

    return res;
  }
  // You can add more methods as needed for seller authentication

  // ... Other methods ...

  Future<bool> isSellerApproved(String email) async {
    try {
      final user = await _auths.currentUser;
      if (user != null) {
        final userData = await _firestore.collection('sellers').doc(user.uid).get();
        return userData['approved'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking seller approval: $e');
      return false;
    }
  }

  String? getSellerId() {
    // Check if the user is logged in
    if (_auths.currentUser != null) {
      return _auths.currentUser!.uid;
    }
    return null;
  }


  Future<void> logOutAndDeleteData() async {
    try {
      // Get the current user
      User? user = _auths.currentUser;

      // Sign out the user
      await _auths.signOut();

      // Delete user data from Firestore
      if (user != null) {
        await _firestore.collection('sellers').doc(user.uid).delete();
        print('Seller data deleted successfully');
      }

      print('Seller logged out successfully');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
