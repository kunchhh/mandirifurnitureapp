import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/widgets/btnLike.dart';

import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    Get.lazyPut(()=>ProductDetailController());

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
              Center(
                child: Container(
                  width: 400,
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      height: 450,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image:
                                  AssetImage('assets/content/product-4.png'))),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "\I\D\R\. 150.000",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.deepOrange.shade900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
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
                              GestureDetector(
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text(
                      'You might also like',
                      style: TextStyle(
                        color: Color(0xFF212121),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 0.06,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),


                    Wrap(
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                  child: Container(
                                color: Colors.white,
                                height: 270,
                                width: 165,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 170,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  'assets/content/product-4.png')),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\I\D\R\. 150.000",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors
                                                        .deepOrange.shade900,
                                                  ),
                                                ),
                                                btnLike()
                                              ],
                                            ),
                                            Text(
                                              "Wooden ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Bedside table",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
                            )),
                        GestureDetector(
                            onTap: () {},
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Card(
                                  child: Container(
                                color: Colors.white,
                                height: 270,
                                width: 165,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        height: 170,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  'assets/content/product-2.png')),
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\I\D\R\. 150.000",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors
                                                        .deepOrange.shade900,
                                                  ),
                                                ),
                                                btnLike()
                                              ],
                                            ),
                                            Text(
                                              "Wooden ",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "Bedside table",
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
                            )),
                      ]
                    ),
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
                  if (controller.isSelected.value) {
                    Get.snackbar(
                      "Success",
                      "Produk telah ditambahkan ke tas belanja",
                      backgroundColor: Colors.grey.shade100,
                    );
                  } else {
                    Get.snackbar(
                      "Error",
                      "Pilih warna sebelum menambahkan ke tas belanja",
                      backgroundColor: Colors.grey.shade100,
                    );
                  }
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
                        "Add to Cart",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
