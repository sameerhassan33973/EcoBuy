import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';

class DeleteProduct extends StatelessWidget {
  const DeleteProduct({Key? key}) : super(key: key);

  static const String id = "deleteproduct";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Delete PRODUCT")),
    );
  }
}
