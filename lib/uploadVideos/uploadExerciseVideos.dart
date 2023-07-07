import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/providers/videoProvider.dart';
import 'package:video_player/video_player.dart';
import 'package:supreme_fitness/uploadVideos/listItem.dart';

class uploadExerciseVideos extends StatefulWidget {
  const uploadExerciseVideos({super.key});

  @override
  State<uploadExerciseVideos> createState() => _uploadExerciseVideosState();
}

class _uploadExerciseVideosState extends State<uploadExerciseVideos> {
  final TextEditingController videoname = TextEditingController();
  File? _video;
  final ImagePicker _picker = ImagePicker();
  late Timer _timer;

  CollectionReference videos =
      FirebaseFirestore.instance.collection("addExerciseVideos");

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // void getData() async {
  //   QuerySnapshot querySnapshot = await videos.get();

  //   final videoName = querySnapshot.docs.map((e) => e['videoName']);

  //   String videoNameToString = videoName.join();

  //   print("Hello, This is video name:- " + videoNameToString);
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }
  // @override
  // void initState() {
  //   super.initState();
  //   EasyLoading.addStatusCallback((status) {
  //     print('EasyLoading Status $status');
  //     if (status == EasyLoadingStatus.dismiss) {
  //       _timer.cancel();
  //     }
  //   });
  //   EasyLoading.showSuccess('Use in initState');
  //   // EasyLoading.removeCallbacks();
  // }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _video = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_video == null) return;
    final fileName = path.basename(_video!.path);
    final destination = 'exerciseVideos/$fileName';
    String url;

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_video!);
      url = await ref.getDownloadURL();

      final String videoName = videoname.text;
      final String videoUrl = url;
      DateTime currentDate = DateTime.now();
      Timestamp myTimeStamp = Timestamp.fromDate(currentDate);
      DateTime myDateTime = myTimeStamp.toDate();
      if (videoName.isEmpty) {
        var snackbar = const SnackBar(content: Text('Video Name is empty!!!'));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pop();
      } else {
        videoProvider provider = Provider.of(context, listen: false);

        provider.addVideo(
            videoName: videoName,
            videoUrl: videoUrl,
            timestamp: myDateTime.toString());
        EasyLoading.showSuccess("Success");

        var snackbar =
            const SnackBar(content: Text('Video Added Successfully...'));
        videoname.text = '';
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        //Navigator.of(context).pop();
      }
    } catch (e) {
      print('error occured');
    }
  }

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
                TextFormField(
                  controller: videoname,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Video Name"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Video Name";
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
                      child: _video != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.file(
                                _video!,
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
                // const SizedBox(
                //   height: 20,
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff4c505b)),
                  child: const Text('Send'),
                  onPressed: () {
                    //EasyLoading.show(status: "Wait While Uploading Video....");
                    String videoName = videoname.text;
                    if (videoName.isEmpty) {
                      final message = 'Enter Video Name';
                      Fluttertoast.showToast(msg: message, fontSize: 18);
                    } else {
                      uploadFile();
                    }
                    //EasyLoading.showSuccess("status");
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: dashboardColors[10],
          shadowColor: dashboardColors[10].withAlpha(0),
          title: const Text(
            "Manage Videos",
            style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
          ),
        ),
        body: StreamBuilder(
            stream: videos.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                // return GridView.builder(
                //   itemCount: streamSnapshot.data!.docs.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     // childAspectRatio: 1.0,
                //     // crossAxisSpacing: 0.0,
                //     // mainAxisSpacing: 5,
                //     // mainAxisExtent: 150,
                //   ),
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];

                      return Column(children: [
                        Container(
                          width: 410,
                          height: 230,
                          child: listItem(
                            videoPlayerController:
                                VideoPlayerController.network(
                              documentSnapshot['videoUrl'],
                            ),
                            looping: true,
                          ),
                        ),
                        Text(
                          "" + documentSnapshot['videoName'],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                      ]);
                    });

                //);
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
