import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  static User? get currentUser => FirebaseAuth.instance.currentUser;

   static Future<void> signup(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
        msg: "Create account success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await Future.delayed(const Duration(seconds: 1));
      if (context.mounted) {
        Navigator.pushNamed(context, '/signin');
      }
    } catch (e) {
      String message;
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            message = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            message = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            message = 'The email address is not valid.';
            break;
          default:
            message = 'An unknown error occurred.';
        }
      } else {
        message = 'An unknown error occurred.';
      }
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      throw e;
    }
  }

  static Future<void> signin(String email, String password, BuildContext context) async {
try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        if (context.mounted) {
        Navigator.pushNamed(context, '/');
      Fluttertoast.showToast(
        msg: "Login success",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
      }
    } catch (e) {
      final message = (e is FirebaseAuthException && e.code == 'user-not-found' ? "Invalid email or password" : "Something went wrong");
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
      throw e;
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg:"Please check your email ${email} to reset your password");
      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamed(context, "/signin");
    } catch (e) {
      Fluttertoast.showToast(msg:"Something went wrong, try again later");
    }
  }

  static bool checkUserLogin() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Fluttertoast.showToast(msg: "Please, log in to continue");
      return false;
    }
    return true;
  }

  static Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, "/signin");
    Fluttertoast.showToast(msg: "Logout success");
  }
}