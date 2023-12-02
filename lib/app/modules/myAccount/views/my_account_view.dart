import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/Login/views/login_view.dart';
import 'package:mandirifurnitureapp/app/modules/myProfile/views/my_profile_view.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../../usePreferences/userPreferences.dart';
import '../../bag/views/bag_view.dart';
import '../../home/views/home_view.dart';
import '../controllers/my_account_controller.dart';

class MyAccountView extends GetView<MyAccountController> {
  const MyAccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _currentUser = Get.put(CurrentUser());

    /* User SIGN OUT */
    signOutUser() async {
      var resultResponse = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Logout",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure?\nyou want to logout from app?",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Get.back(result: "loggedOut");
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                )),
          ],
        ),
      );

      if (resultResponse == "loggedOut") {
        RememberUserPrefs.removeUserInfo().then((value) {
          Get.off(() =>LoginView());
        });
      }
    }
    /* User SIGN OUT-End */

    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _currentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: TextButton(
                onPressed: () {},
                child: Text(""),
              ),
              actions: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Colors.black,
                    ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'my account',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 32,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0.04,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: ShapeDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          "https://via.placeholder.com/56x56"),
                                      fit: BoxFit.fill,
                                    ),
                                    shape: OvalBorder(
                                      side: BorderSide(
                                          width: 1, color: Color(0xFFEEEEEE)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser.user.user_fullName,
                                style: TextStyle(
                                  color: Color(0xFF212121),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                _currentUser.user.user_id_phoneNumber,
                                style: TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    /* account list menu */
                    Container(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.person_outlined,
                              color: Colors.black,
                            ),
                            title: Text(
                              'My profile',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              Get.to(() => MyProfileView());
                            },
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.black,
                            ),
                            title: Text(
                              'My orders',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.favorite_outline,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Favorite',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.logout_outlined,
                              color: Colors.black,
                            ),
                            title: Text(
                              'Sign out',
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            onTap: () {
                              signOutUser();
                            },
                          ),
                        ],
                      ),
                    ),

                    /* Account list menu end */
                  ],
                ),
              ),
            ),
            /* Navbar */
            bottomNavigationBar: Padding(
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.elliptical(80, 80),
                      topRight: Radius.elliptical(80, 80),
                      bottomLeft: Radius.elliptical(80, 80),
                      bottomRight: Radius.elliptical(80, 80),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.to(() => HomeView());
                          },
                          icon: Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => BagView());
                          },
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Get.to(() => MyAccountView());
                          },
                          icon: Icon(
                            Icons.person_outlined,
                            color: Colors.black,
                            size: 32,
                          ),
                        )
                      ],
                    ),
                  ),
                )),
            /* Navbar end */
          );
        });
  }
}
