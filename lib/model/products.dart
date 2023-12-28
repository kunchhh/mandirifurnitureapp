class Products {
  String? product_id;
  String? product_name;
  String? product_category;
  List<String>? product_color;
  int? product_price;
  String? product_description;
  String? product_mainImage;
  String?product_Image1;
  String? product_Image2;

  Products({
    this.product_id,
    this.product_name,
    this.product_category,
    this.product_color,
    this.product_price,
    this.product_description,
    this.product_mainImage,
    this.product_Image1,
    this.product_Image2
  });

  Products.copy(Products other) {
    product_id = other.product_id;
    product_name = other.product_name;
    product_category = other.product_category;
    product_color = List<String>.from(other.product_color ?? []);
    product_price = other.product_price;
    product_description = other.product_description;
    product_mainImage = other.product_mainImage;
    product_Image1 = other.product_Image1;
    product_Image2 = other.product_Image2;
  }

  factory Products.fromJson(Map<String, dynamic> json) => Products(
        product_id: json["product_id"],
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