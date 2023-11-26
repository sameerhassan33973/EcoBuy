import 'dart:math';
import 'package:eco_buy/screens/botton_screens/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../models/category.dart';

class HomeCategoryBlocks extends StatelessWidget {
  String? category;
  HomeCategoryBlocks({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(
                categories.length,
                (index) => Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                        category: categories[index].title)));
                          },
                          child: Container(
                            height: 14.h,
                            width: 21.w,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.w, vertical: 1.h),
                              child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              categories[index].image!),
                                          fit: BoxFit.cover),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            spreadRadius: 0.6),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.primaries[Random()
                                          .nextInt(categories.length)])),
                            ),
                          ),
                        ),
                        Text(
                          categories[index].title!,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.black),
                        ),
                        SizedBox(
                          height: 2.h,
                        )
                      ],
                    ))
          ],
        ),
      ),
    );
  }
}
