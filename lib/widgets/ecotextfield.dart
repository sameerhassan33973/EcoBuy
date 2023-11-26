import 'package:flutter/material.dart';

class EcoTextField extends StatefulWidget {
  String? hintText;
  int? maxlines;
  bool? ispassword;
  Widget? icon;
  TextInputAction? inputAction;
  TextEditingController? controller;
  FocusNode? focusNode;
  String Function(String?)? validate;
  String? Function(String?)? validator;
  EcoTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.focusNode,
      this.validate,
      this.validator,
      this.ispassword,
      this.maxlines,
      this.icon,
      this.inputAction})
      : super(key: key);

  @override
  State<EcoTextField> createState() => _EcoTextFieldState();
}

class _EcoTextFieldState extends State<EcoTextField> {
  @override
  Widget build(BuildContext context) {
    if (widget.maxlines != null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: widget.controller,
          validator: (v) {
            if (v!.isEmpty) {
              return "Empty Fields not allowed";
            }
            return null;
          },
          focusNode: widget.focusNode,
          textInputAction: widget.inputAction,
          maxLines: widget.maxlines,
          decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: widget.icon,
              hintText: widget.hintText ?? "hint text",
              contentPadding: EdgeInsets.all(10)),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: (v) {
          if (v!.isEmpty) {
            return "Empty Fields not allowed";
          }
          return null;
        },
        focusNode: widget.focusNode,
        textInputAction: widget.inputAction,
        obscureText: widget.ispassword ?? false,
        decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: widget.icon,
            hintText: widget.hintText ?? "hint text",
            contentPadding: EdgeInsets.all(10)),
      ),
    );
  }
}
