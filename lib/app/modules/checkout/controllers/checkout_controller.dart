import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../model/courierModel.dart';

class CheckoutController extends GetxController {
  //TODO: Implement CheckoutController

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }


  void increment() => count.value++;

  @override
  void onInit() {
    beratC = TextEditingController(text: "$berat");
    super.onInit();
  }
  

  @override
  void onClose() {
    beratC.dispose();
    super.onClose();
  }

  TextEditingController provinceEditingController = TextEditingController();
  TextEditingController cityEditingController = TextEditingController();
  TextEditingController courierEditingController = TextEditingController();
 
  
  var hiddenKotaAsal = true.obs;
  var provAsalId = 0.obs;
  var kotaAsalId = 0.obs;
  var hiddenKotaTujuan = true.obs;
  var provTujuanId = 0.obs;
  var kotaTujuanId = 0.obs;
  var hiddenButton = true.obs;
  var kurir = "".obs;
  RxString streetAddress = "".obs;
  RxString zipCode = "".obs;

  
  var selectedService = Rx<String>("");
  var selectedPrice = Rx<int>(0);  
  var selectedETD = RxString("");  

  
  int harga = 99;
  double berat = 0.0;
  String satuan = "gram";


  late TextEditingController beratC;
  
  

  void ongkosKirim() async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    try {
      final response = await http.post(
        url,
        body: {
          "origin": "78", // kabupaten bogor id 78
          "destination": "$kotaTujuanId",
          "weight": "10000", // 10 kg
          "courier": "$kurir", // yg di ganti sebelah sini
        },
        headers: {
          "key": "47c4e7a8d1395130b4dde82ac9b68258",
          "content-type": "application/x-www-form-urlencoded",
        },
      );

      var data = json.decode(response.body) as Map<String, dynamic>;
      var results = data["rajaongkir"]["results"] as List<dynamic>;

      var listAllCourier = Courier.fromJsonList(results);
      var courier = listAllCourier[0];

      Get.defaultDialog(
      title: courier.name!,
      content: Obx(() => Column(
        children: courier.costs!
            .map(
              (e) => RadioListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${e.service}"),
                    Text(
                      courier.code == "pos" ? "${e.cost![0].etd} " : "${e.cost![0].etd} Day",
                    ),
                  ],
                ),
                subtitle: Text("Rp ${e.cost![0].value!}"),
                groupValue: selectedService.value,
                onChanged: (value) {
                  selectedService.value = value.toString();
                  if (courier.costs!.isNotEmpty) {
                    selectedPrice.value = e.cost![0].value!; 
                    selectedETD.value = courier.code == "pos"
                        ? "${e.cost![0].etd}" 
                        : "${e.cost![0].etd} Day";
                  } else {
                    selectedPrice.value = 0; 
                    selectedETD.value = "";  
                  }
                  update(); 
                },
                value: e.service,
              ),
            )
            .toList(),
      )),
    );
      
      
    } catch (err) {
      print(err);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: err.toString(),
      );
    }
  }


  void showButton() {
    if (kotaTujuanId != 0 && kurir != "") {
      hiddenButton.value = false;
    } else {
      hiddenButton.value = true;
    }
  }


   void updateStreetAddress(String value) {
    streetAddress.value = value;
  }

  void updateZipCode(String value) {
    zipCode.value = value;
  }
}

