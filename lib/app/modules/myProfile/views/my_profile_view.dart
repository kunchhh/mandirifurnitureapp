import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:date_field/date_field.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../model/user.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../../usePreferences/userPreferences.dart';
import '../controllers/my_profile_controller.dart';
import 'package:http/http.dart' as http;

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _currentUser = Get.put(CurrentUser());
    final _formKey = GlobalKey<FormState>();
    Get.put(MyProfileController());

    /*Function userUpdateData */
    Future updateProfile(User user) async {
      try {
        var res = await http.post(
          Uri.parse(api.userUpdateData),
          body: {
            "user_fullName": user.user_fullName,
            "user_email": user.user_email,
            "user_id_phoneNumber": user.user_id_phoneNumber,
            "user_dateOfBirth": user.user_dateOfBirth.toString(),
          },
        );

        if (res.statusCode == 200) {
          var responseBody = jsonDecode(res.body);

          if (responseBody["success"] == true) {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                text: 'Update profile successfully!',
                confirmBtnColor: Colors.orange);

            RememberUserPrefs.updateUserInfo(_currentUser.user).then((value) {
              _currentUser.user.user_fullName = user.user_fullName;
              _currentUser.user.user_email = user.user_email;
              _currentUser.user.user_id_phoneNumber = user.user_id_phoneNumber;
              _currentUser.user.user_dateOfBirth =
                  user.user_dateOfBirth.toString();

              controller.update();
              Get.off(() => MyProfileView());
            });

            return true;
          } else {
            QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Oops...',
                text: 'Sorry, Failed to update',
                confirmBtnColor: Colors.orange);
            return false;
          }
        } else {
          QuickAlert.show(
              context: context,
              type: QuickAlertType.warning,
              text: 'Status code is not 200',
              confirmBtnColor: Colors.orange);
          return false;
        }
      } catch (errorMessage) {
        print("Error: $errorMessage");
        QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            text: '$errorMessage',
            confirmBtnColor: Colors.orange);
        return false;
      }
    }
    /*Function userUpdateData-end*/

    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _currentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: const Text(
                  'My profile',
                  style:
                TextStyle(fontWeight: FontWeight.w400, fontFamily: "Poppins"),
                ),
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateProfile(_currentUser.user);
                        controller.update();
                      }
                      Get.off(() => MyProfileView());
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.yellow.shade800,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins"
                      ),
                    ),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            color: Colors.white,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 76,
                                    height: 76,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/content/friendly.png"),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: OvalBorder(
                                        side: BorderSide(
                                            width: 1, color: Color(0xFFEEEEEE)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          /* Form field */

                          Container(
                            color: Colors.white,
                            constraints: BoxConstraints(minHeight: 550),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    initialValue:
                                        _currentUser.user.user_fullName,
                                    onChanged: (value) {
                                      _currentUser.user.user_fullName = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Full name',
                                      labelStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF5F5F5),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    initialValue: _currentUser.user.user_email,
                                    onChanged: (value) {
                                      _currentUser.user.user_email = value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      labelStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF5F5F5),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("Please Enter Your Email");
                                      }
                                      if (!RegExp(
                                              "^[a-zA-z0-9+_.-]+@[[a-zA-z0-9.-]+.[a-z]")
                                          .hasMatch(value)) {
                                        return ("Please Enter a valid email");
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        _currentUser.user.user_id_phoneNumber,
                                    onChanged: (value) {
                                      _currentUser.user.user_id_phoneNumber =
                                          value;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Phone number',
                                      labelStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF5F5F5),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    validator: (value) {
                                      RegExp regex =
                                          RegExp(r'(^(?:[+0]9)?[0-9]{11,12}$)');
                                      if (value!.isEmpty) {
                                        return "Phone Number Cannot Be Empty";
                                      } else if (!regex.hasMatch(value)) {
                                        return 'Please Enter Valid Phone Number (Min. 11 Character)';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  DateTimeFormField(
                                    initialValue:
                                        _currentUser.user.user_dateOfBirth !=
                                                null
                                            ? DateTime.parse(_currentUser
                                                .user.user_dateOfBirth
                                                .toString())
                                            : null,
                                    decoration: InputDecoration(
                                      labelText: 'Date of birthday',
                                      labelStyle: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 18,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.transparent),
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFF5F5F5),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                    ),
                                    mode: DateTimeFieldPickerMode.date,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Date of birthday cannot be empty';
                                      }
                                      return null;
                                    },
                                    onDateSelected: (DateTime value) {
                                      _currentUser.user.user_dateOfBirth =
                                          value.toString();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
    
                          /* Form Field End */
                        ]),
                  ),
                ),
              ));
        });
  }
}
