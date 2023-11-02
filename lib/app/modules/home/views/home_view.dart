import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/modules/home/views/list_item.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150.0,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 13.0),
                        child: Text(
                          "Home",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
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
              SizedBox(
                height: 20.0,
              ),
              // ListView Horizontal
              Container(
                height: 110.0, // Sesuaikan tinggi ListView
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    // Container(
                    //   width: 100.0,
                    //   margin: EdgeInsets.all(5.0),
                    //   child: Stack(
                    //     children: [
                    //       ClipRRect(
                    //         borderRadius: BorderRadius.circular(15.0),
                    //         child: Image.asset(
                    //           'assets/content/best.png',
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //       Center(
                    //         child: Text(
                    //           'Teks di Dalam Gambar',
                    //           style: TextStyle(
                    //             color: Colors
                    //                 .white, // Sesuaikan warna teks sesuai kebutuhan
                    //             fontSize:
                    //                 12.0, // Sesuaikan ukuran teks sesuai kebutuhan
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

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
                                10.0, // Sesuaikan posisi teks sesuai kebutuhan
                            left: 7.0, // Sesuaikan posisi teks sesuai kebutuhan
                            child: Text(
                              'Kitchen',
                              style: TextStyle(
                                  color: Colors
                                      .white, // Ganti warna teks sesuai kebutuhan
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                  // Sesuaikan ukuran teks sesuai kebutuhan
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
                          text: 'Bedroom',
                          imagePath: 'assets/content/bedroomcat.png',
                        );
                      case 1:
                        return CustomListItem(
                          text: 'Bathroom',
                          imagePath: 'assets/content/bathroomcat.png',
                        );
                      case 2:
                        return CustomListItem(
                          text: 'Kitchen',
                          imagePath: 'assets/content/kitchencat.png',
                        );
                      case 3:
                        return CustomListItem(
                          text: 'Living Room',
                          imagePath: 'assets/content/livingroomcat.png',
                        );
                      case 4:
                        return CustomListItem(
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
                      Icons.home_outlined,
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
    );
  }
}
