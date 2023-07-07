import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:supreme_fitness/models/healthyFoodModel.dart';
import 'chipController.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FirestoreController extends GetxController {
  //referance to firestore collection here laptop is collection name
  final CollectionReference _foodRef =
      FirebaseFirestore.instance.collection('healthyFood');

  var foodList = <healthyFoodModel>[].obs;

  //dependency injection with getx
  ChipController _chipController = Get.put(ChipController());

  @override
  void onInit() {
    //binding to stream so that we can listen to realtime cahnges

    foodList.bindStream(
        getFoods(Foods.values[_chipController.selectedChip]));
    super.onInit();
  }

// this fuction retuns stream of laptop lsit from firestore

  Stream<List<healthyFoodModel>> getFoods(Foods food) {
    //using enum class LaptopBrand in switch case
    switch (food) {
      case Foods.ALL:
        Stream<QuerySnapshot> stream = _foodRef.snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return healthyFoodModel.fromDocumentSnapshot(snap);
            }).toList());
      case Foods.HighCarbs:
        Stream<QuerySnapshot> stream =
            _foodRef.where('Carbs', isGreaterThan: '20 G').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return healthyFoodModel.fromDocumentSnapshot(snap);
            }).toList());
      case Foods.WeightGain:
        Stream<QuerySnapshot> stream =
            _foodRef.where('Category', isEqualTo: 'WeightGain').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return healthyFoodModel.fromDocumentSnapshot(snap);
            }).toList());
      case Foods.WeightLoss:
        Stream<QuerySnapshot> stream =
            _foodRef.where('Category', isEqualTo: 'LossWeight').snapshots();
        return stream.map((snapshot) => snapshot.docs.map((snap) {
              return healthyFoodModel.fromDocumentSnapshot(snap);
            }).toList());
      

    }
  }
}