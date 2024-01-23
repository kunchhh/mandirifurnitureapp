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

import '../../../widgets/Shimmer_v2.dart';

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
      height: MediaQuery.of(context).size.height * 0.715,
      child: FutureBuilder(
        future: getHistoryOrder(),
        builder: (context, AsyncSnapshot<List<Order>> dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerV2(),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerV2(),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerV2(),
                  ],
                ),
              ),
            );
          }

          if (dataSnapshot.data == null) {
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
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ));
          }

          if (dataSnapshot.data!.length > 0) {
            List<Order> orderList = dataSnapshot.data!;

            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 5,
                  thickness: 5,
                  color: Colors.transparent,
                );
              },
              itemCount: orderList.length,
              itemBuilder: (context, index) {
                Order eachOrderData = orderList[index];

                return Container(
                  color: Colors.white,
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Done",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 110),
                                    Text(
                                      "See detail",
                                      style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontFamily: "Poppins",
                                          fontSize: 14),
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
                        color: Colors.white,
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
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Total Amount: ",
                                  style: const TextStyle(
                                      fontSize: 12, fontFamily: "Poppins"),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "\I\D\R\. " +
                                      NumberFormat.currency(
                                        locale: 'id_ID',
                                        symbol: '',
                                        decimalDigits: 0,
                                      ).format(eachOrderData.totalAmount),
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 191, 54, 12),
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Poppins"),
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
                    "Oooopppsssss!",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Empty, lets buy something",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: "Poppins",
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "- MANDIRI FURNITURE -",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => MyOrdersView());
          },
        ),
      ),
      body: Column(children: [
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 3,),
        
        Expanded(
          child: displayOrderHistoryList(context),
        ),
      ]),
    );
  }
}
