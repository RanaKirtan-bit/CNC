
import 'package:clickncart/controllers/auth_controller.dart';
import 'package:clickncart/utils/show_snackBar.dart';
import 'package:clickncart/views/buyers/auth/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String email;

  late String fullName;

  late String phoneNumber;

  late String password;

  bool _isLoading = false;

  _signUpUser() async{
        setState(() {
              _isLoading = true;
        });
          if(_formkey.currentState!.validate()){
               await _authController.signUpUsers(email, fullName, phoneNumber, password).whenComplete(()  {
                      setState(() {
                            _formkey.currentState!.reset();
                            _isLoading = false;
                      });
               });
               Navigator.pushReplacement(
                 context,
                 MaterialPageRoute(
                   builder: (context) => LoginScreen(), // Replace LoginScreen with your actual seller login screen
                 ),
               );
               return showSnack(context, 'Congratulations Registred Successfully');


          } else {
                setState(() {
                      _isLoading = false;
                });
                return showSnack(context, 'Something Went Wrong....');
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
              begin: FractionalOffset(0.5, 0.7),
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
                  key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Create Customer''s account',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.pink.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Email';
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
                            return 'Enter valid email';
                        }
                        else {
                          return null;
                        }
                      },
                      onChanged: (value){
                        email = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter email',
                        prefixIcon: Icon(Icons.email, color: Colors.black,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Full Name';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value){
                        fullName = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Full name',
                        prefixIcon: Icon(Icons.person, color: Colors.black,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Phone Number';
                        }
                        else if (value.length != 10){
                                return 'enter valid phone  Number';
                        }
                        else {
                          return null;
                        }
                      },
                      onChanged: (value){
                        phoneNumber = value;
                      },
                      decoration: InputDecoration(
                        labelText: ' Enter Phone no',
                        prefixIcon: Icon(Icons.phone, color: Colors.black,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please Enter Password';
                        }
                        else if(password.length < 6) {
                          return ' Password must be more than 6 characters';
                        }
                        else {
                          return null;
                        }
                      },
                      onChanged: (value){
                        password = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.black,),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        _signUpUser();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width -40,height: 50, decoration: BoxDecoration(
                        color: Colors.deepOrange.shade700,
                            borderRadius: BorderRadius.circular(10),

                      ),
                        child: Center(

                          child: _isLoading ? CircularProgressIndicator(
                                color: Colors.indigoAccent.shade700,
                          ): const Text('Register',
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already Have an Account?   '),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return LoginScreen();
                        }));
                      }, child: Text(

                        'Login',
                        style: TextStyle(
                          color: Colors.pink.shade900,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
      ),
    );
  }
}
