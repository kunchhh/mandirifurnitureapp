import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mandirifurnitureapp/app/modules/checkout/controllers/checkout_controller.dart';

import '../../model/cityModel.dart';

class Kota extends GetView<CheckoutController> {
  Kota(
      {Key? key,
      required this.provId,
      required this.tipe,
      required this.controllerCity,
      required this.onSaved,
      required this.validator})
      : super(key: key);

  final int provId;
  final String tipe;
  final TextEditingController controllerCity;
  final dynamic onSaved;
  final dynamic validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        searchBoxController: controllerCity,
        label: tipe == "asal" ? "Kota / Kabupaten Asal" : "City / District",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse(
              "https://api.rajaongkir.com/starter/city?province=$provId");

          try {
            final response = await http.get(
              url,
              headers: {
                "key": "0ae702200724a396a933fa0ca4171a7e",
              },
            );

            var data = json.decode(response.body) as Map<String, dynamic>;

            var statusCode = data["rajaongkir"]["status"]["code"];

            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }

            var listAllCity = data["rajaongkir"]["results"] as List<dynamic>;

            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            print(err);
            return List<City>.empty();
          }
        },
        onChanged: (City? cityValue) {
          if (cityValue != null) {
            if (tipe == "asal") {
              controller.kotaAsalId.value = int.parse(cityValue.cityId!);
              controller.cityEditingController.text = "${cityValue.type ?? ''} ${cityValue.cityName ?? ''}";
            } else {
              controller.kotaTujuanId.value = int.parse(cityValue.cityId!);
              controller.cityEditingController.text = "${cityValue.type ?? ''} ${cityValue.cityName ?? ''}";

            }
          } else {
            if (tipe == "asal") {
              print("Tidak memilih kota / kabupaten asal apapun");
              controller.kotaAsalId.value = 0;
              controller.cityEditingController.clear();
            } else {
              print("Tidak memilih kota / kabupaten tujuan apapun");
              controller.kotaTujuanId.value = 0;
              controller.cityEditingController.clear();
            }
          }
          controller.showButton();
        },
        validator: validator,
        onSaved: onSaved,
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: "search city / district ...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (BuildContext context, City? item, bool isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item?.type ?? ''} ${item?.cityName ?? ''}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (City? item) =>
            "${item?.type ?? ''} ${item?.cityName ?? ''}",
      ),
    );
  }
}
