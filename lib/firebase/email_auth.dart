import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<bool> createUser(
      {required String emailUser, required String pwdUser}) async {
    try {
      final userCredentials = await _auth.createUserWithEmailAndPassword(
          email: emailUser, password: pwdUser);
      userCredentials.user!.sendEmailVerification();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> validateUser(
      {required String emailUser, required String pwdUser}) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
          email: emailUser, password: pwdUser);
      if (credentials.user!.emailVerified) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
