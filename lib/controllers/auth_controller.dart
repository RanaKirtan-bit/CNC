

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
                await _auth.signInWithEmailAndPassword(email: email, password: password);

                res = 'success';
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
      // Get the current user
      User? user = _auth.currentUser;

      // Sign out the user
      await _auth.signOut();

      // Delete user data from Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).delete();
        print('User data deleted successfully');
      }

      print('User logged out successfully');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}


