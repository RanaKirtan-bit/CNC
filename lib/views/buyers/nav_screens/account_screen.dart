// account_screen.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/show_snackBar.dart';
import '../auth/login_screen.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String fullName = "Loading...";
  String phoneNumber = "Loading...";

  @override
  void initState() {
    super.initState();
    // Call a function to retrieve user data from Firebase
    _getUserData();
  }

  // Inside _AccountScreenState

  _getUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch additional user details from Firestore or other sources if needed
        // In this example, we are using display name and phone number
        if (user.displayName != null) {
          fullName = user.displayName!;
        } else {
          fullName = "N/A";
        }

        phoneNumber = user.phoneNumber ?? "N/A";

        setState(() {});
      } else {
        print("User not logged in");
        // Handle the case where the user is not logged in
      }
    } catch (e) {
      print("Error fetching user data: $e");
      // Handle error fetching user data
      fullName = "N/A";
      phoneNumber = "N/A";
      setState(() {});
    }
  }


  _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      showSnack(context, 'Logout Successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Replace 'LoginScreen' with your actual login screen
      ); // Return to the previous screen (e.g., home page)
    } catch (e) {
      print("Error logging out: $e");
      // Handle error logging out
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Details'),
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            // Show a warning before logging out
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout();
                      },
                      child: Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Full Name: $fullName',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}