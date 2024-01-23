import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:http/http.dart' as http;
import 'package:mandirifurnitureapp/app/modules/myOrders/views/history_order_screen.dart';
import '../../../../model/order.dart';
import 'package:intl/intl.dart';

class detailOrderOnProcessScreen extends StatefulWidget {
  final Order? clickedOrderInfo;

  const detailOrderOnProcessScreen({
    super.key,
    this.clickedOrderInfo,
  });

  @override
  State<detailOrderOnProcessScreen> createState() =>
      _detailOrderOnProcessScreenState();
}

class _detailOrderOnProcessScreenState
    extends State<detailOrderOnProcessScreen> {
  RxString _status = "In Delivery".obs;
  String get status => _status.value;

  updateParcelStatusForUI(String parcelReceived) {
    _status.value = parcelReceived;
  }

  showDialogForParcelConfirmation() async {
    if (widget.clickedOrderInfo!.status == "In Delivery") {
      var response = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Confirmation",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: const Text(
            "Have you received your parcel?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back(result: "yesConfirmed");
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      );

      if (response == "yesConfirmed") {
        updateStatusValueInDatabase();
      }
    }
  }

  updateStatusValueInDatabase() async {
    try {
      var response = await http.post(Uri.parse(api.updateStatusOrder), body: {
        "order_id": widget.clickedOrderInfo!.order_id.toString(),
      });

      if (response.statusCode == 200) {
        var responseBodyOfUpdateStatus = jsonDecode(response.body);

        if (responseBodyOfUpdateStatus["success"] == true) {
          updateParcelStatusForUI("arrived");
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    updateParcelStatusForUI(widget.clickedOrderInfo!.status.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Detail order",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w400),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            if (status == 'In Delivery') {
              Get.back();
            } else if (status == 'new') {
              Get.back();
            } else {
              Get.to(() => HistoryOrderScreen());
            }
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 8, 16, 8),
            child: Material(
              color: Colors.white30,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      Obx(
                        () => status == "In Delivery"
                            ? Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.yellow.shade700,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Received",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.help_outline,
                                      color: Colors.redAccent,
                                      size: 16,
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: status == "new"
                                      ? Colors.yellow.shade700
                                      : Colors.green.shade500,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      status == "new"
                                          ? "On Process"
                                          : "Received",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      status == "new"
                                          ? Icons.timer
                                          : Icons.check_circle_outline,
                                      color: status == "new"
                                          ? Colors.redAccent
                                          : Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 3,
              color: Colors.grey.shade100,
            ),
            // info purchase
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Purchase date",
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontFamily: "Poppins",
                          fontSize: 12),
                    ),
                    Text(
                      DateFormat("dd MMMM yyyy - hh:mm a")
                          .format(widget.clickedOrderInfo!.dateTime!),
                      style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                    )
                  ],
                ),
              ),
            ),

            Container(
              height: 3,
              color: Colors.grey.shade100,
            ),
            // info product
            displayOrderProduct(),
            Container(
              height: 3,
              color: Colors.grey.shade100,
            ),

            // shipping information
            Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shipping Information",
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Courier",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Poppins",
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 90,
                      ),
                      Text(
                        widget.clickedOrderInfo!.deliverySystem!.toUpperCase(),
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Shipment Address",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Poppins",
                            fontSize: 12),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.clickedOrderInfo!.user_fullName!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Poppins",
                                  fontSize: 12),
                            ),
                            Text(
                              widget.clickedOrderInfo!.user_id_phoneNumber!,
                              style: TextStyle(
                                  fontFamily: "Poppins", fontSize: 12),
                            ),
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  widget.clickedOrderInfo!
                                          .user_street_address! +
                                      ", " +
                                      widget.clickedOrderInfo!.user_city! +
                                      ", " +
                                      widget.clickedOrderInfo!.user_province! +
                                      ", " +
                                      widget.clickedOrderInfo!.user_zipcode!,
                                  style: TextStyle(
                                      fontFamily: "Poppins", fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              height: 3,
              color: Colors.grey.shade100,
            ),

            // payment details
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Payment Method",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: "Poppins",
                              fontSize: 12),
                        ),
                        Text(
                          "Debit/Credit Online (VISA)",
                          style: TextStyle(fontFamily: "Poppins", fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal product",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: "Poppins",
                              fontSize: 12),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(widget.clickedOrderInfo!.costProduct),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Subtotal Shipment",
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontFamily: "Poppins",
                              fontSize: 12),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(widget.clickedOrderInfo!.costDeliverySystem),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cost app",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontFamily: "Poppins",
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: '',
                            decimalDigits: 0,
                          ).format(widget.clickedOrderInfo!.costApp),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Amount",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 14),
                        ),
                        Text(
                          "\I\D\R\. " +
                              NumberFormat.currency(
                                locale: 'id_ID',
                                symbol: '',
                                decimalDigits: 0,
                              ).format(widget.clickedOrderInfo!.totalAmount),
                          style: TextStyle(
                              color: Colors.deepOrange.shade900,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Poppins",
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: status != "new",
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (status == "In Delivery") {
                      showDialogForParcelConfirmation();
                    } else {}
                  },
                  style: ElevatedButton.styleFrom(
                    primary: status == "Received (done)"
                          ? Colors.green
                          : Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    minimumSize: Size(325.0, 50.0),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Order received",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Poppins",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => status == "In Delivery"
                            ? Icon(Icons.help_outline, color: Colors.redAccent)
                            : Icon(Icons.check_circle_outline,
                                color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      /* Container(
        padding: EdgeInsets.only(right: 50, left: 60, top: 15),
        child: InkWell(
          onTap: () {
            if (status == "In Delivery") {
              showDialogForParcelConfirmation();
            } else {}
          },
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                SizedBox(width: 40),
                if (status != "new")
                  Text(
                    "Order received",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(width: 8),
                if (status != "new")
                  Obx(
                    () => status == "In Delivery"
                        ? Icon(Icons.help_outline, color: Colors.redAccent)
                        : Icon(Icons.check_circle_outline,
                            color: Colors.greenAccent),
                  ),
              ],
            ),
          ),
        ),
        height: status != "new" ? 70 : 0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: status == "new" ? Colors.yellow.shade700 : Colors.black,
          borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(400, 80),
              topRight: Radius.elliptical(400, 80)),
        ),
      ), */
    );
  }

  displayOrderProduct() {
    List<String> clickedOrderItemsInfo =
        widget.clickedOrderInfo!.selectedProducts!.split("||");

    return Column(
      children: List.generate(clickedOrderItemsInfo.length, (index) {
        Map<String, dynamic> itemInfo =
            jsonDecode(clickedOrderItemsInfo[index]);

        return Container(
          color: Colors.white,
          child: Row(
            children: [
              // image
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    child: Container(
                      color: Colors.white,
                      height: 130,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // image
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                            child: Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      itemInfo["product_mainImage"]),
                                ),
                              ),
                            ),
                          ),

                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(left: 15, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    itemInfo["product_name"],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Color: " +
                                            itemInfo["bag_color"]
                                                .replaceAll("[", "")
                                                .replaceAll("]", ""),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Text(
                                        "Qty: " +
                                            itemInfo["bag_quantity"].toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.grey.shade700,
                                          fontSize: 12,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
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
                                            ).format(itemInfo["totalAmount"]),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: "Poppins",
                                            color: Colors.deepOrange.shade900),
                                      ),
                                      Text(
                                        itemInfo["bag_quantity"].toString() +
                                            " x " +
                                            NumberFormat.currency(
                                                    locale: 'id_ID',
                                                    symbol: '',
                                                    decimalDigits: 0)
                                                .format(
                                                    itemInfo["product_price"]),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontFamily: "Poppins",
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
