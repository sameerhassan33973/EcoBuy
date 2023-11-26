import 'package:flutter/material.dart';
import 'ecobutton.dart';

class EcoDialog extends StatelessWidget {
  String title;

  EcoDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("$title"),
      actions: [
        EcoButton(
          title: "OK",
          onpress: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
