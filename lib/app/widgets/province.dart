import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mandirifurnitureapp/app/modules/checkout/controllers/checkout_controller.dart';

import '../../model/provinceModel.dart';

class Provinsi extends GetView<CheckoutController> {
  Provinsi(
      {Key? key,
      required this.tipe,
      required this.controllerProvince,
      required this.onSaved,
      required this.validator})
      : super(key: key);

  final TextEditingController controllerProvince;
  final dynamic onSaved;
  final String tipe;
  final dynamic validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        searchBoxController: controllerProvince,
        label: tipe == "asal" ? "Provinsi Asal" : "Province",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");

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

            var listAllProvince =
                data["rajaongkir"]["results"] as List<dynamic>;

            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (err) {
            print(err);
            return List<Province>.empty();
          }
        },
        onChanged: (Province? prov) {
          if (prov != null) {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = false;
              controller.provAsalId.value = int.parse(prov.provinceId!);
              controller.provinceEditingController.text = prov.province ?? "";
            } else {
              controller.hiddenKotaTujuan.value = false;
              controller.provTujuanId.value = int.parse(prov.provinceId!);
              controller.provinceEditingController.text = prov.province ?? "";
            }
          } else {
            if (tipe == "asal") {
              controller.hiddenKotaAsal.value = true;
              controller.provAsalId.value = 0;
              controller.provinceEditingController.clear();
            } else {
              controller.hiddenKotaTujuan.value = true;
              controller.provTujuanId.value = 0;
              controller.provinceEditingController.clear();
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
          hintText: "search province...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        popupItemBuilder:
            (BuildContext context, Province? item, bool isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item?.province ?? ""}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (Province? item) => item?.province ?? "",
      ),
    );
  }
}
