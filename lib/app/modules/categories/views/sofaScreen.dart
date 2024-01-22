import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:http/http.dart' as http;

import '../../../../model/products.dart';
import '../../../widgets/Shimmer.dart';
import '../../productDetail/views/product_detail_view.dart';


class sofaScreen extends StatefulWidget {
  const sofaScreen({super.key});

  @override
  State<sofaScreen> createState() => _sofaScreenState();
}

class _sofaScreenState extends State<sofaScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Sofa category", style: TextStyle(fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            children: [
              otherProducts(context)
            ],
          ),
        ),
      ),
    );
  }

    /* List product sofa categories */
  Future<List<Products>> sofaCategories() async {
    List<Products> allSofaCategories = [];

    try {
      var res = await http.post(Uri.parse(api.sofa));

      if (res.statusCode == 200) {
        var responseBodyOfSofaCategories = jsonDecode(res.body);
        if (responseBodyOfSofaCategories["success"] == true) {
          (responseBodyOfSofaCategories["productsData"] as List)
              .forEach((eachRecord) {
            allSofaCategories.add(Products.fromJson(eachRecord));
          });
        }
      } else {
        Get.snackbar("Error", "status is not 200",
            backgroundColor: Colors.black, colorText: Colors.white);
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return allSofaCategories;
  }
  /* List product sofa categoriest end */

    /* Widget otherProducts*/
  Widget otherProducts(context) {
    return FutureBuilder(
      future: sofaCategories(),
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
                                        "\I\D\R\. ${eachProductsRecord.product_price}",
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
                    "nothing found, try\nsomething else",
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
      },
    );
  }
  /* Widget otherProducts end*/

}