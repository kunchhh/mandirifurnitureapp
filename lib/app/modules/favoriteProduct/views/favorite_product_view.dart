import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/api/apiConnection.dart';
import '../../../../model/favoriteProduct.dart';
import '../../../../model/products.dart';
import '../../../../usePreferences/currentUser.dart';
import '../../../widgets/Shimmer.dart';
import '../../bag/views/bag_view.dart';
import '../../home/views/home_view.dart';
import '../../myAccount/views/my_account_view.dart';
import '../../productDetail/views/product_detail_view.dart';
import '../controllers/favorite_product_controller.dart';
import 'package:http/http.dart' as http;

class FavoriteProductView extends GetView<FavoriteProductController> {
  const FavoriteProductView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final currentOnlineUser = Get.put(CurrentUser());

    Future<List<Favorite>> getCurrentUserFavoriteList() async {
      List<Favorite> favoriteListOfCurrentUser = [];

      try {
        var res = await http.post(Uri.parse(api.readFavoriteProduct), body: {
          "favorite_user_id":
              currentOnlineUser.user.user_id_phoneNumber.toString(),
        });

        if (res.statusCode == 200) {
          var responseBodyOfCurrentUserFavoriteListItems = jsonDecode(res.body);

          if (responseBodyOfCurrentUserFavoriteListItems['success'] == true) {
            (responseBodyOfCurrentUserFavoriteListItems[
                    'currentUserFavoriteData'] as List)
                .forEach((eachCurrentUserFavoriteItemData) {
              favoriteListOfCurrentUser
                  .add(Favorite.fromJson(eachCurrentUserFavoriteItemData));
            });
          }
        } else {
          Get.snackbar("Error", "Status Code is not 200",
              backgroundColor: Colors.black, colorText: Colors.white);
        }
      } catch (errorMsg) {
        print("Error:: " + errorMsg.toString());
      }

      return favoriteListOfCurrentUser;
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          ' Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: getCurrentUserFavoriteList(),
            builder: (context, AsyncSnapshot<List<Favorite>> dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Row(
                  children: [
                    SizedBox(width: 10),
                    ShimmerHorizontal(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    ShimmerHorizontal(),
                    SizedBox(width: 10),
                  ],
                );
              }
              if (dataSnapShot.data == null) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/content/dissatisfied.png",
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "No product found!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (dataSnapShot.data!.length > 0) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10,),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent:
                            MediaQuery.of(context).size.height * 0.38,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10),
                    itemCount: dataSnapShot.data!.length,
                    itemBuilder: (context, index) {
                      Favorite eachFavoriteProductRecord =
                          dataSnapShot.data![index];

                      Products productsModel = Products(
                        product_id:
                            eachFavoriteProductRecord.favorite_product_id,
                        product_name: eachFavoriteProductRecord.product_name,
                        product_category:
                            eachFavoriteProductRecord.product_category,
                        product_color: eachFavoriteProductRecord.product_color,
                        product_price: eachFavoriteProductRecord.product_price,
                        product_description:
                            eachFavoriteProductRecord.product_description,
                        product_mainImage:
                            eachFavoriteProductRecord.product_mainImage,
                        product_Image1:
                            eachFavoriteProductRecord.product_Image1,
                        product_Image2:
                            eachFavoriteProductRecord.product_Image2,
                      );

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ProductDetailView(
                                productInfo: productsModel,
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Card(
                            child: Container(
                              color: Colors.white,
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          eachFavoriteProductRecord
                                              .product_mainImage!,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\I\D\R\. ${eachFavoriteProductRecord.product_price}",
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    Colors.deepOrange.shade900,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          eachFavoriteProductRecord
                                              .product_name!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                        ),
                                        Text(
                                          eachFavoriteProductRecord
                                              .product_description!,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 100),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/content/surprised.png",
                          width: 120.0,
                          height: 120.0,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Connection problem!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "No data product",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      /* Navbar */
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(80, 80),
                  topRight: Radius.elliptical(80, 80),
                  bottomLeft: Radius.elliptical(80, 80),
                  bottomRight: Radius.elliptical(80, 80),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 40,
                  right: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.to(() => HomeView());
                      },
                      icon: Icon(
                        Icons.home_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => BagView());
                      },
                      icon: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => FavoriteProductView());
                      },
                      icon: Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => MyAccountView());
                      },
                      icon: Icon(
                        Icons.person_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
      /* Navbar end */
    );
  }
}
