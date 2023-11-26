import 'package:eco_buy/services/firebase_services.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:eco_buy/widgets/ecobutton.dart';
import 'package:eco_buy/widgets/ecodialog.dart';
import 'package:eco_buy/widgets/ecotextfield.dart';

import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController email = new TextEditingController();

  TextEditingController password = new TextEditingController();

  TextEditingController conpassword = new TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool ispassword = true;
  bool ispassword2 = true;
  bool formstateloading = false;
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
    conpassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Welcome, \n Please Register Yourself",
                  style: EcoStyle.boldStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 100),
                Column(
                  children: [
                    Form(
                      key: formkey,
                      child: Column(
                        children: [
                          EcoTextField(
                            hintText: "Email",
                            controller: email,
                            icon: Icon(Icons.email),
                            inputAction: TextInputAction.next,
                          ),
                          EcoTextField(
                            hintText: "Password",
                            ispassword: ispassword,
                            icon: IconButton(
                              onPressed: () {
                                setState(() {
                                  ispassword = !ispassword;
                                });
                              },
                              icon: ispassword
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                            ),
                            controller: password,
                          ),
                          EcoTextField(
                              ispassword: ispassword2,
                              hintText: "Confirm Password",
                              controller: conpassword,
                              icon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      ispassword2 = !ispassword2;
                                    });
                                  },
                                  icon: ispassword2
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off))),
                          EcoButton(
                            title: "Signup",
                            isloading: formstateloading,
                            onpress: () {
                              submit();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 80),
                EcoButton(
                  title: "Back To Login",
                  color: Colors.white,
                  textcolor: Colors.black,
                  onpress: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    print(formkey.currentState!.validate().toString());
    if (formkey.currentState!.validate() == true) {
      if (password.text == conpassword.text) {
        setState(() {
          formstateloading = true;
        });
        String? accountstatus = await FirebaseServices.createAccount(
            email.text.toString(), password.text);
        if (accountstatus != null) {
          showDialog(
              context: context,
              builder: (_) {
                return EcoDialog(title: accountstatus);
              });
          setState(() {
            formstateloading = false;
          });
        } else {
          Navigator.pop(context);
        }
      }
    } else {}
  }

  Future<void> ecoDialog(String error) async {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(error),
            actions: [
              EcoButton(
                title: "close",
                onpress: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
