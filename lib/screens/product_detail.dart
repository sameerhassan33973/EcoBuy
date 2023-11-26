import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../models/cart.dart';
import '../models/products.dart';
import '../widgets/ecobutton.dart';
import '../widgets/header.dart';

class ProductDetailPage extends StatefulWidget {
  final String id;
  const ProductDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  List<Products> allProducts = [];
  int count = 1;
  var newPrice = 0;
  bool isLoading = false;
  List<Products> allproducts = [];
  getData() {
    FirebaseFirestore.instance
        .collection("products")
        .get()
        .then((QuerySnapshot? snapshot) {
      snapshot!.docs
          .where((element) => element["id"] == widget.id)
          .forEach((e) {
        if (e.exists) {
          print(e["imageurls"]);
          for (var item in e["imageurls"]) {
            if (item.isNotEmpty) {
              setState(() {
                allProducts.add(
                  Products(
                      id: e["id"],
                      detail: e["detail"],
                      name: e["name"],
                      imageurls: e["imageurls"],
                      price: e['price'],
                      discount: e['discount']),
                );
              });
            }
          }
        }
      });
    });
  }

  addToFavrourite() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('favourite');
    await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .add({"pid": allProducts.first.id});
  }

  removeToFavrourite(String id) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('favourite');
    await collectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .doc(id)
        .delete();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool isfvrt = false;

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return allProducts.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                child: Header(
                  title: "${allProducts.first.name}",
                ),
                preferredSize: Size.fromHeight(7.h)),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    allProducts[0].imageurls![selectedIndex],
                    height: 30.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...List.generate(
                          allProducts[0].imageurls!.length,
                          (index) => InkWell(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 12.h,
                                width: 12.w,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Image.network(
                                  allProducts[0].imageurls![index],
                                  height: 9.h,
                                  width: 9.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 7.h,
                      width: 35.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text("${allProducts.first.price} PKR",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('favourite')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('items')
                          .where('pid', isEqualTo: allProducts.first.id)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Text("");
                        }
                        return IconButton(
                            onPressed: () {
                              snapshot.data!.docs.length == 0
                                  ? addToFavrourite()
                                  : removeToFavrourite(
                                      snapshot.data!.docs.first.id);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: snapshot.data!.docs.length == 0
                                  ? Colors.black
                                  : Colors.red,
                            ));
                      }),
                  Container(
                    constraints: BoxConstraints(
                      minWidth: double.infinity,
                      minHeight: 30.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        allProducts.first.detail!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "NOTE :  Per Product will be charged ${allProducts.first.discount} PKR only  when you order more then three items of this product"),
                  ),
                  Container(
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (count > 1) {
                                count--;
                                if (count > 3) {
                                  newPrice =
                                      count * allProducts.first.discount!;
                                } else {
                                  newPrice = count * allProducts.first.price!;
                                }
                              }
                            });
                          },
                          icon: Icon(Icons.exposure_minus_1),
                        ),
                        Text(
                          "$count",
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              count++;
                              if (count > 3) {
                                newPrice = count * allProducts.first.discount!;
                              } else {
                                newPrice = count * allProducts.first.price!;
                              }
                            });
                          },
                          icon: Icon(Icons.exposure_plus_1),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 7.h,
                            width: 35.w,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: newPrice == 0
                                      ? Text("${allProducts.first.price} PKR",
                                          style: TextStyle(color: Colors.white))
                                      : Text("${newPrice} PKR",
                                          style:
                                              TextStyle(color: Colors.white))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  EcoButton(
                    isloading: isLoading,
                    onpress: () {
                      setState(() {
                        isLoading = true;
                      });
                      Cart.addtoCart(Cart(
                              id: allProducts.first.id,
                              image: allProducts.first.imageurls!.first,
                              name: allProducts.first.name,
                              quantity: count,
                              price: newPrice))
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Added to cart successfully")));
                        });
                      });
                    },
                    title: "Add to Cart",
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
          );
  }
}
