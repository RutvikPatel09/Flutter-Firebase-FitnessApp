import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/OTPVerification/phone.dart';
import 'package:supreme_fitness/PhoneAuthentication.dart';
import 'package:supreme_fitness/Screens/UI/DashboardPage.dart';
import 'package:supreme_fitness/Screens/UI/HomePage.dart';
import 'package:supreme_fitness/adminHome.dart';
import 'package:supreme_fitness/forgotPassword.dart';
import 'package:supreme_fitness/healthyFood/filterData.dart';
import 'package:supreme_fitness/homescreen.dart';
import 'package:supreme_fitness/providers/userProvider.dart';
import 'package:supreme_fitness/register.dart';

import 'Email Verification/verifyEmail.dart';

class localLogin extends StatefulWidget {
  const localLogin({Key? key}) : super(key: key);

  @override
  _localLoginState createState() => _localLoginState();
}

class _localLoginState extends State<localLogin> {
  final GlobalKey<ScaffoldState> _mainScaffoldKey =
      new GlobalKey<ScaffoldState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  late UserProvider userProvider;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;

  //bool passwordVisible = false;
  //bool passenable = true;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;
  var finalEmail;

  @override
  void initState() {
    //getConnectivity();
    super.initState();
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
    subscription.cancel();
    super.dispose();
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
      ),
    ));
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  Future getValidationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var data = sharedPreferences.getString('Email');
    setState(() {
      finalEmail = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context);
    return WillPopScope(
        onWillPop: _onWillPop,
        child: ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: (Container(
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage('assets/images/enter.png'),
              //   ),
              // ),
              child: Scaffold(
                backgroundColor: Color.fromRGBO(9, 26, 46, 1),
                key: _mainScaffoldKey,
                body: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 90, top: 70),
                          child: const Text(
                            'Welcome\nBack',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 33),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 80.0, top: 3),
                          child: Container(
                            child: Image.asset("assets/images/enter.png",
                                height: 230, width: 230),
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 35, right: 35, top: 35),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 150.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Get.to(() => ForgotPassword(),
                                            transition: Transition.cupertino,
                                            duration: Duration(seconds: 1));
                                      },
                                      child: Text(
                                        'Forgot Password?',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Color.fromRGBO(255, 207, 96, 1),
                                        onPrimary:
                                            Color.fromRGBO(255, 207, 96, 1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    style: const TextStyle(color: Colors.white),
                                    controller: emailController,
                                    focusNode: focusEmail,
                                    cursorColor: Colors.yellow,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        fillColor:
                                            Color.fromRGBO(59, 72, 89, 1),
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        filled: true,
                                        hintText: "Email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextField(
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: true,
                                    focusNode: focusPassword,
                                    cursorColor: Colors.yellow,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      fillColor: Color.fromRGBO(59, 72, 89, 1),
                                      filled: true,
                                      hintText: "Password",
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      //           suffix: IconButton(onPressed: (){ //add Icon button at end of TextField
                                      //         setState(() { //refresh UI
                                      //             if(passenable){ //if passenable == true, make it false
                                      //                passenable = false;
                                      //             }else{
                                      //                passenable = true; //if passenable == false, make it true
                                      //             }
                                      //         });
                                      // }, icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password))
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: const Text(
                                          'Sign In',
                                          style: TextStyle(
                                              fontSize: 27,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      loading
                                          ? CircularProgressIndicator()
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Color.fromRGBO(
                                                  255, 207, 96, 1),
                                              child: IconButton(
                                                  color: Colors.white,
                                                  onPressed: () async {
                                                    setState(() {
                                                      loading = true;
                                                    });

                                                    // getValidationData()
                                                    //     .whenComplete(() async {
                                                    //   Timer(
                                                    //       Duration(seconds: 2),
                                                    //       () => Get.to(
                                                    //           finalEmail == null
                                                    //               ? localLogin()
                                                    //               : HomePage()));
                                                    // });

                                                    // if (data == null) {
                                                    //   print("No Data");
                                                    //   String message =
                                                    //       'No Data Found';
                                                    //   Fluttertoast.showToast(
                                                    //       msg: message,
                                                    //       fontSize: 18);
                                                    // } else {
                                                    //   Get.to(() => HomePage());
                                                    // }
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_forward,
                                                  )),
                                            )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))));
  }

  showDialogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("No Connection"),
            content: const Text("Please check your internet connection"),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() {
                      isAlertSet = false;
                    });
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;

                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() {
                        isAlertSet = true;
                      });
                    }
                  },
                  child: Text("OK"))
            ],
          ));
}
