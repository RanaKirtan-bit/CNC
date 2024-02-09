// account_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../utils/show_snackBar.dart';
import '../auth/login_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/widgets/welcome_text_widget.dart';


class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AuthController _authController = AuthController();
  UserDetails? _userDetails;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      UserDetails? userDetails = await _authController.fetchUserDetails();

      setState(() {
        _userDetails = userDetails;
      });
    } catch (e) {
      // Handle errors
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_userDetails == null) {
      // Show loading indicator or other UI for when user data is being fetched.
      return CircularProgressIndicator();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${_userDetails!.email}'),
            Text('Full Name: ${_userDetails!.fullName}'),
            Text('Phone Number: ${_userDetails!.phoneNumber}'),
            Text('Buyer ID: ${_userDetails!.buyerId}'),
            Text('Address: ${_userDetails!.address}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
