import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/catalog/views/catalog_view.dart';

import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Living room',
          style: TextStyle(
            color: Color(0xFF212121),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        /* Search form */
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide.none),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        /* Search Form End */
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'categories',
                style: TextStyle(
                  color: Color(0xFF212121),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /* Categories list */
              Container(
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/content-categories/furniture.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  title: Text(
                    'Furniture',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => CatalogView());
                  },
                ),
              ),
              Container(
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/content-categories/lighting.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  title: Text(
                    'Lighting',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => CatalogView());
                  },
                ),
              ),

               Container(
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/content-categories/rugs.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  title: Text(
                    'Rugs',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => CatalogView());
                  },
                ),
              ),
              
               Container(
                child: ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/content-categories/mirror.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(width: 1, color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  title: Text(
                    'Mirror',
                    style: TextStyle(
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => CatalogView());
                  },
                ),
              ),
            
            ],
          ),
        ),
      ),

      /* Navbar */
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.home_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_outline_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.person_2_outlined,
                      color: Colors.white,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
          )),
      /* Navbar end */
    );
  }
}
