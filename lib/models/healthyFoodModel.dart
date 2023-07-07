import 'package:cloud_firestore/cloud_firestore.dart';

class healthyFoodModel {
  String? foodName;
  String? foodCalories;
  String? Carbs;
  String? Volume;
  String? image;
  String? Category;
  String? timestamp;

  healthyFoodModel(
      {required this.foodName,
      required this.foodCalories,
      required this.Carbs,
      required this.Volume,
      required this.image,
      required this.Category,
      required this.timestamp});

  healthyFoodModel.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    foodName = snapshot.get('foodName');
    Carbs = snapshot.get('Carbs');
    foodCalories = snapshot.get('foodCalories');
    Category = snapshot.get('Category');
    image = snapshot.get('image');
  }
}

enum Foods {
  ALL,
  HighCarbs,
  WeightGain,
  WeightLoss,
}
