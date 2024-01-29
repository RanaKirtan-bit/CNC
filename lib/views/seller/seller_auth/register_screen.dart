// register_seller_screen.dart

import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../seller_controllers/seller_auth_controller.dart';
import 'login_screen.dart';

const List<String> list = <String>['Yes', 'No'];


class RegisterSellerScreen extends StatefulWidget {
  @override
  State<RegisterSellerScreen> createState() => _RegisterSellerScreenState();
}

class _RegisterSellerScreenState extends State<RegisterSellerScreen> {

  final SellerAuthController _sellerAuthController = SellerAuthController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _businessName = TextEditingController();
  final _contactNumber = TextEditingController();
  final _email = TextEditingController();
  final _gstNumber = TextEditingController();
  final _pinCode = TextEditingController();
  final _address = TextEditingController();
  final _landmark = TextEditingController();
  final _password = TextEditingController();

  String? _bName;
  String? _taxStatus;
  late String email;
  late String shopName;
  late String phoneNumber;
  late String password;
  bool _isLoading = false;
  final ImagePicker picker = ImagePicker();
  XFile? _shopImage;
  XFile? _logo;
  String? countryValue ;
  String? stateValue ;
  String? cityValue ;

  _scaffold(message){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,),
        action: SnackBarAction(
          label: 'OK',
          onPressed: (){
            ScaffoldMessenger.of(context).clearSnackBars();
          },
        ),
    ));
  }

  Widget _formField({TextEditingController? controller, String? label, TextInputType? type, String? Function(String?)? validator}){
    return TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixText: controller == _contactNumber ? '+91' : null,
      ),
      validator: validator,
      onChanged: (value){
        if(controller== _businessName){
          setState(() {
            _bName = value;
          });
        }
      },
    );
  }

  _signUpSeller() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      await _sellerAuthController
          .signUpSellers(
        _email.text,
        _businessName.text,
        _contactNumber.text,
        _password.text,
        _shopImage,  // XFile for shop image
        _logo,       // XFile for logo
        _gstNumber.text,
        _address.text,
        _pinCode.text,
        _landmark.text,
        countryValue,
        stateValue,
        cityValue,
      ).whenComplete(() {
        setState(() {
          _formKey.currentState!.reset();
          _isLoading = false;
        });
      });
      // Handle success or show a snackbar
      // ...
    } else {
      setState(() {
        _isLoading = false;
      });
      // Handle validation errors or show a snackbar
      // ...
    }
  }

  Future<XFile?>_pickImage() async{
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        return image;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    _shopImage == null ?
                    Container(
                      color: Colors.blue,
                      height: 250,
                      child: TextButton(
                        child: Center(
                          child: Text(
                            'Tap to add shop image',
                            style: TextStyle(color: Colors.grey.shade800),
                          ),
                        ),
                        onPressed: (){
                                          _pickImage().then((value){
                                              setState(() {
                                                  _shopImage = value;
                                              });
                                          });
                        },
                      ),
                    ) : InkWell(
                      onTap: (){
                        _pickImage().then((value) {
                              setState(() {
                                _shopImage = value;
                              });
                        });
                      },
                      child: Container(
                            height: 240,
                        decoration: BoxDecoration(
                              color: Colors.blue,
                          image:DecorationImage(
                              opacity: 110,
                              image: FileImage(File(_shopImage!.path),),
                              fit:BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 80,
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        actions: [
                          IconButton(
                              onPressed: (){
                                FirebaseAuth.instance.signOut();
                              },
                              icon: Icon(Icons.exit_to_app)
                          ),
                        ],
                      ),
                    ),
                     Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                             InkWell(
                               onTap: (){
                                 _pickImage().then((value) {
                                   setState(() {
                                     _logo = value;
                                   });
                                 });
                               },
                               child: Card(
                                elevation: 5,
                                child:  _logo == null ? const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                      child: Text('+')
                                  ),
                                ): ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Image.file(File(_logo!.path),)
                                  ),
                                ),
                            ),
                             ),
                             const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _bName == null ?  ' ' : _bName!,
                              style: const TextStyle(fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,8,30,8),
                child: Column(
                  children: [
                      _formField(
                        controller: _businessName,
                        label: "Business Name",
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Business Name";
                          }
                        }
                        ),

                    _formField(
                        controller: _contactNumber,
                        label: 'Contact Number',
                        type: TextInputType.phone,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Contact Number";
                          }
                        }
                    ),
                    _formField(
                      controller: _password,
                      label: 'Enter Password',
                      type: TextInputType.text,
                      //isPassword: true, // Set isPassword to true for password field
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        } else if (value.length < 6) {
                          return 'Password must be more than 6 characters';
                        } else {
                          return null;
                        }
                      },
                    ),
                    _formField(
                        controller: _email,
                        label: 'Email',
                        type: TextInputType.emailAddress,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Email  ";
                          }
                               bool _isValid = (EmailValidator.validate(value));
                          if(_isValid==false){
                            return 'Invalid Email';
                          }

                        }
                    ),


                      SizedBox(
                        height: 10,
                      ),
                     Row(
                      children: [
                        const Text(' Tax Registered: '),
                        Expanded(
                          child: DropdownButtonFormField(
                              value: _taxStatus,
                              validator: (String? value){
                                if(value == null){
                                          return 'Select Tax Status';
                                }
                              },
                              hint: const Text('select'),
                              items:
                              list.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value){
                                setState(() {
                                  _taxStatus= value;
                                });

                          }),
                        ),
                      ],
                    ),
                    if(_taxStatus=="Yes")
                      _formField(
                          controller: _gstNumber,
                          label: 'GST Number',
                          type: TextInputType.text,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Enter GST Number  ";
                            }
                          }
                      ),

                    _formField(
                        controller: _address,
                        label: ' Address ',
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Address   ";
                          }
                        }
                    ),

                    _formField(
                        controller: _pinCode,
                        label: 'PIN Code',
                        type: TextInputType.number,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter PIN Code  ";
                          }
                        }
                    ),
                    _formField(
                        controller: _landmark,
                        label: ' Landmark ',
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Landmark  ";
                          }
                        }
                    ),
                    SizedBox(height: 10,),
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: true,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          //color: Colors.grey.shade300,
                          border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "Country",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "Country",
                      stateDropdownLabel: "State",
                      cityDropdownLabel: "City",

                      ///Default Country
                      defaultCountry: CscCountry.India,

                      ///Country Filter [OPTIONAL PARAMETER]
                      countryFilter: [CscCountry.India,CscCountry.United_States,CscCountry.Canada],

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = value;
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = value;
                        });
                      },

                      ///Show only specific countries using country filter
                      // countryFilter: ["United States", "Canada", "Mexico"],
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_shopImage == null) {
                        _scaffold('Shop Image not selected');
                        return;
                      }
                      if (_logo == null) {
                        _scaffold('Logo not selected');
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        if (countryValue == null || stateValue == null || cityValue == null) {
                          _scaffold('Select address field completely ');
                          return;
                        }
                        _signUpSeller();
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.shade700,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLoading
                            ? CircularProgressIndicator(
                          color: Colors.indigoAccent.shade700,
                        )
                            : Text(
                          'Register',
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
              ),
            ],
          ),
        ],
      ),
    );

  }
}

// Build UI for seller registration screen
    // ...



/*
      Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA6F1DF),Color(0xFFFFBBBB)],
              begin: FractionalOffset(0.5, 0.7),
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                        shopName = value;
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
                        _signUpSeller();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width -40,height: 50, decoration: BoxDecoration(
                        color: Colors.deepOrange.shade700,
                        borderRadius: BorderRadius.circular(10),

                      ),
                        child: Center(

                          child: _isLoading ? CircularProgressIndicator(
                            color: Colors.indigoAccent.shade700,
                          ): Text('Register',
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
                          return LoginSellerScreen();
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

       */

/*
 _formField(
                        controller: _city,
                        label: 'City',
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter City Name   ";
                          }
                        }
                    ),
                    _formField(
                        controller: _state,
                        label: 'State',
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter State Name";
                          }
                        }
                    ),
                    _formField(
                        controller: _country,
                        label: 'Country',
                        type: TextInputType.text,
                        validator: (value){
                          if(value!.isEmpty){
                            return "Enter Country Name  ";
                          }
                        }
                    ),
 */