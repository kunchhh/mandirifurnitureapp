import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:http/http.dart' as http;

import '../../../../model/products.dart';
import '../../../widgets/Shimmer.dart';
import '../../productDetail/views/product_detail_view.dart';

class BedScreen extends StatefulWidget {
  const BedScreen({super.key});

  @override
  State<BedScreen> createState() => _BedScreenState();
}

class _BedScreenState extends State<BedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Bed category",
          style:
                TextStyle(fontWeight: FontWeight.w400, fontFamily: "Poppins"),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: 690),
          margin: EdgeInsets.only(top: 5),
          color: Colors.white,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [otherProducts(context)],
            ),
          ),
        ),
      ),
    );
  }

  /* List product Bed categories */
  Future<List<Products>> bedCategories() async {
    List<Products> allBedCategories = [];

    try {
      var res = await http.post(Uri.parse(api.bed));

      if (res.statusCode == 200) {
        var responseBodyOfBedCategories = jsonDecode(res.body);
        if (responseBodyOfBedCategories["success"] == true) {
          (responseBodyOfBedCategories["productsData"] as List)
              .forEach((eachRecord) {
            allBedCategories.add(Products.fromJson(eachRecord));
          });
        }
      } else {
        Get.snackbar("Error", "status is not 200",
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return allBedCategories;
  }
  /* List product Bed categoriest end */

  /* Widget otherProducts*/
  Widget otherProducts(context) {
    return FutureBuilder(
      future: bedCategories(),
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
                      fontFamily: "Poppins"
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
                    "Ooooppppssss!",
                     style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Poppins"
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Empty, no data product",
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
