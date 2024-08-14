
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:safe_alert/Utils.dart';

class Services {
  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static Future<UserCredential?> createAccount(
      {required String email, required String password , required BuildContext context}) async {
    try {
      UserCredential? user = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      print("error : ${e.toString()}");
      Utils.showSnackbar(context: context, msg: e.toString());
      return null;
    }
  }

  static Future<void> saveUserDataToFirebase(Map<String, dynamic> data) async {
    User? currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      await fireStore.collection("Users").doc(currentUser.uid).set(data);
    } else {
      throw Exception("User not authenticated. Cannot save data.");
    }
  }

  static Future<bool> loginWithEmailAndPassword({required String email , required String password ,required BuildContext context }) async {
      try{
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        return true;
      }on FirebaseAuthException catch(e){
        print("error : ${e.toString()}");
        Utils.showSnackbar(context: context, msg: e.toString());
        return false;
      }
  }

  static Future<bool> signOut() async{
    await firebaseAuth.signOut();
    return true;
  }
}
