import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class categoryProvider with ChangeNotifier {
  void addCategory({String? categoryName, String? timestamp}) async {
    await FirebaseFirestore.instance
        .collection("category")
        .doc()
        .set({"categoryName": categoryName, "timestamp": timestamp});
  }

  Future<DocumentSnapshot> getCategory() async {
    return await FirebaseFirestore.instance.collection("category").doc().get();
  }
}
