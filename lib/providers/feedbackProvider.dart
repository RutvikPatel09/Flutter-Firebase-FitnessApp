import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class feedbackProvider with ChangeNotifier{
  void addFeedbackData(
      {String? FeedbackDesc, String? Timestamp}) async {
    await FirebaseFirestore.instance
        .collection("feedbackData")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "FeedbackDesc": FeedbackDesc,
      "Timestamp": Timestamp
    });
  }

}