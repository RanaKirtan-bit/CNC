

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;






  Future<String>  signUpUsers(
      String email,
      String fullName,
      String phoneNumber,
      String password) async {
        String res = 'Some error occured';
        try{
          if(email.isNotEmpty &&
              fullName.isNotEmpty &&
              phoneNumber.isNotEmpty &&
              password.isNotEmpty) {

            UserCredential cred = await  _auth.createUserWithEmailAndPassword(
              email: email, password: password
            );
            await _firestore.collection('buyers').doc(cred.user!.uid).set({
                    'email': email,
                    'fullName': fullName,
                    'phoneNumber': phoneNumber,
                    'buyerId': cred.user!.uid,
                    'address': ' ',
            });

            res = 'success';
          }else{
            res = ' Something went wrong';
          }
        }
        catch(e) {
          res = 'PLEASE PROVIDE CORRECT DETAILS';
        }
        return res;
  }

  loginUsers(String email, String password) async {
    String res = 'Error Occurred';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential credential =
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        // Check user role before allowing login
        DocumentSnapshot userDoc =
        await _firestore.collection('buyers').doc(credential.user!.uid).get();

        if (userDoc.exists) {
          // This is a buyer's account
          res = 'success';
        } else {
          // This is not a buyer's account, handle accordingly
          await _auth.signOut(); // Sign out the user if not a buyer
          res = 'Invalid credentials for buyer';
        }
      } else {
        res = 'Something went wrong';
      }
    } catch (e) {
      res = 'PLEASE PROVIDE VALID EMAIL OR PASSWORD';
    }
    return res;
  }


  Future<void> logOutAndDeleteData() async {
    try {
      await _auth.signOut();
      print('User logged out successfully');
    } catch (e) {

      print('Error logging out: $e');
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

  Future<String?> fetchUserName() async {
    try {
      // Assume you have a method to get the user details from Firebase
      UserDetails? userDetails = await fetchUserDetails();
      return userDetails?.fullName;
    } catch (e) {
      print('Error fetching user name: $e');
      return null;
    }
  }




}





class UserDetails {
  final String email;
  final String fullName;
  final String phoneNumber;
  final String buyerId;
  final String address;

  UserDetails({
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.buyerId,
    required this.address,
  });

  factory UserDetails.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserDetails(
      email: data['email'] ?? '',
      fullName: data['fullName'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      buyerId: data['buyerId'] ?? '',
      address: data['address'] ?? '',
    );
  }
}



