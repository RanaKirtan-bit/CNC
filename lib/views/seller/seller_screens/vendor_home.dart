import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clickncart/provider/product_provider.dart';
import 'package:clickncart/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../seller_widget/custom_drawer.dart';

class SellerHome extends StatefulWidget {
  static const String id = 'seller_Home';

  @override
  _SellerHomeState createState() => _SellerHomeState();
}

class _SellerHomeState extends State<SellerHome> {
  late FirebaseMessaging _firebaseMessaging;
  String selerId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _firebaseMessaging = FirebaseMessaging.instance;
    _configureFirebaseMessaging();
  }

  void _configureFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle incoming messages when the app is in the foreground
      print('Received FCM message: ${message.notification?.title}');
      // Update your UI or show a notification on SellerHome screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        String sellerId = selerId; // Set the actual sellerId here

        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text('Dashboard'),
          ),
          drawer: CustomDrawer(),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Seller's Statistics",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                _buildStatCard(
                  title: 'Total Orders',
                  future: FirebaseService().getTotalOrders(sellerId),
                ),
                SizedBox(height: 16),
                _buildStatCard(
                  title: 'Total Sales',
                  future: FirebaseService().getTotalSalesAmount(sellerId),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required Future<dynamic> future}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  String statValue = snapshot.data.toString();
                  return Text(
                    statValue,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
