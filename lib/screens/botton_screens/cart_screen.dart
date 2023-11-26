import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/botton_screens/checkout_screen.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:eco_buy/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/ecobutton.dart';

class CartPage extends StatelessWidget {
//  const CartPage({Key? key}) : super(key: key);

  CollectionReference db = FirebaseFirestore.instance.collection("cart");

  delete(String id, BuildContext context) {
    db.doc(id).delete().then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Deleted ScuccessFully")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: Header(title: "Cart Items"),
          preferredSize: Size.fromHeight(7.h),
        ),
        body: Column(
          children: [
            EcoButton(
              onpress: () {
                if (FirebaseAuth.instance.currentUser!.displayName == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("First Complete Your Profile"),
                  ));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckOutPage()));
                }
              },
              title: "CheckOut",
            ),
            Expanded(
              child: StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection("cart").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, index) {
                              final res = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 3,
                                          spreadRadius: 3,
                                        )
                                      ]),
                                  child: Row(
                                    children: [
                                      Image.network(
                                        res['image'],
                                        height: 90,
                                        width: 90,
                                        fit: BoxFit.fill,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                "${res["name"]}",
                                                style: EcoStyle.boldStyle
                                                    .copyWith(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 1.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text("Qty:"),
                                                  SizedBox(width: 10),
                                                  Container(
                                                      color: Colors.black,
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 20,
                                                              minWidth: 30,
                                                              maxHeight: 20,
                                                              maxWidth: 30),
                                                      child: Center(
                                                        child: Text(
                                                          "${res["quantity"]}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      )),
                                                  SizedBox(width: 30),
                                                  Text("Price:"),
                                                  SizedBox(width: 10),
                                                  Container(
                                                      color: Colors.black,
                                                      constraints:
                                                          BoxConstraints(
                                                              minHeight: 20,
                                                              minWidth: 40,
                                                              maxHeight: 20,
                                                              maxWidth: 40),
                                                      child: Center(
                                                        child: Text(
                                                          "${res["price"]}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          delete(res.id, context);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.remove,
                                            size: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }));
                  }),
            ),
          ],
        ));
  }
}
