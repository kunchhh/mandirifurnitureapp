import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/home/views/home_view.dart';
import 'package:mandirifurnitureapp/app/widgets/mytextformfield.dart';
import '../../../../model/user.dart';
import '../../../../usePreferences/userPreferences.dart';
import '../../../widgets/passwordtextformfield.dart';
import '../../signUp/views/sign_up_view.dart';
import '../controllers/login_controller.dart';
import 'package:http/http.dart' as http;

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    
    final _formKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    /* Login user */
    loginUserNow() async {
      try {
        var res = await http.post(
          Uri.parse(api.userLogin),
          body: {
            "user_email": emailController.text.trim(),
            "user_password": passwordController.text.trim(),
          },
        );

        if (res.statusCode == 200) {
          var resBodyOfLogin = jsonDecode(res.body);
          if (resBodyOfLogin['success'] == true) {

            Get.snackbar("Success", "You're logged-in successfully",
                backgroundColor: Colors.green, colorText: Colors.white);

            User userInfo = User.fromJson(resBodyOfLogin["userData"]);
            await RememberUserPrefs.storeUserInfo(userInfo);
            Future.delayed(Duration(milliseconds: 2000), () {
             Get.off(() => HomeView());
            });
          } else {

            Get.snackbar("Incorrect Credentials.", "Please write correct password or email and Try Again.",
                backgroundColor: Colors.yellow.shade700, colorText: Colors.white);
          }
        } else {
          Get.snackbar("Error", "Status is not 200",
                backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMsg) {
        print("Error :: " + errorMsg.toString());
      }
    }
    /* Login user-end */

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background/login.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30.0, top: 130.0),
              child: Text(
                "Welcome",
                style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, top: 270.0),
              child: Text(
                "Login\nFirst!",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(top: 380, right: 35, left: 35),
                  child: Column(
                    children: [
                      MyTextFormField(
                        controller: emailController,
                        name: "Email",
                        prefixIcon: Icon(Icons.email_rounded),
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
                          emailController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      PasswordTextFormField(
                        controller: passwordController,
                        name: "Password",
                        prefixIcon: Icon(Icons.lock_rounded),
                        obscureText: true,
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
                          passwordController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange,
                            child: IconButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) ;
                                loginUserNow();
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.to(() => SignUpView());
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
