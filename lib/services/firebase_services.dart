import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static Future<String?> createAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code != null) {
        return e.message.toString();
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<String?> loginAccount(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return ("This EMAIL IS ALREADY IN USE");
      } else if (e.code == "weak-password") {
        return ("YOUR PASSWORD IS TOO WEAK");
      } else if (e.code != null) {
        return e.message.toString();
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<DocumentSnapshot> adminLogin(id) async {
    var result = FirebaseFirestore.instance.collection("admin").doc(id).get();
    return result;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
