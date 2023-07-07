import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class healthyFoodProvider with ChangeNotifier{
  void addHealthyFood({String? foodName,String? foodCalories, String? Carbs ,String? Volume, String? image,String? Category ,String? timestamp}) async {
    await FirebaseFirestore.instance
        .collection("healthyFood")
        .doc()
        .set({
          "foodName": foodName,
          "foodCalories": foodCalories,
          "Carbs": Carbs,
          "Volume": Volume,
          "image": image,
          "Category": Category,
          "timestamp":timestamp});
  }

}