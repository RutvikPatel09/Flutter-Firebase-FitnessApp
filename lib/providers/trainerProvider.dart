import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class trainerProvider with ChangeNotifier{
   void addTrainer({String? trainerName,String? Phone, String? Code, String? Email}) async {
    await FirebaseFirestore.instance
        .collection("addTrainer")
        .doc()
        .set({
          "trainerName": trainerName,
          "Phone": Phone,
          "Code": Code,
          "Email": Email,});
  }
}