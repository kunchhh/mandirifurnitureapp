import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/modules/myOrders/views/detail_order_onProcess.dart';
import 'package:mandirifurnitureapp/app/modules/myOrders/views/my_orders_view.dart';
import 'package:http/http.dart' as http;
import '../../../../model/order.dart';
import '../../../../usePreferences/currentUser.dart';
import 'package:intl/intl.dart';


class HistoryOrderScreen extends StatefulWidget {
  const HistoryOrderScreen({super.key});

  @override
  State<HistoryOrderScreen> createState() => _HistoryOrderScreenState();
}

class _HistoryOrderScreenState extends State<HistoryOrderScreen> {
  final currentOnlineUser = Get.put(CurrentUser());

  Future<List<Order>> getHistoryOrder() async {
    List<Order> ordersListOfCurrentUser = [];

    try {
      var res = await http.post(Uri.parse(api.readHistoryOrder), body: {
        "currentOnlineUserID":
            currentOnlineUser.user.user_id_phoneNumber.toString(),
      });

      if (res.statusCode == 200) {
        var responseBodyOfCurrentUserOrdersList = jsonDecode(res.body);

        if (responseBodyOfCurrentUserOrdersList['success'] == true) {
          (responseBodyOfCurrentUserOrdersList['currentUserOrdersData'] as List)
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

  Widget displayOrderHistoryList(context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: FutureBuilder(
          future: getHistoryOrder(),
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
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Success",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('-MANDIRI FURNITURE-'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.to(() => MyOrdersView());
          },
        ),
      ),
      body:  Column(children: [
          Container(
            color: Colors.grey[100],
            height: 3,
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 15, right: 15),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shopping_bag,
                    color: Colors.orangeAccent,
                    size: 20,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "History Orders",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
                ],
              ),
            ),
          ),
          Container(
            color: Colors.grey[100],
            height: 3,
          ),
           Expanded(
            child: displayOrderHistoryList(context),
          ),
        ]),
      
    );
  }
}
