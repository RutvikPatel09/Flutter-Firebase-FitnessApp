import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/Email%20Verification/verifyEmail.dart';
import 'package:supreme_fitness/Screens/UI/HomePage.dart';
import 'package:supreme_fitness/localLogin.dart';
import 'package:supreme_fitness/localRegister.dart';
import 'package:supreme_fitness/login.dart';

class testPage extends StatefulWidget {
  const testPage({super.key});

  @override
  State<testPage> createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  var getEmail;
  
  @override
  void initState() {
    if (isAlertSet == true) {
      getValidationData().whenComplete(() async {
        Timer(Duration(seconds: 3),
            () => Get.to(getEmail == null ? localRegister() : HomePage()));
      });
    } else {
      // StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       Get.to(() => const VerifyEmail());
      //     }
      //     Get.to(() => const MyLogin());

      //   },
      // );
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          print("User is currently signed out!!");
          Timer(Duration(seconds: 3), () =>
          Get.to(() => MyLogin()));
        } else {
          print("User is signed in");
          Timer(Duration(seconds: 3), () =>
          Get.to(() => VerifyEmail()));
        }
      });
    }
    super.initState();
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var Email = sharedPreferences.getString('Email');

    setState(() {
      getEmail = Email;
    });
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            //showDialogBox();
            setState(() {
              isAlertSet = true;
              //print(isAlertSet);
            });
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        "Test Page",
        style: TextStyle(fontSize: 30),
      )),
    );
  }
}
