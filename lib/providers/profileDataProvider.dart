import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:supreme_fitness/models/profileDataModel.dart';

class profileDataProvider with ChangeNotifier{

  final _auth = FirebaseAuth.instance;
 
  void subCollection(
      {User? currentuser,
      String? userName,
      String? userSurname,
      String? userPhone}) async {
    CollectionReference users = FirebaseFirestore.instance.collection("users");
    var uid = _auth.currentUser?.uid;

    users.doc(uid).collection("profileData").add({
      "userName": userName,
      "userSurname": userSurname,
      "userPhone": userPhone
    });
  }
  
  late profileData currentData;
  void getUserData() async {
    List<profileData> newdata = [];
    profileData profileModel;
    var uid = _auth.currentUser?.uid;

    var value = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("profileData")
        .doc(uid)
        .get();

    if (value.exists) {
      profileModel = profileData(
        Name: value.get("userName"),
        Surname: value.get("userSurname"),
        Phone: value.get("userPhone")
      );
      currentData = profileModel;
      data = newdata;
      notifyListeners();
    }
  }

  profileData get currentUserData {
    return currentData;
  }


  List<profileData> data = [];

  List<profileData> get getUserDataList {
    return data;
  }

}