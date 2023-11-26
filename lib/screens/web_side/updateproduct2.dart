import 'dart:io';

import 'package:eco_buy/widgets/ecobutton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

import '../../models/category.dart';
import '../../models/products.dart';
import '../../utils/styles.dart';
import '../../widgets/ecotextfield.dart';
import 'addproduct.dart';

class UpdateProduct2 extends StatefulWidget {
  String? id;
  Products? products;
  UpdateProduct2({Key? key, this.id, this.products}) : super(key: key);

  @override
  State<UpdateProduct2> createState() => _UpdateProduct2State();
}

class _UpdateProduct2State extends State<UpdateProduct2> {
  TextEditingController categoryC = TextEditingController();

  TextEditingController idC = TextEditingController();

  TextEditingController productNameC = TextEditingController();

  TextEditingController detailC = TextEditingController();

  TextEditingController priceC = TextEditingController();

  TextEditingController discountPriceC = TextEditingController();

  TextEditingController serialCodeC = TextEditingController();

  TextEditingController brandC = TextEditingController();

  bool isOnSale = false;

  bool isPopular = false;

  bool isFavourite = false;

  String? selectedValue = "";

  bool isSaving = false;

  bool isUploading = false;

  final imagePicker = ImagePicker();

  List<XFile> images = [];

  List<dynamic> imageUrls = [];
  bool saving = false;
  var uuid = Uuid();

  @override
  void initState() {
    selectedValue = widget.products!.category!;
    productNameC.text = widget.products!.name!;
    detailC.text = widget.products!.detail!;
    priceC.text = widget.products!.price!.toString();
    discountPriceC.text = widget.products!.discount!.toString();
    serialCodeC.text = widget.products!.serialcode!;
    isOnSale = widget.products!.isonsale!;
    isPopular = widget.products!.ispopular!;
    isFavourite = widget.products!.isfav!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                children: [
                  const Text(
                    "UPDATE PRODUCT",
                    style: EcoStyle.boldStyle,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonFormField(
                        hint: const Text("choose category"),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(10),
                        ),
                        validator: (value) {
                          if (value == null) {
                            return "category must be selected";
                          }
                          return null;
                        },
                        value: selectedValue,
                        items: categories
                            .map((e) => DropdownMenuItem<String>(
                                value: e.title, child: Text(e.title!)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value.toString();
                          });
                        }),
                  ),
                  EcoTextField(
                    controller: productNameC,
                    hintText: "enter product name...",
                  ),
                  EcoTextField(
                    maxlines: 5,
                    controller: detailC,
                    hintText: "enter product detail...",
                  ),
                  EcoTextField(
                    controller: priceC,
                    hintText: "enter product price...",
                  ),
                  EcoTextField(
                    controller: discountPriceC,
                    hintText: "enter product discount Price...",
                  ),
                  EcoTextField(
                    controller: serialCodeC,
                    hintText: "enter product serial code...",
                  ),
                  Container(
                    height: 25.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: widget.products!.imageurls!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Image.network(
                                  widget.products!.imageurls![index],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      widget.products!.imageurls!
                                          .removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_outlined))
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  EcoButton(
                    title: "PICK IMAGES",
                    onpress: () {
                      pickImage();
                    },
                  ),
                  // EcoButton(
                  //   title: "UPLOAD IMAGES",
                  //   isLoading: isUploading,
                  //   onPress: () {
                  //     uploadImages();
                  //   },
                  //   isLoginButton: true,
                  // ),
                  Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Image.network(
                                  File(images[index].path).path,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(index);
                                    });
                                  },
                                  icon: const Icon(Icons.cancel_outlined))
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  SwitchListTile(
                      title: Text("Is this Product on Sale?"),
                      value: isOnSale,
                      onChanged: (v) {
                        setState(() {
                          isOnSale = !isOnSale;
                        });
                      }),
                  SwitchListTile(
                      title: Text("Is this Product Popular?"),
                      value: isPopular,
                      onChanged: (v) {
                        setState(() {
                          isPopular = !isPopular;
                        });
                      }),
                  EcoButton(
                    title: "SAVE",
                    isloading: saving,
                    onpress: () {
                      save();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  save() async {
    setState(() {
      saving = true;
    });
    await uploadImages();
    await Products.updateProducts(
            widget.id!,
            Products(
                category: selectedValue,
                id: widget.id!,
                name: productNameC.text,
                detail: detailC.text,
                price: int.parse(priceC.text),
                discount: int.parse(discountPriceC.text),
                serialcode: serialCodeC.text,
                imageurls: imageUrls,
                isonsale: isOnSale,
                ispopular: isPopular,
                isfav: isFavourite))
        .whenComplete(() {
      setState(() {
        saving = false;
        imageUrls.clear();
        images.clear();
        clearFields();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("ADDED SUCCESSFULLY")));
      });
    });
    // await FirebaseFirestore.instance
    //     .collection("products")
    //     .add({"images": imageUrls}).whenComplete(() {
    //   setState(() {
    //     isSaving = false;
    //     images.clear();
    //     imageUrls.clear();
    //   });
    // });
  }

  clearFields() {
    setState(() {
      // selectedValue = "";
      productNameC.clear();
    });
  }

  pickImage() async {
    final List<XFile>? pickImage = await imagePicker.pickMultiImage();
    if (pickImage != null) {
      setState(() {
        images.addAll(pickImage);
      });
    } else {
      print("no images selected");
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      return urls;
    }
  }

  uploadImages() async {
    for (var image in images) {
      await postImages(image).then((downLoadUrl) => imageUrls.add(downLoadUrl));
    }
    imageUrls.addAll(widget.products!.imageurls!);
  }
}
