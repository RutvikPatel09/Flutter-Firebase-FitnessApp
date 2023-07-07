import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class exerciseProvider with ChangeNotifier{
  void addExercise({String? exerciseName,String? gif, String? Category , String? timestamp}) async {
    await FirebaseFirestore.instance
        .collection("exercises")
        .doc()
        .set({
          "exerciseName": exerciseName,
          "gif": gif,
          "Category": Category,
          "timestamp": timestamp});
  }
}