import 'package:eco_buy/screens/layout_screen.dart';
import 'package:eco_buy/screens/web_side/addproduct.dart';
import 'package:eco_buy/screens/web_side/allproducts.dart';
import 'package:eco_buy/screens/web_side/dashboard.dart';
import 'package:eco_buy/screens/web_side/deleteproduct.dart';
import 'package:eco_buy/screens/web_side/updateproduct.dart';
import 'package:eco_buy/screens/web_side/web_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBhm6GqlK54n5N6DLEWFVUbISS6M1Z8Jm8",
            authDomain: "eco-buy-51f57.firebaseapp.com",
            projectId: "eco-buy-51f57",
            storageBucket: "eco-buy-51f57.appspot.com",
            messagingSenderId: "658012343155",
            appId: "1:658012343155:web:7b1a8021a89a5d706b1306"));
  } else {
    await Firebase.initializeApp();
  }
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
              DeviceType deviceType) =>
          MaterialApp(
        title: 'Eco Buy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: LayoutScreen(),
        routes: {
          AddProduct.id: (context) => AddProduct(),
          UpdateProduct.id: (context) => UpdateProduct(),
          DeleteProduct.id: (context) => DeleteProduct(),
          AllProduct.id: (context) => AllProduct(),
          Dashboard.id: (context) => Dashboard(),
          WebMain.id: (context) => WebMain(),
        },
      ),
    );
  }
}
