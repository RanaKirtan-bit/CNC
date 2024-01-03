

import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/utils/show_snackBar.dart';
import 'package:clickncart/views/buyers/auth/register_screen.dart';
import 'package:clickncart/views/buyers/main_screen.dart';
import 'package:clickncart/views/buyers/nav_screens/forgot_password.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  late String email;

  late String password;

  _loginUsers() async{
        if(_formKey.currentState!.validate()) {
                String res = await _authController.loginUsers(email, password);

                if (res == 'success' ) {
                  return Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return MainScreen();
                      }));
                } else {
                      return showSnack(context, res);
                }

        } else {
              return showSnack(context, 'Something Went Wrong....');
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login Costomer''s account',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink.shade900,
                    fontWeight: FontWeight.bold,
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator:  (value) {
                        if (value!.isEmpty) {
                            return 'Please Enter Email ID ';
                        }
                        bool emailValid = RegExp(
                            r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
                            r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
                            r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
                            r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
                            r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
                            r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
                            r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])'
                        ).hasMatch(value);
                        if(!emailValid){
                          return 'Please Enter valid email id';
                        }
                        else {
                                return null;
                        }
                    },
                    onChanged: ((value) {
                      email = value;
                    }),
                    decoration: InputDecoration(
                      labelText: 'Enter Email Address,'
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    validator:  (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Password ';
                      }
                      else if(password.length < 6) {
                                return ' Password must be more than 6 characters';
                      }
                      else {
                        return null;
                      }
                    },
                    onChanged: ((value) {
                      password = value;
                    }),
                    decoration: InputDecoration(
                        labelText: 'Enter password',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                    onTap: () {
                        _loginUsers();
                    },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.shade700,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text('Login',
                       style: TextStyle(
                         letterSpacing: 5,
                         fontSize: 19,
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                       ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ForgotPasswordScreen();
                      }));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Need an account'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return RegisterScreen();
                        }));
                      },
                        child: Text(
                        'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                            fontSize: 20,
                          ),
                    ),
                    ),

                  ],
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
