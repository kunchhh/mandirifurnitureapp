import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/bag/views/bag_view.dart';
import 'package:mandirifurnitureapp/app/modules/catalog/views/catalog_view.dart';
import 'package:mandirifurnitureapp/app/modules/categories/views/categories_view.dart';
import 'package:mandirifurnitureapp/app/modules/home/views/list_item.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Home",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),),
        centerTitle: true,
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
              Text("Welcome 👋\nKuncoro Adin Nugraha", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
              SizedBox(height: 20,),
              // ListView Horizontal
              Container(
                height: 110.0, 
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      margin: EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              'assets/content/summertime.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom:
                                10.0, 
                            left: 7.0,
                            child: Text(
                              'Kitchen',
                              style: TextStyle(
                                  color: Colors
                                      .white, 
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                  
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: 100.0,
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/content/kitchen.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          'assets/content/goldenhour.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // +Tambahkan konten
                  ],
                ),
              ),

              // listview horizontal end


              SizedBox(
                height: 20.0,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Category',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 300.0,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    // CustomListItem
                    switch (index) {
                      case 0:
                        return CustomListItem(
                          onTap: () {
                            Get.to(() => CategoriesView());
                          },
                          text: 'Bedroom',
                          imagePath: 'assets/content/bedroomcat.png',
                        );
                      case 1:
                        return CustomListItem(
                           onTap: () {
                            Get.to(() => CategoriesView());
                          },
                          text: 'Bathroom',
                          imagePath: 'assets/content/bathroomcat.png',
                        );
                      case 2:
                        return CustomListItem(
                           onTap: () {
                            Get.to(() => CategoriesView());
                          },
                          text: 'Kitchen',
                          imagePath: 'assets/content/kitchencat.png',
                        );
                      case 3:
                        return CustomListItem(
                           onTap: () {
                            Get.to(() => CategoriesView());
                          },
                          text: 'Living Room',
                          imagePath: 'assets/content/livingroomcat.png',
                        );
                      case 4:
                        return CustomListItem(
                           onTap: () {
                            Get.to(() => CategoriesView());
                          },
                          text: 'Dining Room',
                          imagePath: 'assets/content/diningroomcat.png',
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
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
                    onPressed: () {
                      Get.to(() => HomeView());
                    },
                    icon: Icon(
                      Icons.home_rounded,
                      color: Colors.black,
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
