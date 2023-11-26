import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_buy/screens/botton_screens/product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'botton_screens/cart_screen.dart';
import 'botton_screens/favourite_screen.dart';
import 'botton_screens/home_screen.dart';
import 'botton_screens/profile_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int length = 0;

  void cartItemLength() {
    FirebaseFirestore.instance.collection("cart").get().then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          length = value.docs.length;
        });
      } else {
        setState(() {
          length = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // cartItemLength();
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home)),
        BottomNavigationBarItem(icon: Icon(Icons.shop)),
        BottomNavigationBarItem(
            icon: Stack(
          children: [
            Icon(Icons.add_shopping_cart),
            Positioned(
                child: length == 0
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Stack(
                        children: [
                          Icon(
                            Icons.brightness_1,
                            color: Colors.black,
                            size: 20,
                          ),
                          Positioned.fill(
                              child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "$length",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                        ],
                      ))
          ],
        )),
        BottomNavigationBarItem(icon: Icon(Icons.favorite)),
        BottomNavigationBarItem(icon: Icon(Icons.person)),
      ]),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: Home());
              },
            );
          case 1:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: ProductPage());
              },
            );
          case 2:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: CartPage());
              },
            );
          case 3:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: FavouritePage());
              },
            );
          case 4:
            return CupertinoTabView(
              builder: (context) {
                return CupertinoPageScaffold(child: ProfilePage());
              },
            );
        }

        return Home();
      },
    );
  }
}
