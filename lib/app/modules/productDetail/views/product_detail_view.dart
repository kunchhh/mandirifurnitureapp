import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/widgets/btnLike.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../model/products.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../widgets/Shimmer.dart';
import '../controllers/product_detail_controller.dart';
import 'package:http/http.dart' as http;

class ProductDetailView extends GetView<ProductDetailController> {
  final Products productInfo;

  const ProductDetailView({Key? key, required this.productInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productDetailController = Get.put(ProductDetailController());
    final currentOnlineUser = Get.put(CurrentUser());

    /* func addToBag */
    addProductToBag() async {
      try {
        var res = await http.post(Uri.parse(api.addToBag), body: {
          "bag_user_id": currentOnlineUser.user.user_id_phoneNumber.toString(),
          "bag_product_id": productInfo.product_id.toString(),
          "bag_quantity": productDetailController.quantity.toString(),
          "bag_color": productInfo.product_color![controller.color],
        });
        if (res.statusCode == 200) {
          var resBodyOfAddCart = jsonDecode(res.body);
          if (resBodyOfAddCart['success'] == true) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Product saved to bag successfully',
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: "Error, Product not saved to Bag and Try Again.",
            );
          }
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: "Error, Status is not 200",
          );

        }
      } catch (errorMsg) {
        Get.snackbar('Failed', errorMsg.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 2));
        print("Error :: " + errorMsg.toString());
      }
    }
    /* func addToBag */

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'ProductDetailView',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          actions: [btnLike()],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              Container(
                padding: EdgeInsets.all(18),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\I\D\R\. ${productInfo.product_price}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.deepOrange.shade900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${productInfo.product_name}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          _buildQty(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ' ${productInfo.product_description}',
                        textAlign: TextAlign.justify,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildColor(),
                              /* GestureDetector(
                                onTap: () {
                                  controller.toggleSelected();
                                },
                                child: Obx(() => Container(
                                      padding: EdgeInsets.all(10),
                                      height: 40,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: controller.isSelected.value
                                              ? Colors.transparent
                                              : Colors.grey.shade600,
                                        ),
                                        color: controller.isSelected.value
                                            ? Colors.yellow.shade700
                                            : Colors.white,
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFA46506),
                                              shape: OvalBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFEEEEEE),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'Brown',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              height: 0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                              ),
                               */
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ],
                      )
                    ]),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You might also like',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    otherProducts(context)
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Container(
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  addProductToBag();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add to bag",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Widget _buildColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Choose color :",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              const SizedBox(height: 8),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children:
                    List.generate(productInfo.product_color!.length, (index) {
                  return Obx(
                    () => GestureDetector(
                      onTap: () {
                        controller.setColorProduct(index);
                      },
                      child: Container(
                        height: 35,
                        width: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: controller.color == index
                                ? Colors.transparent
                                : Colors.yellow.shade700,
                          ),
                          color: controller.color == index
                              ? Colors.yellow.shade700
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          productInfo.product_color![index]
                              .replaceAll("[", "")
                              .replaceAll("]", ""),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      child: Container(
        height: 300,
        child: Carousel(
          radius: Radius.circular(10),
          autoplay: true,
          autoplayDuration: Duration(seconds: 10),
          showIndicator: true,
          dotBgColor: Colors.transparent,
          dotSize: 3,
          boxFit: BoxFit.fill,
          images: [
            NetworkImage("${productInfo.product_mainImage}"),
            NetworkImage("${productInfo.product_Image1}"),
            NetworkImage("${productInfo.product_Image2}")
          ],
        ),
      ),
    );
  }

  Widget _buildQty() {
    return Container(
      height: 35,
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.yellow.shade700,
      ),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.remove, color: Colors.black, size: 18),
              onPressed: () {
                if (controller.count.value > 0) {
                  controller.count.value--;
                } else {
                  Get.snackbar(
                    "Error",
                    "Tidak boleh kurang dari nol",
                    backgroundColor: Colors.grey.shade100,
                  );
                }
              },
            ),
            Obx(() => Text(
                  controller.count.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )),
            IconButton(
              icon: Icon(Icons.add, color: Colors.black, size: 18),
              onPressed: () {
                controller.count.value++;
              },
            ),
          ]),
    );
  }

  /* List newestProduct */
  Future<List<Products>> newestProduct() async {
    List<Products> allNewestProductList = [];

    try {
      var res = await http.post(Uri.parse(api.newestProduct));

      if (res.statusCode == 200) {
        var responseBodyOfAllNewestProduct = jsonDecode(res.body);
        if (responseBodyOfAllNewestProduct["success"] == true) {
          (responseBodyOfAllNewestProduct["productsData"] as List)
              .forEach((eachRecord) {
            allNewestProductList.add(Products.fromJson(eachRecord));
          });
        }
      } else {
        Get.snackbar("Error", "status is not 200",
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return allNewestProductList;
  }
  /* List newestProduct end */

  /* Widget otherProducts*/
  Widget otherProducts(context) {
    return FutureBuilder(
      future: newestProduct(),
      builder: (context, AsyncSnapshot<List<Products>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              SizedBox(width: 10),
              ShimmerHorizontal(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              ShimmerHorizontal(),
              SizedBox(width: 10),
            ],
          );
        }
        if (dataSnapShot.data == null) {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset(
                    "assets/content/dissatisfied.png",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "No product found!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
        if (dataSnapShot.data!.length > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.38,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 10),
              itemCount: dataSnapShot.data!.length,
              itemBuilder: (context, index) {
                Products eachProductsRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() =>
                        ProductDetailView(productInfo: eachProductsRecord));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Card(
                      child: Container(
                        color: Colors.white,
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                    eachProductsRecord.product_mainImage!,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 0),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\I\D\R\. ${eachProductsRecord.product_price}",
                                        maxLines: 1,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.deepOrange.shade900,
                                        ),
                                      ),
                                      btnLike(),
                                    ],
                                  ),
                                  Text(
                                    eachProductsRecord.product_name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                  ),
                                  Text(
                                    eachProductsRecord.product_description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 100),
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset(
                    "assets/content/surprised.png",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Connection problem!",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "No data product",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
  /* Widget otherProducts end*/
}
