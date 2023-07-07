import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Email Verification/verifyEmail.dart';
import '../Screens/UI/HomePage.dart';
import '../localRegister.dart';
import '../login.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> {
  bool Animate = false;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  var getEmail;

  Future getValidatiorData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var Email = sharedPreferences.getString('Email');

    setState(() {
      getEmail = Email;
    });
  }

  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          print("Turn off the data and repress again");
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user == null) {
              Timer(Duration(seconds: 3), () => {Get.to(() => MyLogin())});
            } else {
              Timer(Duration(seconds: 3), () => {Get.to(() => VerifyEmail())});
            }
          });
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        print("Turn On the data and repress again");
        getValidatiorData().whenComplete(() async {
          Timer(Duration(seconds: 3),
              () => Get.to(getEmail == null ? localRegister() : HomePage()));
        });
      });
    }
  }

  // getConnectivity() {
  //   subscription = Connectivity().onConnectivityChanged.listen(
  //     (ConnectivityResult result) async {
  //       isDeviceConnected = await InternetConnectionChecker().hasConnection;
  //       if (!isDeviceConnected && isAlertSet == false) {
  //         //showDialogBox();
  //         setState(() {
  //           isAlertSet = true;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    startAnimation();
    CheckUserConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      body: Stack(
        children: [
          AnimatedPositioned(
              top: 110,
              duration: Duration(milliseconds: 1600),
              left: Animate ? 45 : -80,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1600),
                opacity: Animate ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Supreme Fitness",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              )),
          AnimatedPositioned(
              duration: Duration(milliseconds: 2400),
              bottom: Animate ? 220 : 0,
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 2000),
                  opacity: Animate ? 1 : 0,
                  child: Image(
                    image: AssetImage('assets/Splash.png'),
                    height: 350,
                    width: 380,
                  ))),
          AnimatedPositioned(
              bottom: 110,
              duration: Duration(milliseconds: 1600),
              right: Animate ? 100 : -80,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 1600),
                opacity: Animate ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Get In, Get Fit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: 'Montserrat'),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      Animate = true;
    });
    await Future.delayed(Duration(milliseconds: 5000));
  }
}
