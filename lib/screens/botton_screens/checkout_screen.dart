import 'package:eco_buy/utils/styles.dart';
import 'package:flutter/material.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "CheckOut",
      style: EcoStyle.boldStyle,
    ));
  }
}
