import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/model/products.dart';

import 'package:http/http.dart' as http;

import '../../../widgets/Shimmer.dart';
import '../../productDetail/views/product_detail_view.dart';

class SearchAllScreen extends StatefulWidget {
  final String? typedKeyWords;
  const SearchAllScreen({this.typedKeyWords});

  @override
  State<SearchAllScreen> createState() => _SearchAllScreenState();
}

class _SearchAllScreenState extends State<SearchAllScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.text = widget.typedKeyWords!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: showSearchBarWidget(),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(minHeight: 690),
            margin: EdgeInsets.only(top: 5),
            color: Colors.white,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  searchController.text.isEmpty
                      ? otherProducts(context)
                      : searchProductCard(context)
                ],
              ),
            ),
          ),
        ));
  }

  Widget showSearchBarWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 18, bottom: 5, left: 18),
      child: TextField(
        style: const TextStyle(color: Colors.black),
        controller: searchController,
        onSubmitted: (value) {
          _performSearch();
        },
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade600,
            ),
          ),
          hintText: "Search...",
          hintStyle: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
          ),
          suffixIcon: IconButton(
              onPressed: () {
                searchController.clear();
                setState(() {});
              },
              icon: Icon(
                Icons.close,
                color: Colors.grey.shade600,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.orangeAccent),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          contentPadding: EdgeInsets.only(top: 10),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  // function api readSearchAllProduct form searchbox
  Future<List<Products>> readSearchAllProduct() async {
    List<Products> productsSearchList = [];

    if (searchController.text != "") {
      try {
        var res = await http.post(Uri.parse(api.searchAllProduct), body: {
          "typedKeyWords": searchController.text,
        });

        if (res.statusCode == 200) {
          var responseBodyOfSearchItems = jsonDecode(res.body);

          if (responseBodyOfSearchItems['success'] == true) {
            (responseBodyOfSearchItems['productsFoundData'] as List)
                .forEach((eachItemData) {
              productsSearchList.add(Products.fromJson(eachItemData));
            });
          }
        } else {
          print("Status Code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }
    }

    return productsSearchList;
  }

  void _performSearch() {
    readSearchAllProduct();
    FocusScope.of(context).unfocus();
  }

  // card product
  searchProductCard(context) {
    return FutureBuilder(
      future: readSearchAllProduct(),
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
              margin: EdgeInsets.only(top: 200),
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
                        fontSize: 18,
                        fontFamily: "Poppins"),
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
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.37,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: dataSnapShot.data!.length,
              itemBuilder: (context, index) {
                Products eachProductsRecord = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailView(
                          productInfo: eachProductsRecord,
                        ));
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
                              height: 180,
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
                            SizedBox(height: 10),
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
                                          fontSize: 16,
                                          color: Colors.deepOrange.shade900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    eachProductsRecord.product_name!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 1,
                                  ),
                                  Text(
                                    eachProductsRecord.product_description!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
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
                );
              },
            ),
          );
        } else {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 200),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/content/dissatisfied.png",
                    width: 120.0,
                    height: 120.0,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "nothing found, try\nsomething else",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontFamily: "Poppins"),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  // function api readSearchAllProduct form searchbox-end

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
              margin: EdgeInsets.only(top: 200),
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
                        fontSize: 18,
                        fontFamily: "Poppins"),
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
                  mainAxisExtent: MediaQuery.of(context).size.height * 0.35,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 0),
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
                                  image: NetworkImage(
                                      eachProductsRecord.product_mainImage!),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
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
                );
              },
            ),
          );
        } else {
          return Center(
            child: Container(
              margin: EdgeInsets.only(top: 200),
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
                      fontFamily: "Poppins",
                      fontSize: 18,
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
}
