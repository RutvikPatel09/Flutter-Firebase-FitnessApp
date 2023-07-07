import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Exercise/showExercise.dart';

class showCategory extends StatefulWidget {
  const showCategory({super.key});

  @override
  State<showCategory> createState() => _showCategoryState();
}

class _showCategoryState extends State<showCategory> {
  late CollectionReference exercises =
      FirebaseFirestore.instance.collection('category');

  List<String> categoryImages = [
    "assets/images/Category/yoga.png",
    "assets/images/Category/back.png",
    "assets/images/Category/bicep.png",
    "assets/images/Category/cardio.png",
    "assets/images/Category/chest.png",
    "assets/images/Category/leg.png",
    "assets/images/Category/shoulder.png",
    "assets/images/Category/tricep.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: Color.fromRGBO(9, 26, 46, 1),
          shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(1),
          title: const Text(
            "Categories",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(9, 26, 46, 1),
          child: StreamBuilder(
              stream: exercises.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Card(
                          color: Color.fromRGBO(59, 72, 89, 1),
                          elevation: 0,
                          margin: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(59, 72, 89, 1),
                            ),
                            child: Column(children: <Widget>[
                              FullScreenWidget(
                                  child: Image(
                                height: 120,
                                width: 140,
                                image: AssetImage(categoryImages[index]),
                              )),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Category: ' +
                                      documentSnapshot['categoryName'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: Colors.white),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => showExercise(
                                          categoryData:
                                              documentSnapshot['categoryName']),
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "View Exercises",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                          ));
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
