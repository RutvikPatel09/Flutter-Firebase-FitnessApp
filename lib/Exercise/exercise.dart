import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Exercise/showExercise.dart';
import 'package:supreme_fitness/providers/exerciseProvider.dart';

class Exercise extends StatefulWidget {
  const Exercise({super.key});

  @override
  State<Exercise> createState() => _ExerciseState();
}

class _ExerciseState extends State<Exercise> {
  final TextEditingController exercisename = TextEditingController();
  var selectedType;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("category");

  CollectionReference exercises =
      FirebaseFirestore.instance.collection("exercises");

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
    final destination = 'exerciseImages/$fileName';
    String url;
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      url = await ref.getDownloadURL();
      final String exerciseName = exercisename.text;
      final String Gif = url;
      final String Category = selectedType.toString();
      DateTime currentDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
      DateTime myDateTime = myTimeStamp.toDate();
      if (exerciseName.isEmpty) {
        var snackbar =
            const SnackBar(content: Text('Exercise Name is empty!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pop();
      } else {
        exerciseProvider provider = Provider.of(context, listen: false);

        provider.addExercise(
            exerciseName: exerciseName,
            gif: Gif,
            Category: Category,
            timestamp: myDateTime.toString());
        var snackbar =
            const SnackBar(content: Text('Exercise Added Successfully...'));
        exercisename.text = '';
        //gif.text = '';
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pop();
      }
      //return destination;
    } catch (e) {
      print('error occured');
    }
  }

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
    QuerySnapshot querySnapshot1 = await collectionReference.get();
    final CategoryData =
        querySnapshot1.docs.map((data) => data['categoryName']).toList();

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
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButton(
                    items: CategoryData.map((value) => DropdownMenuItem(
                          child: Text(value),
                          value: value,
                        )).toList(),
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
                    controller: exercisename,
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "Exercise Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Exercise Name";
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
                        _showPicker(context);
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
                      String exerciseName = exercisename.text;

                      if (exerciseName.isEmpty) {
                        final message = 'Enter Exercise Name';
                        Fluttertoast.showToast(msg: message, fontSize: 18);
                      } else if (selectedType == null) {
                        final message = 'Select Exercise Category';
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
      exercisename.text = documentSnapshot['exerciseName'];
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
                  controller: exercisename,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = exercisename.text;
                    if (name != null) {
                      await exercises
                          .doc(documentSnapshot!.id)
                          .update({"exerciseName": name});
                      exercisename.text = '';
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
    await exercises.doc(Id).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a Exercise')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Manage Exercise",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
        ),
        body: StreamBuilder(
            stream: exercises.snapshots(),
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
                              height: 110,
                              width: 140,
                              image: NetworkImage(documentSnapshot['gif']),
                            )),
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     image: DecorationImage(
                            //         fit: BoxFit.cover,
                            //         image: AssetImage(categoryImages[index]))),
                            Text("Name:- " + documentSnapshot['exerciseName']),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 35.0),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                    ),
                                    onPressed: () => _update(documentSnapshot),
                                    //print("object")
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
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
                                                    "Are You Sure You Want to Delete the Exercise?"),
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
                            // ListTile(
                            //   title: SizedBox(
                            //       width: 25,
                            //       child: Text(
                            //         documentSnapshot['exerciseName'],
                            //         style: TextStyle(
                            //             fontSize: 13,
                            //             fontWeight: FontWeight.bold),
                            //       )),
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
                            //           //print("object")
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
                            //                           "Are You Sure You Want to Delete the Exercise?"),
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
