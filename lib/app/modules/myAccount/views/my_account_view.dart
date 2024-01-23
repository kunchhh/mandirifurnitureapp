import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/Login/views/login_view.dart';
import 'package:mandirifurnitureapp/app/modules/favoriteProduct/views/favorite_product_view.dart';
import 'package:mandirifurnitureapp/app/modules/myOrders/views/my_orders_view.dart';
import 'package:mandirifurnitureapp/app/modules/myProfile/views/my_profile_view.dart';
import 'package:quickalert/quickalert.dart';
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
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        confirmBtnText: "Yes",
        cancelBtnText: "Cancel",
        showCancelBtn: true,
        showConfirmBtn: true,
        onCancelBtnTap: () => Get.back(),
        onConfirmBtnTap: () {
          RememberUserPrefs.removeUserInfo().then((value) {
            Get.off(() => LoginView());
          });
        },
        confirmBtnColor: Colors.orangeAccent,
        title: "Logout",
        text: "Are you sure?\nDo you want to logout from the app?",
      );
    }
    /* User SIGN OUT-End */

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
              title: Text(
                'My account',
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
             automaticallyImplyLeading: false,
            ),
            body:  SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    
                    // info account
                    Container(
                      
                      color: Colors.white,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                
                                Container(
                                  width: 86,
                                  height: 86,
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
                      height: 5,
                    ),

                    /* account list menu */
                    Container(
                      color: Colors.white,
                      constraints: BoxConstraints(
                        minHeight: 515
                      ),
                      child: Column(
                        children: [
                          Container(
                            child: ListTile(
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
                              trailing: Icon(Icons.arrow_forward_ios_rounded),
                              onTap: () {
                                Get.to(() => MyProfileView());
                              },
                            ),
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
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
                            onTap: () {
                              Get.to(() => MyOrdersView());
                            },
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
                            trailing: Icon(Icons.arrow_forward_ios_rounded),
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
            /* Navbar */
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
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
                            onPressed: () {
                              Get.to(() => FavoriteProductView());
                            },
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
            ),
            /* Navbar end */
          );
        });
  }
}
