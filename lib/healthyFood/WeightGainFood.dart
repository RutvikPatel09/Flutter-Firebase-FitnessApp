import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Favorite/favorites.dart';
import 'package:supreme_fitness/Search/search.dart';
import 'package:supreme_fitness/providers/favoriteProvider.dart';

import '../models/healthyFoodModel.dart';
import 'chipController.dart';
import 'firebase_controller.dart';

class WeightGainFood extends StatefulWidget {
  const WeightGainFood({super.key});

  @override
  State<WeightGainFood> createState() => _WeightGainFoodState();
}

class _WeightGainFoodState extends State<WeightGainFood> {
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
    late CollectionReference food =
        FirebaseFirestore.instance.collection('healthyFood');
    final provider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color.fromRGBO(9, 26, 46, 1),
        shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(1),
        title: const Text(
          "Healthy Food",
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        ),
        actions: <Widget>[
          new IconButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              },
              highlightColor: Colors.yellow,
              icon: new Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body: Container(
        color: Color.fromRGBO(9, 26, 46, 1),
        child: SafeArea(
          child: Column(
            children: [
              Obx(
                () => Wrap(
                  spacing: 10,
                  children: List<Widget>.generate(4, (int index) {
                    return ChoiceChip(
                      label: Text(_chipLabel[index]),
                      selected: chipController.selectedChip == index,
                      onSelected: (bool selected) {
                        chipController.selectedChip = selected ? index : null;
                        firestoreController.onInit();
                        firestoreController.getFoods(
                            Foods.values[chipController.selectedChip]);
                      },
                    );
                  }),
                ),
              ),
              Obx(() => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: firestoreController.foodList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              color: Color.fromRGBO(59, 72, 89, 1),
                              child: ListTile(
                                trailing: IconButton(
                                  icon: provider.isExist(
                                          "${firestoreController.foodList[index].foodName}")
                                      ? Icon(Icons.delete_forever,
                                          color:
                                              Color.fromRGBO(255, 207, 96, 1))
                                      : Icon(Icons.add, color: Colors.white),
                                  onPressed: () {
                                    provider.toggleFavorite(
                                        "${firestoreController.foodList[index].foodName}",
                                        "${firestoreController.foodList[index].foodCalories}");
                                  },
                                ),
                                leading: FullScreenWidget(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image(
                                        height: 50,
                                        width: 50,
                                        image: NetworkImage(
                                            "${firestoreController.foodList[index].image}"),
                                      )),
                                ),
                                // leading: Icon(
                                //   Icons.food_bank,
                                //   color: Colors.blue,
                                // ),
                                title: Text(
                                  "${firestoreController.foodList[index].foodName}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    "Carbs:- " +
                                        "${firestoreController.foodList[index].Carbs}" +
                                        " " +
                                        " " +
                                        "Kcal:- " +
                                        "${firestoreController.foodList[index].foodCalories}" +
                                        " " +
                                        "\n" +
                                        "Used For:- " +
                                        "${firestoreController.foodList[index].Category}",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            );
                          }),
                    ),
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Calories Count"),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Favorites()));
        },
      ),
      // body: StreamBuilder(
      //     stream: food.where("Category", isEqualTo: "WeightGain").snapshots(),
      //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      //       if (streamSnapshot.hasData) {
      //         return GridView.builder(
      //           itemCount: streamSnapshot.data!.docs.length,
      //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //             crossAxisCount: 2,
      //             // childAspectRatio: 1.0,
      //             // crossAxisSpacing: 0.0,
      //             // mainAxisSpacing: 5,
      //             // mainAxisExtent: 150,
      //           ),
      //           itemBuilder: (context, index) {
      //             final DocumentSnapshot documentSnapshot =
      //                 streamSnapshot.data!.docs[index];

      //             return Card(
      //                 elevation: 0,
      //                 margin: const EdgeInsets.all(12),
      //                 child: Container(
      //                   child: Column(children: <Widget>[
      //                     FullScreenWidget(
      //                         child: Image(
      //                       height: 90,
      //                       width: 140,
      //                       image: NetworkImage(documentSnapshot['image']),
      //                     )),
      //                     Padding(
      //                       padding: const EdgeInsets.all(3.0),
      //                       child: Text(
      //                         'Name: ' + documentSnapshot['foodName'],
      //                         style: TextStyle(fontFamily: 'Montserrat'),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(2.0),
      //                       child: Text(
      //                         'Kcals: ' + documentSnapshot['foodCalories'],
      //                         style: TextStyle(
      //                             fontFamily: 'Montserrat', fontSize: 11),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(2.0),
      //                       child: Text(
      //                         'Carbs: ' + documentSnapshot['Carbs'],
      //                         style: TextStyle(
      //                             fontFamily: 'Montserrat', fontSize: 11),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.all(2.0),
      //                       child: Text(
      //                         'Volume(G/ML): ' + documentSnapshot['Volume'],
      //                         style: TextStyle(
      //                             fontFamily: 'Montserrat', fontSize: 11),
      //                       ),
      //                     ),

      //                   ]),
      //                 ));
      //           },
      //         );
      //       }
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
