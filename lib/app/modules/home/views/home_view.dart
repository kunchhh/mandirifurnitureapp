import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/bag/views/bag_view.dart';
import 'package:mandirifurnitureapp/app/modules/myAccount/views/my_account_view.dart';
import 'package:mandirifurnitureapp/app/widgets/Shimmer.dart';
import '../../../../model/products.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../widgets/btnLike.dart';
import '../../productDetail/views/product_detail_view.dart';
import '../controllers/home_controller.dart';
import 'package:http/http.dart' as http;

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CurrentUser currentUser = Get.put(CurrentUser());

    TextEditingController searchController = TextEditingController();

    /* void _performSearch() {
    Get.to(() => SearchItems(typedKeyWords : searchController.text));
    FocusScope.of(context).unfocus();
  } */

    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          currentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.grey.shade100,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                "-MANDIRI FURNITURE-",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
             automaticallyImplyLeading: false
            ),
            body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Welcome 👋\n${currentUser.user.user_fullName}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            /* Search box */
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(3),
                                child: TextField(
                                  controller: searchController,
                                  onSubmitted: (value) {
                                    /* _performSearch(); */
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon: IconButton(
                                        onPressed: () {
                                          /* Get.to(() => SearchItems(typedKeyWords : searchController.text)); */
                                        },
                                        icon: Icon(
                                          Icons.search_rounded,
                                          color: Colors.grey.shade600,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: Colors.orangeAccent),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.only(top: 10),
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                  ),
                                ),
                              ),
                            ),
                            /* Search box end */
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    // ListView Horizontal (Newest product)
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 13, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Newest",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "See all",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orangeAccent),
                                ))
                          ],
                        ),
                      ),
                    ),
                    allNewestProducts(context),
                    // listview horizontal (Newest product) end

                    SizedBox(
                      height: 10,
                    ),

                    /* List category  */
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 13, right: 10, top: 10),
                        child: Text(
                          "Categories",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chair,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.light,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.table_bar,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.desk,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chair_alt,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.chair,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.light,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.orangeAccent),
                                height: 50,
                                width: 50,
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.table_bar,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    /* List category  */

                    SizedBox(
                      height: 20,
                    ),

                    /* Listview vertical (other product)*/
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 13, right: 10, bottom: 10),
                        child: Text(
                          "Other product",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                    otherProducts(context),
                    /* Listview vertical (other product) end */

                    SizedBox(height: 10),
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
                            color: Colors.black,
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
                            color: Colors.white,
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

  /* Widget newestProduct*/
  Widget allNewestProducts(context) {
    return FutureBuilder(
        future: newestProduct(),
        builder: (context, AsyncSnapshot<List<Products>> dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                ShimmerHorizontal(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                ShimmerHorizontal(),
                SizedBox(
                  width: 10,
                ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "No product found!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ));
          }
          if (dataSnapShot.data!.length > 0) {
            return SizedBox(
              height: 325,
              child: ListView.builder(
                  itemCount: dataSnapShot.data!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Products eachProductsRecord = dataSnapShot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailView(productInfo: eachProductsRecord));
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
                                    height: 0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                color:
                                                    Colors.deepOrange.shade900,
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
                                          eachProductsRecord
                                              .product_description!,
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
                      ),
                    );
                  }),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Connection problem!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
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
            ));
          }
        });
  }
  /* Widget newestProduct end*/

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
              SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
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
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: MediaQuery.of(context).size.height * 0.38,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10
              ),
              itemCount: dataSnapShot.data!.length,
              itemBuilder: (context, index) {
                Products eachProductsRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailView(productInfo: eachProductsRecord,));
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
