import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:lecle_flutter_carousel_pro/lecle_flutter_carousel_pro.dart';
import 'package:mandirifurnitureapp/app/modules/productDetail/views/product_detail_ver2.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../model/products.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../widgets/Shimmer.dart';
import '../controllers/product_detail_controller.dart';
import 'package:http/http.dart' as http;

class ProductDetailView extends GetView<ProductDetailController> {
  final Products productInfo;

  ProductDetailView({Key? key, required this.productInfo}) : super(key: key);

  final productDetailController = Get.put(ProductDetailController());
  final currentOnlineUser = Get.put(CurrentUser());

  @override
  Widget build(BuildContext context) {
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
              confirmBtnColor: Colors.orangeAccent,
            );
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: "Error, Product not saved to Bag and Try Again.",
              confirmBtnColor: Colors.orangeAccent,
            );
          }
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: "Error, Status is not 200",
            confirmBtnColor: Colors.orangeAccent,
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
    /* func addToBag end */

    /* validate favorite product list */
    validateFavoriteProductList() async {
      try {
        var res = await http.post(
          Uri.parse(api.validateFavoriteProduct),
          body: {
            "favorite_user_id":
                currentOnlineUser.user.user_id_phoneNumber.toString(),
            "favorite_product_id": productInfo.product_id.toString(),
          },
        );

        if (res.statusCode == 200) {
          var resBodyOfvalidateFavoriteProduct = jsonDecode(res.body);
          if (resBodyOfvalidateFavoriteProduct['favoriteFound'] == true) {
            productDetailController.setIsFavorite(true);
          } else {
            productDetailController.setIsFavorite(false);
          }
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: "Error, Status is not 200",
            confirmBtnColor: Colors.orangeAccent,
          );
        }
      } catch (errorMsg) {
        print("Error :: " + errorMsg.toString());
      }
    }
    /* validate favorite product list end */

    /* add favorite product*/
    addFavoriteProduct() async {
      try {
        var res = await http.post(
          Uri.parse(api.addFavoriteProduct),
          body: {
            "favorite_user_id":
                currentOnlineUser.user.user_id_phoneNumber.toString(),
            "favorite_product_id": productInfo.product_id.toString(),
          },
        );

        if (res.statusCode == 200) {
          var resBodyOfaddFavoriteProduct = jsonDecode(res.body);
          if (resBodyOfaddFavoriteProduct['success'] == true) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Product saved to favorite list successfully',
              confirmBtnColor: Colors.orangeAccent,
            );
            validateFavoriteProductList();
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: "Error, Product not saved to favorite list, Try Again.",
              confirmBtnColor: Colors.orangeAccent,
            );
          }
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: "Error, Status is not 200",
            confirmBtnColor: Colors.orangeAccent,
          );
        }
      } catch (errorMsg) {
        print("Error :: " + errorMsg.toString());
      }
    }
    /* add favorite product end*/

    /* delete favorite product*/
    deleteFavoriteProduct() async {
      try {
        var res = await http.post(
          Uri.parse(api.deleteFavoriteProduct),
          body: {
            "favorite_user_id":
                currentOnlineUser.user.user_id_phoneNumber.toString(),
            "favorite_product_id": productInfo.product_id.toString(),
          },
        );

        if (res.statusCode == 200) {
          var resBodyOfdeleteFavoriteProduct = jsonDecode(res.body);
          if (resBodyOfdeleteFavoriteProduct['success'] == true) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Product deleted from favorite list',
              confirmBtnColor: Colors.orangeAccent,
            );
            validateFavoriteProductList();
          } else {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Oops...',
              text: "Error, Product not deleted from your Favorite List.",
              confirmBtnColor: Colors.orangeAccent,
            );
          }
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            text: "Error, Status is not 200",
            confirmBtnColor: Colors.orangeAccent,
          );
        }
      } catch (errorMsg) {
        print("Error :: " + errorMsg.toString());
      }
    }
    /* add favorite product end*/

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
                        fontFamily: "Poppins",
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
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.37,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0),
                itemCount: dataSnapShot.data!.length,
                itemBuilder: (context, index) {
                  Products eachProductsRecord = dataSnapShot.data![index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          ProductDetailVer2(productInfo: eachProductsRecord));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Card(
                          child: Container(
                            color: Colors.white,
                            width: 165,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 170,
                                  width: 250,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(eachProductsRecord
                                          .product_mainImage!),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "\I\D\R\. " +
                                                NumberFormat.currency(
                                                  locale: 'id_ID',
                                                  symbol: '',
                                                  decimalDigits: 0,
                                                ).format(eachProductsRecord
                                                    .product_price),
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: Colors.deepOrange.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        eachProductsRecord.product_name!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        eachProductsRecord.product_description!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w100),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                        fontFamily: "Poppins",
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "No data product",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "Poppins",
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

    controller.onInit();
    validateFavoriteProductList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildImage(),
              ),
              backgroundColor:
                  innerBoxIsScrolled ? Colors.white : Colors.transparent,
              elevation: innerBoxIsScrolled ? 4 : 0,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: innerBoxIsScrolled
                        ? Colors.transparent
                        : Color.fromARGB(50, 0, 0, 0),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: innerBoxIsScrolled ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
              actions: [
                Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: innerBoxIsScrolled
                          ? Colors.transparent
                          : Color.fromARGB(50, 0, 0, 0),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Obx(() => IconButton(
                          onPressed: () async {
                            if (productDetailController.isFavorite == true) {
                              deleteFavoriteProduct();
                            } else {
                              addFavoriteProduct();
                            }
                          },
                          icon: Icon(
                            productDetailController.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: productDetailController.isFavorite
                                ? Colors.red
                                : innerBoxIsScrolled
                                    ? Colors.black
                                    : Colors.white,
                            size: 18,
                          ),
                        ))),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          ];
        },
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(13, 13, 13, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\I\D\R\. " +
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: '',
                                  decimalDigits: 0,
                                ).format(productInfo.product_price),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 18,
                              color: Colors.deepOrange.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${productInfo.product_name}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              _buildQty(),
                            ],
                          ),
                          SizedBox(height: 5),
                          Column(
                            children: [
                              Row(
                                children: [
                                  _buildColor(),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Description: ",
                            style:
                                TextStyle(fontFamily: "Poppins", fontSize: 14),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            '${productInfo.product_description}',
                            textAlign: TextAlign.justify,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
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
                            otherProducts(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 55,
            child: ElevatedButton(
              onPressed: addProductToBag,
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
                          fontFamily: "Poppins"),
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
          ),
        ),
      ),
    );
  }

  Widget _buildColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Choose color :",
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontFamily: "Poppins"),
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
                              fontSize: 12,
                              color: Colors.black,
                              fontFamily: "Poppins"),
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
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //-
            IconButton(
              onPressed: () {
                if (productDetailController.quantity - 1 >= 1) {
                  productDetailController
                      .setQuantityProduct(productDetailController.quantity - 1);
                } else {
                  Get.snackbar(
                    "Error",
                    "Quantity product must be equal or greater than 1",
                    backgroundColor: Colors.grey.shade100,
                  );
                }
              },
              icon: const Icon(
                Icons.remove,
                color: Colors.black,
                size: 18,
              ),
            ),

            Text(
              productDetailController.quantity.toString(),
              style: const TextStyle(
                  fontSize: 16, color: Colors.black, fontFamily: "Poppins"),
            ),

            //+
            IconButton(
              onPressed: () {
                productDetailController
                    .setQuantityProduct(productDetailController.quantity + 1);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
