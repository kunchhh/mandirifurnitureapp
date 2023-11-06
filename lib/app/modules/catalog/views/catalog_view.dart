import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mandirifurnitureapp/app/widgets/btnLike.dart';

import '../../productDetail/views/product_detail_view.dart';
import '../controllers/catalog_controller.dart';

class CatalogView extends GetView<CatalogController> {
  const CatalogView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('CatalogView' , style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back, color: Colors.black,)),

        /* Search form */
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: Padding(padding: EdgeInsets.only(left: 20 ,right: 20, top: 10, bottom: 10),
          child:  Container(
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
      ),

      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              GestureDetector(
                  onTap: ()
                  {
                   Get.to(() => ProductDetailView());
                  },
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(30),
                    child: Card(
                    child: Container(
                    color: Colors.white,
                    height: 270,
                    width: 165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 170,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/content/product-4.png')),
                          ),
                        ),
                        SizedBox(height: 0,),
                          Container(
                            
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("\I\D\R\. 150.000" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange.shade900,),),
                                    btnLike()
                                  ],
                                ),
                                Text("Wooden ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                Text("Bedside table", style: TextStyle( fontSize: 16,),),
                              ],
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                )
              ),

              GestureDetector(
                  onTap: ()
                  {
                    
                  },
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(30),
                    child: Card(
                    child: Container(
                    color: Colors.white,
                    height: 270,
                    width: 165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 170,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/content/product-2.png')),
                          ),
                        ),
                        SizedBox(height: 0,),
                          Container(
                            
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("\I\D\R\. 150.000" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange.shade900,),),
                                    btnLike()
                                  ],
                                ),
                                Text("Wooden ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                Text("Bedside table", style: TextStyle( fontSize: 16,),),
                              ],
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                )
              ),

              GestureDetector(
                  onTap: ()
                  {
                    
                  },
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(30),
                    child: Card(
                    child: Container(
                    color: Colors.white,
                    height: 270,
                    width: 165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 170,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/content/product-3.png')),
                          ),
                        ),
                        SizedBox(height: 0,),
                          Container(
                            
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("\I\D\R\. 150.000" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange.shade900,),),
                                    btnLike()
                                  ],
                                ),
                                Text("Wooden ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                Text("Bedside table", style: TextStyle( fontSize: 16,),),
                              ],
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                )
              ),

              GestureDetector(
                  onTap: ()
                  {
                    
                  },
                  child: ClipRRect(
                    borderRadius:  BorderRadius.circular(30),
                    child: Card(
                    child: Container(
                    color: Colors.white,
                    height: 270,
                    width: 165,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 170,
                          width: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/content/product-chair1.png')),
                          ),
                        ),
                        SizedBox(height: 0,),
                          Container(
                            
                            padding: EdgeInsets.only(left: 10, right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("\I\D\R\. 150.000" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange.shade900,),),
                                    btnLike()
                                  ],
                                ),
                                Text("Wooden ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),),
                                Text("Bedside table", style: TextStyle( fontSize: 16,),),
                              ],
                            ),
                          ),
                        ]
                      ),
                    )
                  ),
                )
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
    );
  }
}
