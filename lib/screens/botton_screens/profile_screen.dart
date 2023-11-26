import 'dart:io';
import 'package:eco_buy/screens/landing_screen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/ecobutton.dart';
import '../../widgets/ecotextfield.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? profilePic;

  TextEditingController nameC = TextEditingController();

  TextEditingController phoneC = TextEditingController();

  TextEditingController houseC = TextEditingController();

  TextEditingController streetC = TextEditingController();

  TextEditingController cityC = TextEditingController();

  TextEditingController addressC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? downloadUrl;
  String? already;
  bool selection = false;

  // String? buttonText;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (FirebaseAuth.instance.currentUser!.displayName == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('please complete profile firstly')));
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
          nameC.text = snapshot['name'];
          phoneC.text = snapshot['phone'];
          houseC.text = snapshot['house'];
          cityC.text = snapshot['city'];
          streetC.text = snapshot['street'];
          addressC.text = snapshot['address'];
          profilePic = snapshot['profilePic'];
        });
      }
    });
    super.initState();
  }

  bool isSaving = false;

  @override
  Widget build(BuildContext context) {
    already = nameC.text;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "PROFILE",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                        );
                        if (pickImage != null) {
                          setState(() {
                            profilePic = pickImage.path;
                            selection = true;
                          });
                        }
                      },
                      child: Container(
                        child: profilePic == null
                            ? CircleAvatar(
                                radius: 70,
                                backgroundColor:
                                    Color.fromARGB(255, 141, 106, 201),
                                child: Image.asset(
                                  'assets/c_images/add_pic.jpg',
                                  fit: BoxFit.cover,
                                ),
                              )
                            : profilePic!.contains('http')
                                ? CircleAvatar(
                                    radius: 70,
                                    backgroundImage: NetworkImage(profilePic!),
                                  )
                                : CircleAvatar(
                                    radius: 70,
                                    backgroundImage: FileImage(
                                      File(profilePic!),
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  EcoTextField(
                    hintText: "Enter Name",
                    controller: nameC,
                  ),
                  EcoTextField(
                    hintText: "Enter PhoneNumber",
                    controller: phoneC,
                  ),
                  EcoTextField(
                    hintText: "Enter House No",
                    controller: houseC,
                  ),
                  EcoTextField(
                    hintText: "Enter Street ",
                    controller: streetC,
                  ),
                  EcoTextField(
                    hintText: "Enter City",
                    controller: cityC,
                  ),
                  EcoTextField(
                    hintText: "Enter Complete Address",
                    controller: addressC,
                  ),
                  EcoButton(
                    title: nameC.text.isEmpty ? 'SAVE' : 'Update',
                    isloading: isSaving,
                    onpress: () {
                      if (formKey.currentState!.validate()) {
                        SystemChannels.textInput.invokeMapMethod(
                            'TextInput.hide'); // hides keyboard
                        profilePic == null
                            ? ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('select profile pic')))
                            : already == null
                                ? saveInfo()
                                : update();
                      }
                    },
                  ),
                  EcoButton(
                    color: Colors.white,
                    textcolor: Colors.black,
                    onpress: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LandingScreen()));
                    },
                    title: 'SIGN OUT',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(File filepath, String? reference) async {
    try {
      final finalName =
          '${FirebaseAuth.instance.currentUser!.uid}${DateTime.now().second}';
      final Reference fbStorage =
          FirebaseStorage.instance.ref(reference).child(finalName);
      final UploadTask uploadTask = fbStorage.putFile(filepath);
      await uploadTask.whenComplete(() async {
        downloadUrl = await fbStorage.getDownloadURL();
      });

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  update() {
    setState(() {
      isSaving = true;
    });
    if (selection == true) {
      uploadImage(File(profilePic!), 'profile').whenComplete(() {
        Map<String, dynamic> data = {
          'name': nameC.text,
          'phone': phoneC.text,
          'house': houseC.text,
          'street': streetC.text,
          'city': cityC.text,
          'address': addressC.text,
          'profilePic': downloadUrl,
        };
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update(data)
            .whenComplete(() {
          FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
          setState(() {
            isSaving = false;
          });
        });
      });
    } else {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'phone': phoneC.text,
        'house': houseC.text,
        'street': streetC.text,
        'city': cityC.text,
        'address': addressC.text,
        'profilePic': profilePic,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    }
  }

  saveInfo() {
    setState(() {
      isSaving = true;
    });
    uploadImage(File(profilePic!), 'profile').whenComplete(() {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'phone': phoneC.text,
        'house': houseC.text,
        'street': streetC.text,
        'city': cityC.text,
        'address': addressC.text,
        'profilePic': downloadUrl,
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(data)
          .whenComplete(() {
        FirebaseAuth.instance.currentUser!.updateDisplayName(nameC.text);
        setState(() {
          isSaving = false;
        });
      });
    });
  }
}
