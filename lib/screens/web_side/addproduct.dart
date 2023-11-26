import 'dart:io';
import 'package:eco_buy/models/products.dart';
import 'package:eco_buy/widgets/ecobutton.dart';
import 'package:eco_buy/widgets/ecotextfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import '../../models/category.dart';
import '../../utils/styles.dart';
import 'package:uuid/uuid.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);
  static const String id = "addproduct";

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController category = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController serialcode = TextEditingController();
  TextEditingController detail = TextEditingController();
  bool isonsale = false;
  bool isfav = false;
  bool ispopular = false;
  String? selectedValue;
  bool uploading = false;
  bool saving = false;
  final imagepicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageurls = [];
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            child: Column(
              children: [
                Text(
                  "Add Screen",
                  style: EcoStyle.boldStyle,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField(
                      hint: Text("Choose Category"),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                      ),
                      validator: (val) {
                        if (val == null) {
                          return "Category Must Be Selected";
                        }
                        return null;
                      },
                      value: selectedValue,
                      items: categories
                          .map((e) => DropdownMenuItem<String>(
                                value: e.title,
                                child: Text(e.title!),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value.toString();
                        });
                      }),
                ),
                EcoTextField(
                  controller: name,
                  hintText: "Enter Product Name",
                ),
                EcoTextField(
                  controller: detail,
                  hintText: "Enter Product Detail",
                  maxlines: 5,
                ),
                EcoTextField(
                  controller: price,
                  hintText: "Enter Product Price",
                ),
                EcoTextField(
                  controller: discount,
                  hintText: "Enter Product DiscountPrice",
                ),
                EcoTextField(
                  controller: serialcode,
                  hintText: "Enter Product Serial Code",
                ),
                EcoButton(
                  title: "Pick Images",
                  onpress: () {
                    pickImage();
                  },
                ),
                Container(
                  height: 25.h,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                    ),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 30.h,
                              width: 10.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                File(images[index].path).path,
                                height: 100,
                                width: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              icon: Icon(Icons.cancel)),
                        ],
                      );
                    },
                  ),
                ),
                SwitchListTile(
                  title: Text("Is This Product Popular"),
                  onChanged: (v) {
                    setState(() {
                      ispopular = !ispopular;
                    });
                  },
                  value: ispopular,
                ),
                SwitchListTile(
                  title: Text("Is This Product Favourite"),
                  onChanged: (v) {
                    setState(() {
                      isfav = !isfav;
                    });
                  },
                  value: isfav,
                ),
                SwitchListTile(
                  title: Text("Is This Product On Sale"),
                  onChanged: (v) {
                    setState(() {
                      isonsale = !isonsale;
                    });
                  },
                  value: isonsale,
                ),
                EcoButton(
                    title: "Save",
                    isloading: saving,
                    onpress: () {
                      save();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickImage() async {
    List<XFile>? pickimage = await imagepicker.pickMultiImage();
    if (pickimage != null) {
      setState(() {
        images.addAll(pickimage);
      });
    } else {
      print("no image selected");
    }
  }

  save() async {
    setState(() {
      saving = true;
    });
    await uploadImages();
    await Products.addProducts(Products(
            category: selectedValue,
            id: uuid.v4(),
            name: name.text,
            detail: detail.text,
            price: int.parse(price.text),
            discount: int.parse(discount.text),
            serialcode: serialcode.text,
            imageurls: imageurls,
            isonsale: isonsale,
            isfav: isfav,
            ispopular: ispopular))
        .whenComplete(() {
      setState(() {
        saving = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Product Added")));
        imageurls.clear();
        images.clear();
        name.clear();
        detail.clear();
        price.clear();
        discount.clear();
        serialcode.clear();
        selectedValue = null;
      });
    });

    // await FirebaseFirestore.instance
    //     .collection("products")
    //     .add({"images": imageurls}).whenComplete(() {
    //
    // });
  }

  Future postImages(XFile? imagefile) async {
    setState(() {
      uploading = true;
    });

    String urls;

    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imagefile!.name);
    if (kIsWeb) {
      await ref.putData(await imagefile.readAsBytes(),
          SettableMetadata(contentType: "image/jpeg"));
    }
    urls = await ref.getDownloadURL();
    setState(() {
      uploading = false;
    });
    return urls;
  }

  uploadImages() async {
    for (var image in images) {
      await postImages(image).then((downloadurl) => imageurls.add(downloadurl));
    }
  }
}
