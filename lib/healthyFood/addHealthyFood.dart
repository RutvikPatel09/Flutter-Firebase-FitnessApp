import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/providers/healthyFoodProvider.dart';

class addHealthyFood extends StatefulWidget {
  const addHealthyFood({super.key});

  @override
  State<addHealthyFood> createState() => _addHealthyFoodState();
}

class _addHealthyFoodState extends State<addHealthyFood> {
  final TextEditingController foodname = TextEditingController();
  final TextEditingController foodcalories = TextEditingController();
  final TextEditingController foodcarbs = TextEditingController();
  final TextEditingController foodvolume = TextEditingController();
  var selectedType;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("healthyFood");

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = path.basename(_photo!.path);
    final destination = 'foodImages/$fileName';
    String url;
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      url = await ref.getDownloadURL();
      final String foodName = foodname.text;
      final String foodCalories = foodcalories.text;
      final String foodCarbs = foodcarbs.text;
      final String foodVolume = foodvolume.text;
      final String image = url;
      final String Category = selectedType.toString();
      DateTime currentDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
      DateTime myDateTime = myTimeStamp.toDate();
      if (foodName.isEmpty) {
        var snackbar = const SnackBar(content: Text('Food Name is empty!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pop();
      } else {
        healthyFoodProvider provider = Provider.of(context, listen: false);

        provider.addHealthyFood(
            foodName: foodName,
            foodCalories: foodCalories,
            Carbs: foodCarbs,
            Volume: foodVolume,
            image: image,
            Category: Category,
            timestamp: myDateTime.toString());
        var snackbar =
            const SnackBar(content: Text('Food Added Successfully...'));
        foodname.text = '';
        foodcalories.text = '';
        foodcarbs.text = '';
        foodvolume.text = '';
        //gif.text = '';
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pop();
      }
      //return destination;
    } catch (e) {
      print('error occured');
    }
  }

  List<String> category = [
    "WeightGain",
    "LossWeight",
  ];

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    // QuerySnapshot querySnapshot1 = await collectionReference.get();
    // final CategoryData =
    //     querySnapshot1.docs.map((data) => data['categoryName']).toList();

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return StatefulBuilder(
              builder: (BuildContext ctx, StateSetter state) {
            return Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    items: category
                        .map((value) => DropdownMenuItem(
                              child: Text(value),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (selectedValue) {
                      state(() {
                        selectedType = selectedValue;
                      });
                    },
                    value: selectedType,
                    isExpanded: false,
                    hint: Text("Choose Category"),
                  ),
                  TextFormField(
                    controller: foodname,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Food Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter FoodName";
                      } else {
                        null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: foodcalories,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Food Calories"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter FoodCalories";
                      } else {
                        null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: foodcarbs,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Food Carbs"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter FoodCarbs";
                      } else {
                        null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: foodvolume,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: "Food Volume(G/ML)"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Volume";
                      } else {
                        null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(ctx);
                      },
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: _photo != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _photo!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(50)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Color(0xff4c505b)),
                    child: const Text('Send'),
                    onPressed: () {
                      String foodName = foodname.text;
                      var foodCalories = foodcalories.text;
                      String foodCarbs = foodcarbs.text;
                      String foodVolume = foodvolume.text;

                      if (foodName.isEmpty) {
                        final message = 'Enter Food Name';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else if (foodCalories.toString().isEmpty) {
                        final message = 'Enter Food Calories';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else if (foodCarbs.isEmpty) {
                        final message = 'Enter Food Carbs';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else if (foodVolume.isEmpty) {
                        final message = 'Enter Food Volume';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else if (selectedType == null) {
                        final message = 'Select Food Category';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else {
                        uploadFile();
                      }
                    },
                  )
                ],
              ),
            );
          });
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      foodname.text = documentSnapshot['foodName'];
      foodcalories.text = documentSnapshot['foodCalories'];
      foodcarbs.text = documentSnapshot['Carbs'];
      foodvolume.text = documentSnapshot['Volume'];
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
                  controller: foodname,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: foodcalories,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Calories'),
                ),
                TextField(
                  controller: foodcarbs,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Carbs'),
                ),
                TextField(
                  controller: foodvolume,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Volume'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = foodname.text;
                    final String calories = foodcalories.text;
                    final String carbs = foodcarbs.text;
                    final String volume = foodvolume.text;
                    if (name != null) {
                      await collectionReference
                          .doc(documentSnapshot!.id)
                          .update({
                        "foodName": name,
                        "foodCalories": calories,
                        "Carbs": carbs,
                        "Volume": volume
                      });
                      foodname.text = '';
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
    await collectionReference.doc(Id).delete();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have successfully deleted a Food')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Add Healthy Food",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
        ),
        body: StreamBuilder(
            stream: collectionReference.snapshots(),
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
                            FullScreenWidget(
                                child: Image(
                              height: 90,
                              width: 140,
                              image: NetworkImage(documentSnapshot['image']),
                            )),
                            Text("Name:- " + documentSnapshot['foodName']),
                            Text("Kcal:- " + documentSnapshot["foodCalories"]),
                            Text("Carbs:- " + documentSnapshot["Carbs"]),
                            Text("Volume:- " + documentSnapshot["Volume"]),

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, left: 40.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    onPressed: () => _update(documentSnapshot),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, left: 2.0),
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
                                                    "Are You Sure You Want to Delete the Food?"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("NO")),
                                                  TextButton(
                                                      onPressed: () {
                                                        _delete(documentSnapshot
                                                            .id);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("YES"))
                                                ],
                                              ),
                                            );
                                          })),
                                )
                              ],
                            )
                            //Text("" + documentSnapshot['foodCarbs']),
                            //Text("" + documentSnapshot['foodVolume']),
                            // ListTile(
                            //   title: SizedBox(
                            //       child: Column(children: [
                            //     Padding(
                            //       padding: const EdgeInsets.only(top: 8.0),
                            //       child: Text(
                            //         documentSnapshot['foodName'],
                            //         style: TextStyle(
                            //             fontSize: 13,
                            //             fontWeight: FontWeight.bold),
                            //       ),
                            //     ),
                            //     Text(
                            //       documentSnapshot["foodCalories"],
                            //       style: TextStyle(fontSize: 13),
                            //     ),
                            //     Text(
                            //       documentSnapshot["Carbs"],
                            //       style: TextStyle(fontSize: 13),
                            //     ),
                            //     Text(
                            //       documentSnapshot["Volume"],
                            //       style: TextStyle(fontSize: 13),
                            //     ),
                            //   ])),
                            //   trailing: SizedBox(
                            //     width: 100,
                            //     child: Row(children: [
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 2.0),
                            //         child: IconButton(
                            //           icon: const Icon(
                            //             Icons.edit,
                            //             size: 20,
                            //           ),
                            //           onPressed: () =>
                            //               _update(documentSnapshot),
                            //         ),
                            //       ),
                            //       Padding(
                            //         padding: const EdgeInsets.only(left: 2.0),
                            //         child: IconButton(
                            //             icon: const Icon(
                            //               Icons.delete,
                            //               size: 20,
                            //             ),
                            //             onPressed: () => showDialog(
                            //                 context: context,
                            //                 builder: (context) {
                            //                   return Container(
                            //                     child: AlertDialog(
                            //                       title: Text(
                            //                           "Are You Sure You Want to Delete the Food?"),
                            //                       actions: [
                            //                         TextButton(
                            //                             onPressed: () {
                            //                               Navigator.pop(
                            //                                   context);
                            //                             },
                            //                             child: Text("NO")),
                            //                         TextButton(
                            //                             onPressed: () {
                            //                               _delete(
                            //                                   documentSnapshot
                            //                                       .id);
                            //                               Navigator.pop(
                            //                                   context);
                            //                             },
                            //                             child: Text("YES"))
                            //                       ],
                            //                     ),
                            //                   );
                            //                 })),
                            //       )
                            //     ]),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
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

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
