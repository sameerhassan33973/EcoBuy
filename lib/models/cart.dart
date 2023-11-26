import 'package:cloud_firestore/cloud_firestore.dart';

class Cart {
  String? id;
  String? name;
  int? price;
  int? quantity;
  String? image;
  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.image,
  });

  static Future<void> addtoCart(Cart cart) async {
    CollectionReference db = FirebaseFirestore.instance.collection("cart");
    Map<String, dynamic> data = {
      "id": cart.id,
      "name": cart.name,
      "image": cart.image,
      "quantity": cart.quantity,
      "price": cart.price
    };
    await db.add(data);
  }
}
