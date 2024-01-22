import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/checkout/views/checkout_view.dart';
import 'package:mandirifurnitureapp/app/modules/myAccount/views/my_account_view.dart';
import 'package:mandirifurnitureapp/app/modules/productDetail/views/product_detail_view.dart';
import 'package:mandirifurnitureapp/model/products.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../model/bag.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../favoriteProduct/views/favorite_product_view.dart';
import '../../home/views/home_view.dart';
import '../controllers/bag_controller.dart';
import 'package:http/http.dart' as http;

class BagView extends GetView<BagController> {
  const BagView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentOnlineUser = Get.put(CurrentUser());
    final bagListController = Get.put(BagController());

    calculateTotalAmount() {
      bagListController.setTotal(0);

      if (bagListController.selectedProductList.length > 0) {
        bagListController.bagList.forEach((productBag) {
          if (bagListController.selectedProductList
              .contains(productBag.bag_id)) {
            double eachProductTotalAmount = (productBag.product_price!) *
                (double.parse(productBag.bag_quantity.toString()));

            bagListController
                .setTotal(bagListController.total + eachProductTotalAmount);
          }
        });
      }
    }

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
          }
          bagListController.setList(bagListOfCurrentUser);
        } else {
          Get.snackbar("Error", "Status Code is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }
      calculateTotalAmount();
    }

    deleteSelectedProductFromUserBagList(int bagID) async {
      try {
        var res = await http.post(Uri.parse(api.deleteProductInTheBag), body: {
          "bag_id": bagID.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyFromDeleteBag = jsonDecode(res.body);

          if (responseBodyFromDeleteBag["success"] == true) {
            getCurrentUserBagList();
          }
        } else {
          Get.snackbar("Error", "Status Code is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMessage) {
        print("Error: " + errorMessage.toString());
      }
    }

    updateQuantityInUserBag(int bagID, int newQuantity) async {
      try {
        var res = await http.post(Uri.parse(api.updateProductInTheBag), body: {
          "bag_id": bagID.toString(),
          "bag_quantity": newQuantity.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyOfUpdateQuantity = jsonDecode(res.body);

          if (responseBodyOfUpdateQuantity["success"] == true) {
            getCurrentUserBagList();
          }
        } else {
          Get.snackbar("Error", "Status Code is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMessage) {
        print("Error: " + errorMessage.toString());
      }
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
              "totalAmount": selectedBagListProduct.product_price! *
                  selectedBagListProduct.bag_quantity!,
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
          automaticallyImplyLeading: false,
          actions: [
            // delete selected item
            GetBuilder(
                init: BagController(),
                builder: (c) {
                  if (bagListController.selectedProductList.length > 0) {
                    return IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.warning,
                          confirmBtnText: "Yes",
                          cancelBtnText: "Cancel",
                          showCancelBtn: true,
                          showConfirmBtn: true,
                          onCancelBtnTap: () => Get.back(),
                          onConfirmBtnTap: () async {
                            bagListController.selectedProductList
                                .forEach((selectedProductsUserBagId) {
                              deleteSelectedProductFromUserBagList(
                                  selectedProductsUserBagId);
                            });
                            calculateTotalAmount();
                            Get.back();
                          },
                          confirmBtnColor: Colors.orangeAccent,
                          title: "Delete",
                          text:
                              "Are you sure want to delete product from your bag?",
                        );
                      },
                    );
                  } else {
                     return Container();
                  }
                }),
            // delete selected product end
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Obx(
              () => bagListController.bagList.length > 0
                  ? ListView.builder(
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

                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              GetBuilder(
                                  init: BagController(),
                                  builder: (c) {
                                    return IconButton(
                                      icon: Icon(
                                          bagListController.selectedProductList
                                                  .contains(bagModel.bag_id)
                                              ? Icons.check_box
                                              : Icons
                                                  .check_box_outline_blank_rounded,
                                          color: bagListController.isSelectedAll
                                              ? Colors.black
                                              : Colors.black),
                                      onPressed: () {
                                        if (bagListController
                                            .selectedProductList
                                            .contains(bagModel.bag_id)) {
                                          bagListController
                                              .deleteSelectedProduct(
                                                  bagModel.bag_id!);
                                        } else {
                                          bagListController.addSelectedProduct(
                                              bagModel.bag_id!);
                                        }
                                        calculateTotalAmount();
                                      },
                                    );
                                  }),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ProductDetailView(
                                      productInfo: productsModel));
                                },
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 0,
                                        child: Container(
                                          height: 140,
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.0),
                                                    bottomLeft:
                                                        Radius.circular(10.0),
                                                  ),
                                                  child: Container(
                                                    width: 125,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: NetworkImage(bagModel
                                                            .product_mainImage!),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        // product name
                                                        Text(
                                                          "${bagModel.product_name}",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        // product name end

                                                        // Price
                                                        Text(
                                                          "\I\D\R\. ${bagModel.product_price}",
                                                          style: TextStyle(
                                                            color: Colors
                                                                .deepOrange
                                                                .shade900,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Poppins',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        // Price end

                                                        // set qty
                                                        Container(
                                                            height: 26,
                                                            width: 122,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .orange[400],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            12),
                                                                    onPressed:
                                                                        () {
                                                                      if (bagModel.bag_quantity! -
                                                                              1 >=
                                                                          1) {
                                                                        updateQuantityInUserBag(
                                                                            bagModel
                                                                                .bag_id!,
                                                                            bagModel.bag_quantity! -
                                                                                1);
                                                                      } else {
                                                                        Get.snackbar(
                                                                          "Error",
                                                                          "Tidak boleh kurang dari 1",
                                                                          backgroundColor: Colors
                                                                              .grey
                                                                              .shade100,
                                                                        );
                                                                      }
                                                                    },
                                                                  ),
                                                                  Text(
                                                                    bagModel
                                                                        .bag_quantity
                                                                        .toString(),
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          14,
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    icon: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            12),
                                                                    onPressed:
                                                                        () {
                                                                      updateQuantityInUserBag(
                                                                          bagModel
                                                                              .bag_id!,
                                                                          bagModel.bag_quantity! +
                                                                              1);
                                                                    },
                                                                  ),
                                                                ])),
                                                        // set qty end
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType
                                                            .warning,
                                                        confirmBtnText: "Yes",
                                                        cancelBtnText: "No",
                                                        showCancelBtn: true,
                                                        showConfirmBtn: true,
                                                        onCancelBtnTap: () =>
                                                            Get.back(),
                                                        onConfirmBtnTap: () =>
                                                            deleteSelectedProductFromUserBagList(
                                                                    bagModel
                                                                        .bag_id!)
                                                                .then(
                                                                    (isDeleted) {
                                                          if (isDeleted !=
                                                              null) {
                                                            setState(() {
                                                              bagListController
                                                                  .bagList
                                                                  .remove(
                                                                      bagModel);
                                                              calculateTotalAmount();
                                                            });
                                                          }
                                                          Get.back();
                                                        }),
                                                        confirmBtnColor:
                                                            Colors.orangeAccent,
                                                        title: "Delete",
                                                        text:
                                                            "Are you sure want to delete product from your bag?",
                                                      );
                                                    },
                                                    icon: Icon(
                                                        Icons.close_rounded))
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                  : Center(
                      child: Container(
                      width: double.infinity,
                        child: Column(
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/content/surprised.png",
                              width: 120.0,
                              height: 120.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Oooppss...",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Your bag is empty",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Get.to(() => HomeView());
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(325.0, 50.0)),
                              child: Text(
                                'Start Shopping',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
            );
          }),
        ),

        /* Navbar */
        bottomNavigationBar: GetBuilder(
          init: BagController(),
          builder: (c) {
            return Container(
              height: 117,
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // select all button
                      Row(
                        children: [
                          Obx(() => IconButton(
                                icon: Icon(
                                  bagListController.isSelectedAll
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: bagListController.isSelectedAll
                                      ? Colors.black
                                      : Colors.black,
                                ),
                                onPressed: () {
                                  bagListController.setIsSelectedAllProducts();
                                  bagListController.clearAllSelectedProducts();
                                  if (bagListController.isSelectedAll) {
                                    bagListController.bagList
                                        .forEach((eachProduct) {
                                      bagListController.addSelectedProduct(
                                          eachProduct.bag_id!);
                                    });
                                  }
                                  calculateTotalAmount();
                                },
                              )),
                          Text("Select all")
                        ],
                      ),
                      // select all button end
                      Container(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Total: ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Obx(() => Text(
                                    "\I\D\R\. " +
                                        bagListController.total
                                            .toStringAsFixed(0),
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange.shade900,
                                    ),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                                onPressed: () {
                                  bagListController.selectedProductList.length > 0 
                                  ? Get.to(
                                    () => CheckoutView(
                                      selectedProductListInfo: getSelectedBagListProductsInformation(),
                                      totalAmount: bagListController.total,
                                      selectedBagIDs: bagListController.selectedProductList,
                                    ),
                                    transition: Transition.rightToLeft, 
                                    duration: Duration(milliseconds:300),
                                  )
                                  : null;
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: bagListController.selectedProductList.length > 0 
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  minimumSize: Size(100, 35),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                                color: Colors.white,
                                size: 32,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
