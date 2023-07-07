import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supreme_fitness/models/healthyFoodModel.dart';

import 'chipController.dart';
import 'firebase_controller.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  //dependency injection with getx
  final FirestoreController firestoreController =
      Get.put(FirestoreController());
  final ChipController chipController = Get.put(ChipController());

  //name of chips given as list
  final List<String> _chipLabel = [
    'All',
    'High Carbs',
    'Weight Gain',
    'Weight Loss',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Obx(
            () => Wrap(
              spacing: 20,
              children: List<Widget>.generate(2, (int index) {
                return ChoiceChip(
                  label: Text(_chipLabel[index]),
                  selected: chipController.selectedChip == index,
                  onSelected: (bool selected) {
                    chipController.selectedChip = selected ? index : null;
                    firestoreController.onInit();
                    firestoreController
                        .getFoods(Foods.values[chipController.selectedChip]);
                  },
                );
              }),
            ),
          ),
          Obx(() => Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: firestoreController.foodList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(
                            Icons.food_bank,
                            color: Colors.blue,
                          ),
                          title: Text(
                              "${firestoreController.foodList[index].foodName}"),
                          subtitle: Text("Carbs:- " +
                              "${firestoreController.foodList[index].Carbs}" +
                              " " +
                              " " +
                              "Kcal:- " +
                              "${firestoreController.foodList[index].foodCalories}" +
                              " " +
                              " " +
                              "Used For:- " +
                              "${firestoreController.foodList[index].Category}"),
                        ),
                      );
                    }),
              )),
        ],
      ),
    ));
  }
}
