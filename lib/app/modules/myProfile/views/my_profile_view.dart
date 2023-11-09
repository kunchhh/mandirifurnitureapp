import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:date_field/date_field.dart';

import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'My profile',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
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
                onPressed: () {},
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.yellow.shade800, fontWeight: FontWeight.w500),
                ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 76,
                      height: 76,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image:
                              NetworkImage("https://via.placeholder.com/76x76"),
                          fit: BoxFit.fill,
                        ),
                        shape: OvalBorder(
                          side: BorderSide(width: 1, color: Color(0xFFEEEEEE)),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          "Change photo",
                          style: TextStyle(color: Colors.yellow.shade800),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              /* Form field */

              TextField(
                decoration: InputDecoration(
                  labelText: 'Full name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'Kuncoro Adin Nugraha',
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
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: '+62 857 xxx xxx',
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
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'kunchh@gmail.com',
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
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              DateTimeFormField(
                decoration: InputDecoration(
                  labelText: 'Date of birthday',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: 'January 29, 2000',
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
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                mode: DateTimeFieldPickerMode.date,
              ),
              SizedBox(
                height: 20,
              ),

              /* Form Field End */
            ]),
          ),
        ));
  }
}
