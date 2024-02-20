import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_controller.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController addressController = TextEditingController();

  Future<UserDetails?> fetchUserDetails() async {
    try {
      User? user = await getCurrentUser();

      if (user != null) {
        DocumentSnapshot userDoc =
        await _firestore.collection('buyers').doc(user.uid).get();

        if (userDoc.exists) {
          return UserDetails.fromSnapshot(userDoc);
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return null;
  }

  Future<void> updateUserDetails({
    required String fullName,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('buyers').doc(user.uid).update({
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'address': address,
        });
      } else {
        throw Exception('User not logged in');
      }
    } catch (e) {
      throw Exception('Error updating user details: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      return _auth.currentUser;
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

// ... (other methods as needed)
}
