import 'package:eco_buy/screens/bottombar.dart';
import 'package:eco_buy/utils/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth_screens/login_screen.dart';

class LandingScreen extends StatelessWidget {
  Future<FirebaseApp> initialize = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initialize,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
                body: Center(
              child: Text("${snapshot.error}"),
            ));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Scaffold(
                        body: Center(
                      child: Text("${snapshot.error}"),
                    ));
                  }
                  if (streamSnapshot.connectionState ==
                      ConnectionState.active) {
                    User? user = streamSnapshot.data;
                    if (user == null) {
                      return LoginScreen();
                    } else {
                      return BottomBar();
                    }
                  }
                  return Scaffold(
                      body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Checking Authentication",
                          style: EcoStyle.boldStyle,
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ));
                });
          }
          return Scaffold(
              body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "INITIALIZING THE APP",
                  style: EcoStyle.boldStyle,
                ),
                CircularProgressIndicator(),
              ],
            ),
          ));
        });
  }
}
