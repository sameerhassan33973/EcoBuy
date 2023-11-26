import 'package:eco_buy/screens/web_side/web_main.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:eco_buy/widgets/ecobutton.dart';
import 'package:eco_buy/widgets/ecodialog.dart';
import 'package:eco_buy/widgets/ecotextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sizer/sizer.dart';

import '../../services/firebase_services.dart';

class WebLogin extends StatefulWidget {
  @override
  State<WebLogin> createState() => _WebLoginState();
}

class _WebLoginState extends State<WebLogin> {
  // const WebLogin({Key? key}) : super(key: key);
  TextEditingController em = new TextEditingController();

  TextEditingController pass = new TextEditingController();

  final formkey = GlobalKey<FormState>();

  bool formStateLoading = false;

  submit(BuildContext context) async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });
      await FirebaseServices.adminLogin(em.text).then((value) async {
        if (value['username'] == em.text && value['password'] == pass.text) {
          try {
            UserCredential user =
                await FirebaseAuth.instance.signInAnonymously();
            if (user != null) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => WebMain()));
            } else {
              showDialog(
                  context: context,
                  builder: (_) {
                    return EcoDialog(title: "USER NOT FOUND");
                  });
            }
          } catch (e) {
            setState(() {
              formStateLoading = false;
            });
            return showDialog(
                context: context,
                builder: (_) {
                  return EcoDialog(title: e.toString());
                });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 5,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welecome Admin",
                      style: EcoStyle.boldStyle,
                    ),
                    Text(
                      "Login To Your Account",
                      style: EcoStyle.boldStyle,
                    ),
                    EcoTextField(
                      hintText: "Email",
                      controller: em,
                    ),
                    EcoTextField(
                      controller: pass,
                      hintText: "Password",
                      ispassword: true,
                    ),
                    EcoButton(
                      isloading: formStateLoading,
                      title: "Login",
                      onpress: () {
                        submit(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
