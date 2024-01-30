import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clickncart/firebase_service.dart'; // Import your FirebaseService class

class SellerProvider with ChangeNotifier {
  FirebaseService _services = FirebaseService();
  DocumentSnapshot? _doc; // Define the doc property

  // Getter for the doc property
  DocumentSnapshot? get doc => _doc;

  // Your existing methods...

  Future<void> getSellerData(String sellerId) async {
    try {
      // Fetch seller data using the sellerId
      DocumentSnapshot sellerDoc = await _services.getSellerById(sellerId);

      // Check if the document exists
      if (sellerDoc.exists) {
        // Assign the sellerDoc to the _doc property
        _doc = sellerDoc;

        // Notify listeners that the data has changed
        notifyListeners();
      }
    } catch (error) {
      // Handle errors
      print("Error fetching seller data: $error");
    }
  }
}
