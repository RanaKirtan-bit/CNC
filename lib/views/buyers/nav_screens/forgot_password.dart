  import 'package:clickncart/utils/show_snackBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController  = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password'
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
              begin: FractionalOffset(0.5, 0.7),
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 50.0,left: 50),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              ElevatedButton(onPressed: () {
                  auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                    // On success
                    showSnack(context, "Password reset email sent successfully ");
                  })
                      .catchError((error) {
                    // On error
                    showSnack(context, "Error: $error");
                  });
              },
                child: Text(
                'Forgot',
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
