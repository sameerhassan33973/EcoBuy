import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/models/products.dart';
import 'package:eco_buy/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../utils/styles.dart';
import '../../widgets/homecategoryblocks.dart';
import '../product_detail.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getdata();
    // TODO: implement initState
    super.initState();
  }

  // const HomePage({Key? key}) : super(key: key);
  List images = [
    "https://cdn.pixabay.com/photo/2016/03/02/20/13/grocery-1232944__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/21/57/apparel-1850804__340.jpg",
    "https://cdn.pixabay.com/photo/2016/03/02/20/13/grocery-1232944__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/19/08/hangers-1850082__340.jpg",
    "https://cdn.pixabay.com/photo/2016/11/22/21/57/apparel-1850804__340.jpg",
  ];

  List<Products> allproducts = [];

  getdata() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs.forEach((e) {
        if (e.exists) {
          setState(() {
            allproducts.add(Products(
              id: e["id"],
              category: e["category"],
              name: e["name"],
              detail: e["detail"],
              price: e["price"],
              discount: e["discount"],
              serialcode: e["serialcode"],
              imageurls: e["imageurls"],
              isonsale: e["isonsale"],
              ispopular: e["ispopular"],
            ));
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseServices.logout();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "SH",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: "MART",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold)),
                  ])),
                ),
                HomeCategoryBlocks(),
                CarouselSlider(
                    items: images
                        .map((e) => Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Container(
                                      height: 20.h,
                                      width: 150.w,
                                      child: Image.network(
                                        e,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Container(
                                    height: 20.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(colors: [
                                          Colors.blueAccent.withOpacity(0.2),
                                          Colors.redAccent.withOpacity(0.2)
                                        ])),
                                  ),
                                ),
                                // Positioned(
                                //   bottom: 6.h,
                                //   left: 6.w,
                                //   child: Container(
                                //       decoration: BoxDecoration(
                                //           color: Colors.black.withOpacity(0.5)),
                                //       child: Padding(
                                //         padding: EdgeInsets.all(2.h),
                                //         child: Text("TITLE",
                                //             style: TextStyle(
                                //                 fontSize: 18,
                                //                 color: Colors.white)),
                                //       )),
                                // ),
                              ],
                            ))
                        .toList(),
                    options: CarouselOptions(
                      height: 200,
                      autoPlay: true,
                    )),
                Text(
                  "Popular Items",
                  style: EcoStyle.boldStyle.copyWith(fontSize: 18.sp),
                ),
                PopularItems(allproducts: allproducts),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.h),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.deepOrange),
                          child: Center(
                            child: Text(
                              "Hot \n Sales",
                              style: EcoStyle.boldStyle.copyWith(
                                  fontSize: 22.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(2.h),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.deepPurple),
                          child: Center(
                            child: Text(
                              "New \n Arrival",
                              style: EcoStyle.boldStyle.copyWith(
                                  fontSize: 22.sp, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                // HomeCards(title: "Garments"),
              ],
            ),
          ),
        ));
  }
}

class PopularItems extends StatelessWidget {
  const PopularItems({
    Key? key,
    required this.allproducts,
  }) : super(key: key);

  final List<Products> allproducts;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: allproducts
            .where((element) => element.ispopular == true)
            .map((e) => Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        ProductDetailPage(id: e.id!))));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                e.imageurls![0],
                                fit: BoxFit.fill,
                                height: 80,
                                width: 80,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
