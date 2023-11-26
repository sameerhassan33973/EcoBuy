import 'package:cloud_firestore/cloud_firestore.dart';

class Products {
  String? id;
  String? category;
  String? name;
  String? detail;
  int? price;
  int? discount;
  String? serialcode;
  List<dynamic>? imageurls;
  bool? isonsale;
  bool? ispopular;
  bool? isfav;
  Products(
      {this.id,
      this.category,
      this.name,
      this.detail,
      this.price,
      this.discount,
      this.serialcode,
      this.imageurls,
      this.isonsale,
      this.isfav,
      this.ispopular});
  CollectionReference db = FirebaseFirestore.instance.collection("products");

  static Future<void> addProducts(Products p) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");
    Map<String, dynamic> data = {
      "category": p.category,
      "name": p.name,
      "id": p.id,
      "price": p.price,
      "detail": p.detail,
      "discount": p.discount,
      "serialcode": p.serialcode,
      "imageurls": p.imageurls,
      "isfav": p.isfav,
      "isonsale": p.isonsale,
      "ispopular": p.ispopular,
    };
    await db.add(data);
  }

  static Future<void> updateProducts(String iid, Products p) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");
    Map<String, dynamic> data = {
      "category": p.category,
      "name": p.name,
      "id": p.id,
      "price": p.price,
      "detail": p.detail,
      "discount": p.discount,
      "serialcode": p.serialcode,
      "imageurls": p.imageurls,
      "isfav": p.isfav,
      "isonsale": p.isonsale,
      "ispopular": p.ispopular,
    };
    await db.doc(iid).update(data);
  }

  static Future<void> deleteProducts(String iid) async {
    CollectionReference db = FirebaseFirestore.instance.collection("products");
    await db.doc(iid).delete();
  }
}
