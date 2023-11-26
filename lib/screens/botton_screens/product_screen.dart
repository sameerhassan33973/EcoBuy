import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/product_detail.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:eco_buy/widgets/ecotextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../../models/products.dart';

class ProductPage extends StatefulWidget {
  String? category;
  ProductPage({Key? key, this.category}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  void initState() {
    getdata();
    Future.delayed(Duration(seconds: 1), () {
      totalItems.addAll(allproducts);
    });
    // TODO: implement initState
    super.initState();
  }

  List<Products> searchitems = [];
  List<Products> allproducts = [];
  TextEditingController search = TextEditingController();
  getdata() {
    var a = FirebaseFirestore.instance.collection("products").get();
    print(a);
    if (widget.category == null) {
      FirebaseFirestore.instance
          .collection("products")
          .get()
          .then((QuerySnapshot? snapshot) {
        snapshot!.docs.forEach((e) {
          if (e.exists) {
            setState(() {
              allproducts.add(Products(
                name: e["name"],
                imageurls: e["imageurls"],
                id: e["id"],
              ));
            });
          }
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection("products")
          .get()
          .then((QuerySnapshot? snapshot) {
        snapshot!.docs
            .where((element) => element["category"] == widget.category)
            .forEach((e) {
          if (e.exists) {
            setState(() {
              allproducts.add(Products(
                name: e["name"],
                id: e["id"],
                imageurls: e["imageurls"],
              ));
            });
          }
        });
      });
    }
  }

  List<Products> totalItems = [];
  filterData(String query) {
    List<Products> dummySearch = [];
    dummySearch.addAll(allproducts);
    if (query.isNotEmpty) {
      List<Products> dummyData = [];
      dummySearch.forEach((element) {
        if (element.name!.toLowerCase().contains(query.toLowerCase())) {
          dummyData.add(element);
        }
      });
      setState(() {
        allproducts.clear();
        allproducts.addAll(dummyData);
      });
      return;
    } else {
      setState(() {
        allproducts.clear();

        allproducts.addAll(totalItems);
      });
      // return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: widget.category == null
                ? Text("ALL PRODUCTS")
                : Text(widget.category!)),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(2.h),
              child: TextFormField(
                controller: search,
                onChanged: (v) {
                  filterData(v);
                },
                decoration: InputDecoration(
                    hintText: "Search", border: OutlineInputBorder()),
              ),
            ),
            Expanded(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: allproducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => ProductDetailPage(
                                    id: allproducts[index].id!))));
                      },
                      child: Container(
                        height: 32.h,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Container(
                                    height: 15.h,
                                    width: 32.w,
                                    child: Image.network(
                                      allproducts[index].imageurls![0],
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(1.h),
                                  child: Container(
                                    height: 15.h,
                                    width: 32.w,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(colors: [
                                          Colors.blueAccent.withOpacity(0.1),
                                          Colors.redAccent.withOpacity(0.1)
                                        ])),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(1.h),
                                child: Expanded(
                                    child: Text(
                                  allproducts[index].name!,
                                  style: EcoStyle.boldStyle
                                      .copyWith(fontSize: 14.sp),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
