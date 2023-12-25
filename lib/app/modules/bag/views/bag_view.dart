import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/myAccount/views/my_account_view.dart';
import 'package:mandirifurnitureapp/model/products.dart';

import '../../../../model/bag.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../home/views/home_view.dart';
import '../controllers/bag_controller.dart';
import 'package:http/http.dart' as http;

class BagView extends GetView<BagController> {
  const BagView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    
    final currentOnlineUser = Get.put(CurrentUser());
    final bagListController = Get.put(BagController());    

    getCurrentUserBagList() async {
      List<Bag> bagListOfCurrentUser = [];

      try {
        var res = await http.post(Uri.parse(api.readBagFromUser), body: {
          "currentOnlineUserID": currentOnlineUser.user.user_id_phoneNumber,
        });

        if (res.statusCode == 200) {
          var responseBodyOfGetCurrentUserBagProducts = jsonDecode(res.body);

          if (responseBodyOfGetCurrentUserBagProducts['success'] == true) {
            (responseBodyOfGetCurrentUserBagProducts['currentUserBagData']
                    as List)
                .forEach((eachCurrentUserBagItemData) {
              bagListOfCurrentUser
                  .add(Bag.fromJson(eachCurrentUserBagItemData));
            });
          } else {
            Get.snackbar("Information", "Your cart list is empty.",
                backgroundColor: Colors.black, colorText: Colors.white);
          }

          bagListController.setList(bagListOfCurrentUser);
        } else {
          Get.snackbar("Error", "Status Code is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }
      /* calculateTotalAmount(); */
    }

    List<Map<String, dynamic>> getSelectedBagListProductsInformation() {
      List<Map<String, dynamic>> SelectedBagListProductsInformation = [];
      if (bagListController.selectedProductList.length > 0) {
        bagListController.bagList.forEach((selectedBagListProduct) {
          if (bagListController.selectedProductList
              .contains(selectedBagListProduct.bag_id)) {
            Map<String, dynamic> productInformation = {
              "product_id": selectedBagListProduct.bag_product_id,
              "product_name": selectedBagListProduct.product_name,
              "product_category": selectedBagListProduct.product_category,
              "bag_color": selectedBagListProduct.bag_color,
              "bag_quantity": selectedBagListProduct.bag_quantity,
              "product_price": selectedBagListProduct.product_price,
              "product_mainImage": selectedBagListProduct.product_mainImage,
              "product_Image1": selectedBagListProduct.product_Image1,
              "product_Image2": selectedBagListProduct.product_Image2,

              /* "totalAmount": selectedBagListProduct.product_price! *
                  selectedBagListProduct.bag_quantity!, */
            };
            SelectedBagListProductsInformation.add(productInformation);
          }
        });
      }
      return SelectedBagListProductsInformation;
    }

    controller.onInit();
    getCurrentUserBagList();
    
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            " Bag",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          automaticallyImplyLeading: false),

        body: Obx(() => bagListController.bagList.length > 0 
        ?
          ListView.builder(
            itemCount: bagListController.bagList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              Bag bagModel = bagListController.bagList[index];

              Products productsModel = Products(
                product_id: bagModel.bag_product_id,
                product_name: bagModel.product_name,
                product_category: bagModel.product_category,
                product_color: bagModel.product_color,
                product_price: bagModel.product_price,
                product_description: bagModel.product_description,
                product_mainImage: bagModel.product_mainImage,
                product_Image1: bagModel.product_Image1,
                product_Image2: bagModel.product_Image2,
              );

              return GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Card(
                          color: Colors.white,
                          elevation: 0,
                          child: Container(
                            height: 140,
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 125,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              bagModel.product_mainImage!),
                                        )),
                                  ),
                                  Container(
                                    width: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "\I\D\R\. ${bagModel.product_price}",
                                            style: TextStyle(
                                              color: Colors.deepOrange.shade900,
                                              fontSize: 18,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '${bagModel.product_name}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              color: Color(0xFF9E9E9E),
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          Container(
                                              height: 35,
                                              width: 130,
                                              decoration: BoxDecoration(
                                                color: Colors.yellow.shade700,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      icon: Icon(Icons.remove,
                                                          color: Colors.black,
                                                          size: 18),
                                                      onPressed: () {
                                                        if (controller
                                                                .count.value >
                                                            0) {
                                                          controller
                                                              .count.value--;
                                                        } else {
                                                          Get.snackbar(
                                                            "Error",
                                                            "Tidak boleh kurang dari nol",
                                                            backgroundColor:
                                                                Colors.grey
                                                                    .shade100,
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    Obx(() => Text(
                                                          controller.count
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                          ),
                                                        )),
                                                    IconButton(
                                                      icon: Icon(Icons.add,
                                                          color: Colors.black,
                                                          size: 18),
                                                      onPressed: () {
                                                        controller.count.value++;
                                                      },
                                                    ),
                                                  ])),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.close_rounded))
                                ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            
              }) : Center(

              )
        ),

      /* body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              /* List item  */
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Container(
                          height: 140,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 125,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/content/product-2.png'),
                                      )),
                                ),
                                Container(
                                  width: 180,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "\I\D\R\. 150.000",
                                          style: TextStyle(
                                            color: Colors.deepOrange.shade900,
                                            fontSize: 18,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Wooden bedside table featuring a raised design',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: Color(0xFF9E9E9E),
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Container(
                                            height: 35,
                                            width: 130,
                                            decoration: BoxDecoration(
                                              color: Colors.yellow.shade700,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.remove,
                                                        color: Colors.black,
                                                        size: 18),
                                                    onPressed: () {
                                                      if (controller
                                                              .count.value >
                                                          0) {
                                                        controller
                                                            .count.value--;
                                                      } else {
                                                        Get.snackbar(
                                                          "Error",
                                                          "Tidak boleh kurang dari nol",
                                                          backgroundColor:
                                                              Colors.grey
                                                                  .shade100,
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Obx(() => Text(
                                                        controller.count
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 18,
                                                        ),
                                                      )),
                                                  IconButton(
                                                    icon: Icon(Icons.add,
                                                        color: Colors.black,
                                                        size: 18),
                                                    onPressed: () {
                                                      controller.count.value++;
                                                    },
                                                  ),
                                                ])),
                                      ],
                                    ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.close_rounded))
                              ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /* List item end */
              SizedBox(
                height: 20,
              ),
            ]),
          )),
 */
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
                      color: Colors.black,
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
                      color: Colors.white,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
