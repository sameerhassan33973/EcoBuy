import 'package:flutter/material.dart';

class EcoButton extends StatelessWidget {
  String? title;
  Color? color;
  VoidCallback? onpress;
  Color? textcolor;
  bool? isloading;
  EcoButton(
      {Key? key,
      this.isloading = false,
      this.title,
      this.color,
      this.textcolor,
      this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        height: 65,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        decoration: BoxDecoration(
            color: color ?? Colors.black,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(children: [
          Visibility(
            visible: isloading! ? false : true,
            child: Center(
                child: Text(title ?? "Button",
                    style: TextStyle(
                        color: textcolor ?? Colors.white, fontSize: 16))),
          ),
          Visibility(
            visible: isloading!,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ]),
      ),
    );
  }
}
