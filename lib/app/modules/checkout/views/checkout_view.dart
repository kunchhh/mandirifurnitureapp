import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import 'package:get/get.dart';
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
  final double? totalAmount;

  const CheckoutView({
    Key? key,
    this.selectedBagIDs,
    this.selectedProductListInfo,
    this.totalAmount,
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
           
            Get.to(() => successScreen());
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
          'order_totalAmount':
              (totalAmount! + controller.selectedPrice.value).toString(),
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
                      child: Container(
                        color: Colors.grey.shade100,
                        height: 130,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // image
                            Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      eachSelectedProduct["product_mainImage"]),
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
                                      style: TextStyle(fontSize: 17),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
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
                                              fontSize: 14),
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
                                              fontSize: 14),
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
                                              eachSelectedProduct["totalAmount"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                              color:
                                                  Colors.deepOrange.shade900),
                                        ),
                                        Text(
                                          eachSelectedProduct["bag_quantity"]
                                                  .toString() +
                                              " x " +
                                              eachSelectedProduct[
                                                      "product_price"]
                                                  .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey.shade700,
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  EasyStepper(
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Provinsi(
                                  tipe: "tujuan",
                                  controllerProvince:
                                      controller.provinceEditingController,
                                  onSaved: (value) {
                                    controller.provinceEditingController.text =
                                        value!;
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
                                  streetAddressEditingController.text = value!;
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
                                  zipCodeAddressEditingController.text = value!;
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
                                        if (_formKey.currentState!.validate()) {
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

                      // Step 2 (Payment)
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Column(
                            children: [
                              displaySelectedProductsFromUserBag(),
                              SizedBox(
                                height: 10,
                              ),
                              DropdownSearch<Map<String, dynamic>>(
                                searchBoxController:
                                    controller.courierEditingController,
                                mode: Mode.MENU,
                                showClearButton: true,
                                items: [
                                  {
                                    "code": "jne",
                                    "name": "Jalur Nugraha Ekakurir (JNE)",
                                  },
                                  {
                                    "code": "tiki",
                                    "name": "Titipan Kilat (TIKI)",
                                  },
                                  {
                                    "code": "pos",
                                    "name": "Perusahaan Opsional Surat (POS)",
                                  },
                                ],
                                label: "Tipe Kurir",
                                hint: "pilih tipe kurir...",
                                onChanged: (Map<String, dynamic>? value) {
                                  if (value != null) {
                                    controller.kurir.value = value["code"];
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
                                  controller.courierEditingController.text =
                                      value.toString();
                                },
                                validator: (value) => value == null
                                    ? "Please fill courier"
                                    : null,
                                itemAsString: (Map<String, dynamic>? item) =>
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
                                                color: Colors.grey, width: 1.0),
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Selected Service:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                controller
                                                    .selectedService.value,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                "Price:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Obx(() => Text(
                                                    "Total: ${controller.selectedPrice.value}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )),
                                              SizedBox(height: 8),
                                              Text(
                                                "Estimated Delivery Time:",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Obx(() => Text(
                                                    controller
                                                        .selectedETD.value,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
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
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          totalAmount!.toStringAsFixed(0),
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        )
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
                                            fontSize: 14,
                                          ),
                                        ),
                                        Obx(() => Text(
                                              controller.selectedPrice.value
                                                  .toString(),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 14,
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
                                          "Total :",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Obx(() => Text(
                                              "\I\D\R\. " +
                                                  (totalAmount! +
                                                          controller
                                                              .selectedPrice
                                                              .value)
                                                      .toStringAsFixed(0),
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    Colors.deepOrange.shade900,
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
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
                                        if (_formKey.currentState!.validate()) {
                                          makePayment(
                                              amount: (totalAmount! +
                                                      controller
                                                          .selectedPrice.value)
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
                              ),
                            ],
                          ),
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
