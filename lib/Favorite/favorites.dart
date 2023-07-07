import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/providers/favoriteProvider.dart';
import 'package:velocity_x/velocity_x.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FavoriteProvider>(context);
    var foodNames = provider.foodName;
    var foodCalories = provider.foodCalories;
    var foodCaloriesToINT = foodCalories.map((e) => (int.parse(e))).toList();
    //var count = foodCaloriesToINT.reduce((value, element) => value + element);
    double count = foodCaloriesToINT.fold(
        0, (previousValue, element) => previousValue + element);
    var foodCaloriesToString = foodCalories.join(" ");

    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
          title: const Text(
            "Count Calories",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          )),
      body: ListView.builder(
          itemCount: foodNames.length,
          itemBuilder: (context, index) {
            final foodName = foodNames[index];
            final foodCalorie = foodCalories[index];
            return ListTile(
              title: Text(
                "Food Name:- " + foodName,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                "Food Calories:- " + foodCalorie,
                style: TextStyle(color: Colors.white),
              ),
              trailing: IconButton(
                  onPressed: () {
                    provider.toggleFavorite(foodName, foodCaloriesToString);
                    setState(() {
                        count = foodCaloriesToINT.fold(
        0, (previousValue, element) => previousValue + element);
                    });
                  },
                  icon: provider.isExist(foodName)
                      ? const Icon(Icons.delete_forever,
                          color: Color.fromRGBO(255, 207, 96, 1))
                      : const Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            provider.clearFavorite(foodNames, foodCalories);
          },
          label: Text("Total Calories:-" + count.toString())),
    );
  }
}
