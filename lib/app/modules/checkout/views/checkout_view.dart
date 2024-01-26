import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import 'package:mandirifurnitureapp/app/widgets/successScreen.dart';

import '../../../../usePreferences/currentUser.dart';
import '../../../widgets/city.dart';
import '../../../widgets/province.dart';
import '../controllers/checkout_controller.dart';
import 'package:http/http.dart' as http;

class CheckoutView extends GetView<CheckoutController> {
  final List<int>? selectedBagIDs;
  final List<Map<String, dynamic>>? selectedProductListInfo;
  final double? subtotalProduct;
  


  const CheckoutView({
    Key? key,
    this.selectedBagIDs,
    this.selectedProductListInfo,
    this.subtotalProduct,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CurrentUser _currentUser = Get.put(CurrentUser());
    Get.lazyPut(() => CheckoutController());

    final _formKey = GlobalKey<FormState>();
    var streetAddressEditingController = TextEditingController();
    var zipCodeAddressEditingController = TextEditingController();

    int activeStep = 0;
    double progress = 0.2;

    double costApp = 1000;

    final PageController _pageController =
        PageController(initialPage: activeStep);

    // function next
    void next() {
      if (activeStep < 2) {
        activeStep++;
        _pageController.animateToPage(activeStep,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      } else if (activeStep == 2) {
        print('Done button pressed');
      }
    }

    // function back
    void back() {
      if (activeStep > 0) {
        activeStep--;
        _pageController.animateToPage(activeStep,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    }

    // delete list product from bag if done to payment
    deleteSelectedProductsFromUserBagList(int bagID) async {
      try {
        var res = await http.post(Uri.parse(api.deleteProductInTheBag), body: {
          "bag_id": bagID.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyFromDeleteCart = jsonDecode(res.body);

          if (responseBodyFromDeleteCart["success"] == true) {
            Get.to(() => successScreen(
            ));
          }
        } else {
          /* Fluttertoast.showToast(msg: "Error, Status Code is not 200"); */
        }
      } catch (errorMessage) {
        print("Error: " + errorMessage.toString());
      }
    }

    // add order info to database
    saveNewOrderInfo() async {
      String selectedProductsString = selectedProductListInfo!
          .map((eachSelectedProduct) => jsonEncode(eachSelectedProduct))
          .toList()
          .join("||");
      try {
        var res = await http.post(Uri.parse(api.addNewOrder), body: {
          'user_id_phoneNumber': _currentUser.user.user_id_phoneNumber,
          'user_fullName': _currentUser.user.user_fullName,
          'order_selectedProducts': selectedProductsString,
          'order_deliverySystem': controller.kurir.value.toString(),
          'order_costProduct': subtotalProduct.toString(),
          'order_costDeliverySystem':controller.selectedPrice.value.toString(),
          'order_costApp': costApp.toString(),
          'order_totalAmount':
              (subtotalProduct! + controller.selectedPrice.value + costApp).toString(),
          'order_status': "new",
          'user_province': controller.provinceEditingController.text.toString(),
          'user_city': controller.cityEditingController.text.toString(),
          'user_street_address':
              streetAddressEditingController.text.trim().toString(),
          'user_zipcode':
              zipCodeAddressEditingController.text.trim().toString(),
          'dateTime': DateTime.now().toString(),
        });

        print("Respons Simpan Pesanan: ${res.body}");

        if (res.statusCode == 200) {
          var responseBodyOfAddNewOrder = jsonDecode(res.body);

          if (responseBodyOfAddNewOrder["success"] == true) {
            selectedBagIDs!.forEach((eachSelectedProductBagID) {
              deleteSelectedProductsFromUserBagList(eachSelectedProductBagID);
            });
          } else {
            print(
                "Error:: Pesanan baru Anda tidak berhasil ditempatkan. Pesan: ${responseBodyOfAddNewOrder['message'] ?? 'Tidak ada pesan kesalahan'}");
          }
        } else {
          print(
              "Error:: Kode Status bukan 200. Kode Status: ${res.statusCode}");
        }
      } catch (error) {
        print("Error: $error");
      }
    }

    // Payment method
    Map<String, dynamic>? paymentIntentData;

    Future<void> displayPaymentSheet() async {
      try {
        await Stripe.instance.presentPaymentSheet();
        if (selectedProductListInfo!.length > 0) {
          await Future.delayed(Duration(seconds: 2));
          saveNewOrderInfo();
        } else {
          print("Please choose a delivery system.");
        }
      } on Exception catch (e) {
        if (e is StripeException) {
          print("Error from Stripe: ${e.error.localizedMessage}");
        } else {
          print("Unforeseen error: ${e}");
        }
      } catch (e) {
        print("exception: $e");
      }
    }

    calculateAmount(String amount) {
      final a = (int.parse(amount)) * 100;
      return a.toString();
    }

    createPaymentIntent(String amount, String currency) async {
      try {
        Map<String, dynamic> body = {
          'amount': calculateAmount(amount),
          'currency': currency,
          'payment_method_types[]': 'card'
        };
        var response = await http.post(
            Uri.parse('https://api.stripe.com/v1/payment_intents'),
            body: body,
            headers: {
              'Authorization':
                  'Bearer sk_test_51OZCcEFN8Hx9mwWIwEIR33HCzKEJIN4njby3oHcCWGDodhmB6LvqZLkvwqxEA5qDXak5CyhgdINAD8mfX9TldW3d009ntGCO1T',
              'Content-Type': 'application/x-www-form-urlencoded'
            });
        return jsonDecode(response.body);
      } catch (err) {
        print('err charging user: ${err.toString()}');
      }
    }

    Future<void> makePayment(
        {required String amount, required String currency}) async {
      try {
        paymentIntentData = await createPaymentIntent(amount, currency);
        if (paymentIntentData != null) {
          await Stripe.instance
              .initPaymentSheet(
                  paymentSheetParameters: SetupPaymentSheetParameters(
                merchantDisplayName: 'Bisnis Baru',
                paymentIntentClientSecret: paymentIntentData!['client_secret'],
              ))
              .then((value) {});
          displayPaymentSheet();
        }
      } catch (e, s) {
        print('exception:$e$s');
      }
    }
    // payment method-end

    // SelectedProduct from bag
    displaySelectedProductsFromUserBag() {
      return Column(
        children: List.generate(selectedProductListInfo?.length ?? 0, (index) {
          Map<String, dynamic> eachSelectedProduct =
              selectedProductListInfo![index];

          return Container(
            child: Row(
              children: [
                // image
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Card(
                      color: Colors.white,
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
                                    image: NetworkImage(eachSelectedProduct[
                                        "product_mainImage"]),
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
                                      eachSelectedProduct["product_name"],
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
                                              eachSelectedProduct["bag_color"]
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
                                              eachSelectedProduct[
                                                      "bag_quantity"]
                                                  .toString(),
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
                                              ).format(eachSelectedProduct[
                                                  "totalAmount"]),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              color:
                                                  Colors.deepOrange.shade900),
                                        ),
                                        Text(
                                          eachSelectedProduct["bag_quantity"]
                                                  .toString() +
                                              " x " +
                                              NumberFormat.currency(
                                                      locale: 'id_ID',
                                                      symbol: '',
                                                      decimalDigits: 0)
                                                  .format(eachSelectedProduct[
                                                      "product_price"]),
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

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  //easy stepper
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: EasyStepper(
                        activeStep: activeStep,
                        lineStyle: LineStyle(
                          lineLength: 150,
                          lineThickness: 2,
                          lineSpace: 2,
                          lineType: LineType.normal,
                          defaultLineColor: Colors.grey.shade700,
                          progress: progress,
                        ),
                        activeStepBorderColor: Colors.orange,
                        activeStepIconColor: Colors.orange,
                        activeStepTextColor: Colors.orange,
                        finishedStepBackgroundColor: Colors.orange,
                        showLoadingAnimation: false,
                        showTitle: true,
                        borderThickness: 3,
                        internalPadding: 15,
                        steps: [
                          EasyStep(
                            icon: Icon(CupertinoIcons.location_solid),
                            title: 'Address',
                          ),
                          EasyStep(
                            icon: Icon(CupertinoIcons.creditcard),
                            title: 'Payment',
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  ExpandablePageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        activeStep = index;
                      });
                    },
                    children: [
                      // Step 1 (Address)
                      Container(
                        width: double.infinity,
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            constraints: BoxConstraints(minHeight: 505),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Step: 1 of 2 (Shipment address)",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w200,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Provinsi(
                                    tipe: "tujuan",
                                    controllerProvince:
                                        controller.provinceEditingController,
                                    onSaved: (value) {
                                      controller.provinceEditingController
                                          .text = value!;
                                    },
                                    validator: (value) => value == null
                                        ? "Please required your province"
                                        : null),
                                Obx(
                                  () => controller.hiddenKotaTujuan.isTrue
                                      ? SizedBox()
                                      : Kota(
                                          provId: controller.provTujuanId.value,
                                          tipe: "tujuan",
                                          controllerCity:
                                              controller.cityEditingController,
                                          onSaved: (value) {
                                            controller.cityEditingController
                                                .text = value!;
                                          },
                                          validator: (value) => value == null
                                              ? "Please required your city"
                                              : null),
                                ),
                                TextFormField(
                                  controller: streetAddressEditingController,
                                  decoration: InputDecoration(
                                    labelText: "Street address",
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: null,
                                  minLines: 3,
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) => value == ""
                                      ? "Please fill your street address"
                                      : null,
                                  onSaved: (value) {
                                    streetAddressEditingController.text =
                                        value!;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: zipCodeAddressEditingController,
                                  decoration: InputDecoration(
                                    labelText: "Zip Code",
                                    prefixIcon: Icon(
                                      Icons.location_on,
                                      color: Colors.black,
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) => value == ""
                                      ? "Please fill your Zip Code"
                                      : null,
                                  onSaved: (value) {
                                    zipCodeAddressEditingController.text =
                                        value!;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            next();
                                          }
                                        },
                                        child: Text(
                                          'Next',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.orange,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          minimumSize: Size(100, 35),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Step 2 (Payment)
                      Container(
                        constraints: BoxConstraints(minHeight: 505),
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "Step 2 of 2 (Payment)",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w200,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            Container(
                                color: Colors.white,
                                width: double.infinity,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                  child: displaySelectedProductsFromUserBag(),
                                )),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                child: Column(
                                  children: [
                                    DropdownSearch<Map<String, dynamic>>(
                                      searchBoxController:
                                          controller.courierEditingController,
                                      mode: Mode.MENU,
                                      showClearButton: true,
                                      items: [
                                        {
                                          "code": "jne",
                                          "name":
                                              "Jalur Nugraha Ekakurir (JNE)",
                                        },
                                        {
                                          "code": "tiki",
                                          "name": "Titipan Kilat (TIKI)",
                                        },
                                        {
                                          "code": "pos",
                                          "name":
                                              "Perusahaan Opsional Surat (POS)",
                                        },
                                      ],
                                      label: "Delivery system",
                                      hint: "Choose delivery system",
                                      onChanged: (Map<String, dynamic>? value) {
                                        if (value != null) {
                                          controller.kurir.value =
                                              value["code"];
                                          controller.ongkosKirim();
                                        } else {
                                          controller.hiddenButton.value = true;
                                          controller.kurir.value = "";

                                          controller.selectedService.value = "";
                                          controller.selectedPrice.value = 0;
                                          controller.selectedETD.value = "";
                                        }
                                      },
                                      onSaved: (value) {
                                        controller.courierEditingController
                                            .text = value.toString();
                                      },
                                      validator: (value) => value == null
                                          ? "Please fill courier"
                                          : null,
                                      itemAsString:
                                          (Map<String, dynamic>? item) =>
                                              "${item?['name'] ?? ''}",
                                      popupItemBuilder: (BuildContext context,
                                          Map<String, dynamic>? item,
                                          bool isSelected) {
                                        return Container(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                            "${item?['name'] ?? ''}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Obx(
                                      () => controller
                                              .selectedService.value.isNotEmpty
                                          ? Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 7, 15, 7),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Service: ",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                    Text(
                                                      "${controller.kurir.value} - ${controller.selectedService.value}",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Colors.grey),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Price:",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                    Obx(
                                                      () => Text("\I\D\R. " +
                                                        NumberFormat.currency(
                                                          locale: 'id_ID',
                                                          symbol: '',
                                                          decimalDigits: 0,
                                                        ).format(controller
                                                            .selectedPrice
                                                            .value),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontFamily: "Poppins",
                                                          fontWeight:
                                                              FontWeight.w100,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Estimated:",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily:
                                                              "Poppins"),
                                                    ),
                                                    Obx(() => Text(
                                                          controller.selectedETD
                                                              .value,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w100,
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 7, 15, 7),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Subtotal product",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: '',
                                            decimalDigits: 0,
                                          ).format(subtotalProduct),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Subtotal shipment",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Obx(() => Text(
                                              NumberFormat.currency(
                                                locale: 'id_ID',
                                                symbol: '',
                                                decimalDigits: 0,
                                              ).format(controller
                                                  .selectedPrice.value),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            )),
                                      ],
                                    ),
                                     Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Cost app",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'id_ID',
                                            symbol: '',
                                            decimalDigits: 0,
                                          ).format(costApp),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Total :",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Obx(() => Text("\I\D\R. " +
                                              NumberFormat.currency(
                                                locale: 'id_ID',
                                                symbol: '',
                                                decimalDigits: 0,
                                              ).format(subtotalProduct! + controller.selectedPrice.value + costApp),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.deepOrange.shade900,
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: back,
                                          child: Text(
                                            'Back',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.grey.shade300,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            minimumSize: Size(100, 35),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              makePayment(
                                                  amount: (subtotalProduct! + controller.selectedPrice.value + costApp)
                                                      .toStringAsFixed(0),
                                                  currency: 'IDR');
                                            }
                                          },
                                          child: Text(
                                            'Pay',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.orange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            minimumSize: Size(100, 35),
                                          ),
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
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
