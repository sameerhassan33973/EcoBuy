import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/styles.dart';

class AllProduct extends StatelessWidget {
  const AllProduct({Key? key}) : super(key: key);
  static const String id = "allproduct";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "All PRODUCTS",
        style: EcoStyle.boldStyle,
      )),
    );
  }
}
