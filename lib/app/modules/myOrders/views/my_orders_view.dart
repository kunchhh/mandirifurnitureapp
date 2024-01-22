import 'dart:convert';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/myAccount/views/my_account_view.dart';
import 'package:mandirifurnitureapp/app/modules/myOrders/views/detail_order_onProcess.dart';
import 'package:mandirifurnitureapp/app/modules/myOrders/views/history_order_screen.dart';
import '../../../../model/order.dart';
import '../../../../usePreferences/currentUser.dart';
import '../controllers/my_orders_controller.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentOnlineUser = Get.put(CurrentUser());
    final PageController _pageController = PageController();
    int _currentPageIndex = 0;

    // order on process
    Future<List<Order>> getCurrentUserOrdersList() async {
      List<Order> ordersListOfCurrentUser = [];

      try {
        var res = await http.post(Uri.parse(api.readOrder), body: {
          "currentOnlineUserID":
              currentOnlineUser.user.user_id_phoneNumber.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

          if (responseBodyOfCurrentUserOrdersList['success'] == true) {
            (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                    as List)
                .forEach((eachCurrentUserOrderData) {
              ordersListOfCurrentUser
                  .add(Order.fromJson(eachCurrentUserOrderData));
            });
          }
        } else {
          print("Status Code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }

      return ordersListOfCurrentUser;
    }

    // display order on process
    Widget displayOrdersList(context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder(
          future: getCurrentUserOrdersList(),
          builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Connection Waiting...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (dataSnapshot.data == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "No orders found yet...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (dataSnapshot.data!.length > 0) {
              List<Order> orderList = dataSnapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Order eachOrderData = orderList[index];

                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            Get.to(() => detailOrderOnProcessScreen(
                                  clickedOrderInfo: eachOrderData,
                                ));
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "On process",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade50,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 110),
                                      Text(
                                        "See detail",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade700,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              onTap: () {
                                Get.to(() => detailOrderOnProcessScreen(
                                      clickedOrderInfo: eachOrderData,
                                    ));
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order ID # " +
                                        eachOrderData.order_id.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Total Amount: ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "\I\D\R. " +
                                        eachOrderData.totalAmount!
                                            .toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 191, 54, 12),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //date
                                  //time
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //date
                                      Text(
                                        DateFormat("dd MMMM, yyyy")
                                            .format(eachOrderData.dateTime!),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      //time
                                      Text(
                                        DateFormat("hh:mm a")
                                            .format(eachOrderData.dateTime!),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Nothing to show...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
        ),
      );
    }

    // order in delivery
    Future<List<Order>> getOrderInDelivery() async {
      List<Order> ordersListOfCurrentUser = [];

      try {
        var res = await http.post(Uri.parse(api.readInDeliveryOrder), body: {
          "currentOnlineUserID":
              currentOnlineUser.user.user_id_phoneNumber.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

          if (responseBodyOfCurrentUserOrdersList['success'] == true) {
            (responseBodyOfCurrentUserOrdersList['currentUserOrdersData']
                    as List)
                .forEach((eachCurrentUserOrderData) {
              ordersListOfCurrentUser
                  .add(Order.fromJson(eachCurrentUserOrderData));
            });
          }
        } else {
          print("Status Code is not 200");
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }

      return ordersListOfCurrentUser;
    }

    // display order in delivery
    Widget displayOrderInDelivery(context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7, // Set a fixed height
        child: FutureBuilder(
          future: getOrderInDelivery(),
          builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Connection Waiting...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (dataSnapshot.data == null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "No orders found yet...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            if (dataSnapshot.data!.length > 0) {
              List<Order> orderList = dataSnapshot.data!;

              return ListView.separated(
                padding: const EdgeInsets.all(5),
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 1,
                    thickness: 1,
                  );
                },
                itemCount: orderList.length,
                itemBuilder: (context, index) {
                  Order eachOrderData = orderList[index];

                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            Get.to(() => detailOrderOnProcessScreen(
                            clickedOrderInfo: eachOrderData,
                          ));
                          },
                          title: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "In delivery",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade50,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 110),
                                     
                                      Text(
                                        "See detail",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey.shade700,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              onTap: () {
                                Get.to(() => detailOrderOnProcessScreen(
                                clickedOrderInfo: eachOrderData,
                              ));
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order ID # " +
                                        eachOrderData.order_id.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "Total Amount: ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "\I\D\R. " +
                                        eachOrderData.totalAmount!
                                            .toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 191, 54, 12),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //date
                                  //time
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //date
                                      Text(
                                        DateFormat("dd MMMM, yyyy")
                                            .format(eachOrderData.dateTime!),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      //time
                                      Text(
                                        DateFormat("hh:mm a")
                                            .format(eachOrderData.dateTime!),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Nothing to show...",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('-MANDIRI FURNITURE-'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => MyAccountView());
          },
        ),
      ),
      body: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () {
                      Get.to(() => HistoryOrderScreen());
                    },
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag,
                          color: Colors.orangeAccent,
                          size: 20,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "My orders",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                "See orders history",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade700,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            0,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.card_giftcard_rounded,
                                color: _currentPageIndex == 0
                                    ? Colors.yellow.shade700
                                    : Colors.grey.shade700,
                                size: 28,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'On Process',
                                style: TextStyle(
                                  color: _currentPageIndex == 0
                                      ? Colors.yellow.shade700
                                      : Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "   _______   ",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.local_shipping,
                                color: _currentPageIndex == 1
                                    ? Colors.yellow.shade700
                                    : Colors.grey.shade700,
                                size: 28,
                              ),
                              SizedBox(height: 0),
                              Text(
                                'In Delivery',
                                style: TextStyle(
                                  color: _currentPageIndex == 1
                                      ? Colors.yellow.shade700
                                      : Colors.grey.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                ExpandablePageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  children: [
                    // Page 1: On Process
                    Container(
                        color: Colors.white,
                        width: double.infinity,
                        child: Expanded(child: displayOrdersList(context))),
                    // Page 2: In Delivery
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Expanded(
                        child: displayOrderInDelivery(context),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
