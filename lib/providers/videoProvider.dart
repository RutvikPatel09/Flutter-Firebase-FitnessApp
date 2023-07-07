import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class videoProvider with ChangeNotifier{
  void addVideo({String? videoName,String? videoUrl, String? timestamp}) async {
    await FirebaseFirestore.instance
        .collection("addExerciseVideos")
        .doc()
        .set({
          "videoName": videoName,
          "videoUrl": videoUrl,
          "timestamp": timestamp});
  }
}