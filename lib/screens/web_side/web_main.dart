import 'package:eco_buy/screens/web_side/addproduct.dart';
import 'package:eco_buy/screens/web_side/allproducts.dart';
import 'package:eco_buy/screens/web_side/dashboard.dart';
import 'package:eco_buy/screens/web_side/deleteproduct.dart';
import 'package:eco_buy/screens/web_side/updateproduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class WebMain extends StatefulWidget {
  static const String id = "webmain";
  @override
  State<WebMain> createState() => _WebMainState();
}

class _WebMainState extends State<WebMain> {
  //const WebMain({Key? key}) : super(key: key);
  Widget selectedScreen = Dashboard();

  chooseScreens(items) {
    switch (items) {
      case Dashboard.id:
        setState(() {
          selectedScreen = Dashboard();
        });

        break;
      case AddProduct.id:
        setState(() {
          selectedScreen = AddProduct();
        });
        break;
      case UpdateProduct.id:
        setState(() {
          selectedScreen = UpdateProduct();
        });

        break;
      case DeleteProduct.id:
        setState(() {
          selectedScreen = DeleteProduct();
        });
        break;
      case AllProduct.id:
        setState(() {
          selectedScreen = AllProduct();
        });

        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Admin"),
        ),
        backgroundColor: Colors.black,
      ),
      body: selectedScreen,
      // ignore: prefer_const_literals_to_create_immutables
      sideBar: SideBar(
        backgroundColor: Colors.black,
        textStyle: TextStyle(color: Colors.white, fontSize: 16),
        onSelected: (item) {
          chooseScreens(item.route);
        },
        items: [
          AdminMenuItem(
            title: "Dashboard",
            icon: Icons.dashboard,
            route: Dashboard.id,
          ),
          AdminMenuItem(
              title: "Add Products", icon: Icons.add, route: AddProduct.id),
          AdminMenuItem(
              title: "Update Products",
              icon: Icons.edit,
              route: UpdateProduct.id),
          AdminMenuItem(
              title: "Delete Products",
              icon: Icons.delete,
              route: DeleteProduct.id),
          AdminMenuItem(
              title: "All Items", icon: Icons.shop, route: AllProduct.id),
        ],
        selectedRoute: WebMain.id,
      ),
    );
  }
}
