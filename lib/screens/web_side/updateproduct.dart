import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/web_side/updateproduct2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';

import '../../models/products.dart';
import '../../utils/styles.dart';

class UpdateProduct extends StatelessWidget {
  const UpdateProduct({Key? key}) : super(key: key);

  static const String id = "updateproduct";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            const Text(
              "UPDATE PRODUCT",
              style: EcoStyle.boldStyle,
            ),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("NO DATA EXISTS"));
                }
                final data = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                            color: Colors.black,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: ListTile(
                                  title: Text(
                                    data[index]['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: Container(
                                    width: 200,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Products.deleteProducts(
                                                data[index].id);
                                          },
                                          icon:
                                              const Icon(Icons.delete_forever),
                                          color: Colors.white,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return UpdateProduct2(
                                                  id: data[index].id,
                                                  products: Products(
                                                    category: data[index]
                                                        ["category"],
                                                    id: id,
                                                    name: data[index]["name"],
                                                    detail: data[index]
                                                        ["detail"],
                                                    price: data[index]["price"],
                                                    discount: data[index]
                                                        ["discount"],
                                                    serialcode: data[index]
                                                        ["serialcode"],
                                                    imageurls: data[index]
                                                        ["imageurls"],
                                                    isonsale: data[index]
                                                        ["isonsale"],
                                                    ispopular: data[index]
                                                        ["ispopular"],
                                                    isfav: data[index]["isfav"],
                                                  ));
                                            }));
                                            // Navigator.pushReplacementNamed(
                                            //     context, UpdateCompleteProductScreen.id);
                                          },
                                          icon: const Icon(Icons.edit),
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
