class Favorite {
  int? favorite_id;
  String? favorite_user_id;
  String? favorite_product_id;
  String? product_name;
  String? product_category;
  List<String>? product_color;
  int? product_price;
  String? product_description;
  String? product_mainImage;
  String? product_Image1;
  String? product_Image2;

  Favorite(
      {this.favorite_id,
      this.favorite_user_id,
      this.favorite_product_id,
      this.product_name,
      this.product_category,
      this.product_color,
      this.product_price,
      this.product_description,
      this.product_mainImage,
      this.product_Image1,
      this.product_Image2});

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        favorite_id: int.parse(json['favorite_id']),
        favorite_user_id: json['favorite_user_id'],
        favorite_product_id: json['favorite_product_id'],
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
