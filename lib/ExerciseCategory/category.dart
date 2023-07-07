import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/providers/categoryProvider.dart';

import '../Exercise/showExercise.dart';

class ExerciseCategory extends StatefulWidget {
  const ExerciseCategory({super.key});

  @override
  State<ExerciseCategory> createState() => _ExerciseCategoryState();
}

class _ExerciseCategoryState extends State<ExerciseCategory> {
  final TextEditingController categoryName = TextEditingController();

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

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: categoryName,
                  decoration: const InputDecoration(labelText: "Category Name"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(primary: Color(0xff4c505b)),
                  onPressed: () {
                    final String category = categoryName.text;
                    DateTime currentDate = DateTime.now();
                    Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
                    DateTime myDateTime = myTimeStamp.toDate();
                    print(myDateTime);
                    if (category.isEmpty) {
                      var snackbar = SnackBar(
                          content: Text('Enter Category Name to Submit!!!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.of(context).pop();
                    } else {
                      categoryProvider provider =
                          Provider.of(context, listen: false);
                      // UserProvider userProvider = Provider.of(context);

                      provider.addCategory(
                          categoryName: category,
                          timestamp: myDateTime.toString());

                      var snackbar = SnackBar(
                          content: Text('Category Added Successfully...'));
                      categoryName.text = '';
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      categoryName.text = documentSnapshot['categoryName'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: categoryName,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = categoryName.text;
                    if (name != null) {
                      await categories
                          .doc(documentSnapshot!.id)
                          .update({"categoryName": name});
                      categoryName.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String Id) async {
    await categories.doc(Id).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Category')));
  }

  late categoryProvider provider;

  final CollectionReference categories =
      FirebaseFirestore.instance.collection('category');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: categories.snapshots(),
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

                    return SingleChildScrollView(
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            Image(
                                image: AssetImage(categoryImages[index]),
                                height: 130,
                                width: 165),

                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     image: DecorationImage(
                            //         fit: BoxFit.cover,
                            //         image: AssetImage(categoryImages[index]))),
                            ListTile(
                              title: SizedBox(
                                  child: Text(
                                documentSnapshot['categoryName'],
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold),
                              )),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                      onPressed: () =>
                                          _update(documentSnapshot),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 20,
                                        ),
                                        onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                child: AlertDialog(
                                                  title: Text(
                                                      "Are You Sure You Want to Delete the Category?"),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("NO")),
                                                    TextButton(
                                                        onPressed: () {
                                                          _delete(
                                                              documentSnapshot
                                                                  .id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("YES"))
                                                  ],
                                                ),
                                              );
                                            })),
                                  )
                                ]),
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 38.0, bottom: 100),
                            //   child: ButtonBar(
                            //     children: [
                            //       IconButton(
                            //         icon: const Icon(Icons.edit),
                            //         onPressed: () => _update(documentSnapshot),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );

                    // return Card(
                    //     elevation: 0,
                    //     margin: const EdgeInsets.all(12),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(10.0),
                    //           image: DecorationImage(
                    //               fit: BoxFit.cover,
                    //               image: AssetImage(categoryImages[index]))),
                    //           child: ListTile(
                    //             title: Text(
                    //               documentSnapshot['categoryName'],
                    //               textAlign: TextAlign.center,
                    //               style: TextStyle(fontSize: 12),
                    //             ),
                    //             trailing: SizedBox(
                    //               width: 100,
                    //               child: Row(
                    //                 children: [

                    //                   IconButton(
                    //                     icon: const Icon(Icons.edit),
                    //                     onPressed: () => _update(documentSnapshot),
                    //                   ),
                    //                   IconButton(
                    //                       icon: const Icon(Icons.delete),
                    //                       onPressed: () => showDialog(
                    //                           context: context,
                    //                           builder: (context) {
                    //                             return Container(
                    //                               child: AlertDialog(
                    //                                 title: Text(
                    //                                     "Are You Sure You Want to Delete the Category?"),
                    //                                 actions: [
                    //                                   TextButton(
                    //                                       onPressed: () {
                    //                                         Navigator.pop(context);
                    //                                       },
                    //                                       child: Text("NO")),
                    //                                   TextButton(
                    //                                       onPressed: () {
                    //                                         _delete(documentSnapshot
                    //                                             .id);
                    //                                         Navigator.pop(context);
                    //                                       },
                    //                                       child: Text("YES"))
                    //                                 ],
                    //                               ),
                    //                             );
                    //                           }))
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),

                    //       // Padding(
                    //       //   padding: const EdgeInsets.all(10.0),
                    //       //   child: GestureDetector(
                    //       //     onTap: () {
                    //       //       Navigator.push(
                    //       //           context,
                    //       //           MaterialPageRoute(
                    //       //               builder: (context) => showExercise(
                    //       //                   categoryData: documentSnapshot[
                    //       //                       'categoryName'])));
                    //       //     },
                    //       //     child: Text(
                    //       //       documentSnapshot['categoryName'],
                    //       //       style: TextStyle(fontFamily: 'Montserrat'),
                    //       //     ),
                    //       //   ),
                    //       // ),
                    //       );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          backgroundColor: Color(0xff4c505b),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
