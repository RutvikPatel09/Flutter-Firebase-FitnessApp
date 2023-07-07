import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:path/path.dart' as path;
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';

class showExercise extends StatefulWidget {
  final String categoryData;
  const showExercise({Key? key, required this.categoryData}) : super(key: key);

  @override
  State<showExercise> createState() => _showExerciseState();
}

class _showExerciseState extends State<showExercise> {
  late CollectionReference exercises =
      FirebaseFirestore.instance.collection('exercises');

  getData() async {
    var data = await exercises
        .where("Category", isEqualTo: widget.categoryData)
        .get()
        .then((value) => {
              value.docs.forEach((element) {
                print(element.data());
              })
            });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

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
            "Exercises",
            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(9, 26, 46, 1),
          child: StreamBuilder(
              stream: exercises
                  .where("Category", isEqualTo: widget.categoryData)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      // childAspectRatio: 1.0,
                      // crossAxisSpacing: 0.0,
                      // mainAxisSpacing: 5,
                      // mainAxisExtent: 150,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Card(
                          elevation: 0,
                          color: Color.fromRGBO(59, 72, 89, 1),
                          margin: const EdgeInsets.all(12),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color.fromRGBO(59, 72, 89, 1),
                            ),
                            child: Column(children: <Widget>[
                              FullScreenWidget(
                                  child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Image(
                                  height: 90,
                                  width: 140,
                                  image: NetworkImage(documentSnapshot['gif']),
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Category: ' + documentSnapshot['Category'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  'Exercise Name: ' +
                                      documentSnapshot['exerciseName'],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: Colors.white),
                                ),
                              ),
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
