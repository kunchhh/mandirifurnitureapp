class Bag {
  int? bag_id;
  String? bag_product_id;
  String? bag_user_id;
  int? bag_quantity;
  String? bag_color;
  String? product_name;
  String? product_category;
  List<String>? product_color;
  int? product_price;
  String? product_description;
  String? product_mainImage;
  String? product_Image1;
  String? product_Image2;


  Bag ({
    this.bag_id,
    this.bag_user_id,
    this.bag_product_id,
    this.bag_quantity,
    this.bag_color,

    this.product_name,
    this.product_category,
    this.product_color,
    this.product_price,
    this.product_description,
    this.product_mainImage,
    this.product_Image1,
    this.product_Image2,
  });

  factory Bag.fromJson(Map<String, dynamic> json) => Bag(
    bag_id: int.parse(json['bag_id']),
    bag_user_id: json['bag_user_id'],
    bag_product_id: json['bag_product_id'],
    bag_quantity: int.parse(json['bag_quantity']),
    bag_color: json['bag_color'],

    product_name: json["product_name"],
    product_category: json["product_category"],
    product_color: json["product_color"].toString().split(", "),
    product_price: int.parse(json["product_price"]),
    product_description: json["product_description"],
    product_mainImage: json["product_mainImage"],  
    product_Image1: json["product_Image1"],  
    product_Image2: json["product_Image2"],  

  );
}