import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/UI/HomePage.dart';
import '../localRegister.dart';

class SplashScreen extends StatefulWidget {
  int duration = 0;
  Widget gotoPage;

  SplashScreen({super.key, required this.gotoPage, required this.duration});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    if (getConnectivity() == true) {
      print("True");
    } else {
      getValidatiorData().whenComplete(() async {
        Timer(Duration(seconds: 3),
            () => Get.to(getEmail == null ? localRegister() : HomePage()));
      });
    }
    
  }

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

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            //showDialogBox();
            setState(() {
              isAlertSet = true;
            });
          }
        },
      );


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: this.widget.duration), () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => this.widget.gotoPage));
    });
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      body: getConnectivity() == true ?
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.network(
              'https://assets3.lottiefiles.com/packages/lf20_oncjxjbd.json',
              controller: _controller, onLoaded: (compose) {
            _controller
              ..duration = compose.duration
              ..forward().then((value) => {}
                  // .then((value) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => const SplashScreen2()));
                  // }
                  );
          }),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(
              'Supreme Fitness',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          )),
        ],
      ): Container(
        child:Text("Wait")
      )
    );
  }
}
