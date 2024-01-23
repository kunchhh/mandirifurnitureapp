class Order
{
  int? order_id;
  String? user_id_phoneNumber;
  String? user_fullName;
  String? selectedProducts;
  String? deliverySystem;
  double? costProduct;
  double? costDeliverySystem;
  double? costApp;
  double? totalAmount;
  String? status;
  String? user_province;
  String? user_city;
  String? user_street_address;
  String? user_zipcode;
  DateTime? dateTime;

  Order({
    this.order_id,
    this.user_id_phoneNumber,
    this.user_fullName,
    this.selectedProducts,
    this.deliverySystem,
    this.costProduct,
    this.costDeliverySystem,
    this.costApp,
    this.totalAmount,
    this.status,
    this.user_province,
    this.user_city,
    this.user_street_address,
    this.user_zipcode,
    this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'order_id': order_id.toString(),
        'user_id_phoneNumber':user_id_phoneNumber,
        'user_fullName': user_fullName,
        'order_selectedProducts': selectedProducts,
        'order_deliverySystem': deliverySystem,
        'order_costProduct': costProduct!.toStringAsFixed(0),
        'order_costDeliverySystem': costProduct!.toStringAsFixed(0),
        'order_costApp': costProduct!.toStringAsFixed(0),
        'order_totalAmount': totalAmount!.toStringAsFixed(0),
        'order_status': status,
        'user_province' : user_province,
        'user_city' : user_city,
        'user_street_address' : user_street_address,
        'user_zipcode': user_zipcode,
        'dateTime' : dateTime.toString(),
      };

    factory Order.fromJson(Map<String, dynamic> json) => Order(
    order_id: int.parse(json['order_id']) ,
   user_id_phoneNumber: json['user_id_phoneNumber'] ,
    user_fullName: json['user_fullName'] ,
    selectedProducts: json['order_selectedProducts'] ,
    deliverySystem: json['order_deliverySystem'] ,
    totalAmount: double.parse(json['order_totalAmount']),
    costProduct: double.parse(json['order_costProduct']),
    costDeliverySystem: double.parse(json['order_costDeliverySystem']),
    costApp: double.parse(json['order_costApp']),
    status: json['order_status'] ,
    user_province: json['user_province'] ,
    user_city: json['user_city'] ,
    user_street_address: json['user_street_address'] ,
    user_zipcode: json['user_zipcode'] ,
    dateTime: DateTime.parse(json['dateTime']),
  );
}
