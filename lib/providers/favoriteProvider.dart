import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _foodName = [];
  List<String> get foodName => _foodName;

  List<String> _foodCalories = [];
  List<String> get foodCalories => _foodCalories;

  void toggleFavorite(String foodName, String foodCalories) {
    final isExist = _foodName.contains(foodName);
    final isExistCalories = _foodCalories.contains(foodCalories);

    if (isExist) {
      _foodName.remove(foodName);
      _foodCalories.remove(foodCalories);
    } else {
      _foodName.add(foodName);
      _foodCalories.add(foodCalories);
    }
    notifyListeners();
  }

  bool isExist(String foodName) {
    final isExist = _foodName.contains(foodName);
    return isExist;
  }

  bool isExistCalories(String foodCalories) {
    final isExist = _foodCalories.contains(foodCalories);
    return isExist;
  }

  void clearFavorite(List<String> foodNames, List<String> foodCalories) {
    _foodName = [];
    _foodCalories = [];
    notifyListeners();
  }
}
