import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Search/search.dart';

class WeightLossFood extends StatefulWidget {
  const WeightLossFood({super.key});

  @override
  State<WeightLossFood> createState() => _WeightLossFoodState();
}

class _WeightLossFoodState extends State<WeightLossFood> {
  @override
  Widget build(BuildContext context) {
    late CollectionReference food =
        FirebaseFirestore.instance.collection('healthyFood');

    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Weight Loss Food",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
          actions: <Widget>[
            new IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
                },
                highlightColor: Colors.green,
                icon: new Icon(Icons.search))
          ],
        ),
        body: StreamBuilder(
            stream: food.where("Category", isEqualTo: "LossWeight").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return GridView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        margin: const EdgeInsets.all(12),
                        child: Container(
                          child: Column(children: <Widget>[
                            FullScreenWidget(
                                child: Image(
                              height: 90,
                              width: 140,
                              image: NetworkImage(documentSnapshot['image']),
                            )),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Text(
                                'Name: ' + documentSnapshot['foodName'],
                                style: TextStyle(fontFamily: 'Montserrat'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Kcals: ' + documentSnapshot['foodCalories'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Carbs: ' + documentSnapshot['Carbs'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Volume(G/ML): ' + documentSnapshot['Volume'],
                                style: TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 11),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
