import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/myAccount/views/my_account_view.dart';

import '../../home/views/home_view.dart';
import '../controllers/bag_controller.dart';

class BagView extends GetView<BagController> {
  const BagView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BagController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Bag',
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 32,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  height: 0.04,
                ),
              ),
              SizedBox(
                height: 10,
              ),

              /* List item  */
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Card(
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
              GestureDetector(
                onTap: () {},
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Card(
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
      /* Navbar */
      bottomNavigationBar: Container(
        height: 180,
        child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Column(
              children: [
                  Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "\I\D\R\. 150.000",
                        style: TextStyle(
                          color: Colors.deepOrange.shade900,
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                /* Button checkout */
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Container(
                    width: 343,
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Text(
                        'Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF212121),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                 SizedBox(
                  height: 10,
                ),
                /* Button Checkout end */
                Container(
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
                ),
              ],
            )),
      ),
      /* Navbar end */
    );
  }
}
