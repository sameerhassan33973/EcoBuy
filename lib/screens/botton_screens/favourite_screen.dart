import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/product_detail.dart';
import 'package:eco_buy/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List ids = [];

  getid() async {
    FirebaseFirestore.instance
        .collection("favourite")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("items")
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> value) {
      value.docs.forEach((element) {
        setState(() {
          ids.add(element["pid"]);
        });
      });
    });
    print(ids);
  }

  @override
  void initState() {
    // getid();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getid();
    return Scaffold(
      appBar: PreferredSize(
        child: Header(
          title: "Favourites",
        ),
        preferredSize: Size.fromHeight(7.h),
      ),
      body: Center(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("products").snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return Center(child: Text("No Favourite Items Found"));
                }
                List<QueryDocumentSnapshot<Object?>> fp = snapshot.data!.docs
                    .where((element) => ids.contains(element["id"]))
                    .toList();
                return ListView.builder(
                    itemCount: fp.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.all(2.h),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                        id: fp[index]["id"])));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.black,
                            child: ListTile(
                              title: Text(
                                fp[index]["name"],
                                style: TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.navigate_next_outlined),
                                onPressed: () {},
                              ),
                            ),
                          ),
                        ),
                      );
                    });
              })),
    );
  }
}
