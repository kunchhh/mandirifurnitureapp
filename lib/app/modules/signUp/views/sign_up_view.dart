import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/Login/views/login_view.dart';

import '../../../../model/user.dart';
import '../controllers/sign_up_controller.dart';
import 'package:http/http.dart' as http;

class SignUpView extends GetView<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    final _formKey = GlobalKey<FormState>();
    var fullNameEditingController = TextEditingController();
    var emailEditingController = TextEditingController();
    var passwordEditingController = TextEditingController();
    var phoneNumberEditingController = TextEditingController();
    var dateOfBirthEditingController = TextEditingController();

    Future<void> _signUpAndSaveUserRecord() async {
      User userModel = User(
        fullNameEditingController.text.trim(),
        emailEditingController.text.trim(),
        passwordEditingController.text.trim(),
        phoneNumberEditingController.text.trim(),
        dateOfBirthEditingController.text.trim(),
      );
      try {
        var res = await http.post(
          Uri.parse(api.userSignUp),
          body: userModel.toJson(),
        );

        if (res.statusCode == 200) {
          var resBodyOfSignUp = jsonDecode(res.body);
          if (resBodyOfSignUp['success'] == true) {
            Get.snackbar(
                "Success", "Congratulations, you are Sign Up Successfully.",
                backgroundColor: Colors.green, colorText: Colors.white);

            fullNameEditingController.clear();
            emailEditingController.clear();
            passwordEditingController.clear();
            phoneNumberEditingController.clear();
            dateOfBirthEditingController.clear();
            
          } else {
            Get.snackbar("Error", "Error Occurred, Try Again.",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        } else {
          Get.snackbar("Status Code Error", "Status is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (e) {
        print(e.toString());
        Get.snackbar("Error", e.toString());
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
          (route) => false);
    }

    validateUserEmail() async {
      try {
        var res = await http.post(
          Uri.parse(api.userEmailValidated),
          body: {
            'user_email': emailEditingController.text.trim(),
          },
        );

        if (res.statusCode == 200) {
          var resBodyOfValidateEmail = jsonDecode(res.body);

          if (resBodyOfValidateEmail['emailFound'] == true) {
            Get.snackbar("Email Already Exists", "Try another email.",
                backgroundColor: Colors.yellowAccent.shade700,
                colorText: Colors.white);
          } else {
            _signUpAndSaveUserRecord();
          }
        } else {
          Get.snackbar("Status Code Error", "Status is not 200",
              backgroundColor: Colors.red, colorText: Colors.white);
        }
      } catch (e) {
        print(e.toString());
        Get.snackbar("Error", e.toString(), backgroundColor: Colors.white);
      }
    }

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/register.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.to(() => LoginView());
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
                margin: EdgeInsets.only(
                  left: 5.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Sign Up!",
                      style: TextStyle(
                          fontSize: 32,
                    fontFamily: "Poppins",

                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                )),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(top: 100, right: 35, left: 35),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullNameEditingController,
                        decoration: InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{3,}$');
                          if (value!.isEmpty) {
                            return ("User name Cannot Be Empty");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid User name(Min. 3 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          fullNameEditingController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailEditingController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return ("Please Enter Your Email");
                          }
                          if (!RegExp("^[a-zA-z0-9+_.-]+@[[a-zA-z0-9.-]+.[a-z]")
                              .hasMatch(value)) {
                            return ("Please Enter a valid email");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          emailEditingController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: passwordEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return ("Password is required for login");
                          }
                          if (!regex.hasMatch(value)) {
                            return ("Enter Valid Password(Min. 6 Character)");
                          }
                          return null;
                        },
                        onSaved: (value) {
                          passwordEditingController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: phoneNumberEditingController,
                        decoration: InputDecoration(
                          labelText: 'Phone number',
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w200,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Color(0xFFF5F5F5),
                        ),
                        validator: (value) {
                          RegExp regex = RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)');
                          if (value!.isEmpty) {
                            return "Phone Number Cannot Be Empty";
                          } else if (!regex.hasMatch(value)) {
                            return 'Please Enter Valid Phone Number (Min. 11 Character)';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          phoneNumberEditingController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DateTimeFormField(
                        decoration: InputDecoration(
                              labelText: 'Date of birthday',
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w200,
                              ),
                              hintText: ("MM-dd-yy"),
                              hintStyle: TextStyle(color: Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                              
                            ),
                        mode: DateTimeFieldPickerMode.date,
                        validator: (value) {
                          if (value == null) {
                            return 'Date of birthday cannot be empty';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          dateOfBirthEditingController.text = value!.toString();
                        },
                        onDateSelected: (DateTime value) {
                          dateOfBirthEditingController.text = value.toString();
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                validateUserEmail();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Container(
              width: 343,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  'Create account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF212121),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
