
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../controllers/auth_controller.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFA6F1DF), Color(0xFFFFBBBB)],
          begin: FractionalOffset(0.5, 0.7),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 25,
          right: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder<String?>(
              future: AuthController().fetchUserName(), // Fetch user name
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}, What Are You\n Looking For 👀 ',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Semi-Bold',
                    ),
                  );
                }
                return Text(
                  'Guest, What Are You\n Looking For 👀 ',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Semi-Bold',
                  ),
                );
              },
            ),
            InkWell(
              onTap: () {
                // Navigate to cart screen
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: SvgPicture.asset(
                  'assets/images/shopping_cart.svg',
                  width: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

