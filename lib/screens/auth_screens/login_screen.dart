import 'package:eco_buy/screens/auth_screens/signup_screen.dart';
import 'package:eco_buy/screens/bottombar.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:eco_buy/widgets/ecobutton.dart';
import 'package:eco_buy/widgets/ecotextfield.dart';

import 'package:flutter/material.dart';

import '../../services/firebase_services.dart';
import '../../widgets/ecodialog.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // const LoginScreen({Key? key}) : super(key: key);
  TextEditingController email = new TextEditingController();
  final formkey = GlobalKey<FormState>();
  TextEditingController password = new TextEditingController();
  bool ispassword = true;
  bool formstateloading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: double.infinity,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Welcome, \n Please Login First",
                    style: EcoStyle.boldStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 150),
                  Column(
                    children: [
                      Form(
                        key: formkey,
                        child: Column(
                          children: [
                            EcoTextField(
                              controller: email,
                              hintText: "Email",
                              icon: Icon(Icons.email),
                            ),
                            EcoTextField(
                                hintText: "Password",
                                controller: password,
                                ispassword: ispassword,
                                icon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        ispassword = !ispassword;
                                      });
                                    },
                                    icon: ispassword
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off))),
                            EcoButton(
                              title: "Login",
                              onpress: submit,
                              isloading: formstateloading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                  EcoButton(
                    title: "Create New Account",
                    color: Colors.white,
                    textcolor: Colors.black,
                    onpress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupScreen()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    if (formkey.currentState!.validate() == true) {
      setState(() {
        formstateloading = true;
      });
      String? accountstatus = await FirebaseServices.loginAccount(
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BottomBar()));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }
}
