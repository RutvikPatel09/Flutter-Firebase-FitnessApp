import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/OTPVerification/phone.dart';
import 'package:supreme_fitness/PhoneAuthentication.dart';
import 'package:supreme_fitness/Screens/UI/DashboardPage.dart';
import 'package:supreme_fitness/Screens/UI/HomePage.dart';
import 'package:supreme_fitness/adminHome.dart';
import 'package:supreme_fitness/forgotPassword.dart';
import 'package:supreme_fitness/homescreen.dart';
import 'package:supreme_fitness/providers/userProvider.dart';
import 'package:supreme_fitness/register.dart';

import 'Email Verification/verifyEmail.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
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

  String userEmail = "";

  //bool passwordVisible = false;
  //bool passenable = true;

  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

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

  void route() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? useruser;

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);

    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('userRole') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const adminHome(),
            ),
          );
        } else if (documentSnapshot.get('userRole') == "normalUser") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyEmail(),
            ),
          );
        } else {
          print("Document doesn't exist!!!");
        }
      }
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

 
  Future<User?> googleSignUp() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      setState(() {
        loading = true;
      });
      final User? user = (await _auth.signInWithCredential(credential)).user;
      // print("signed in " + user.displayName);
      userProvider.addUserData(
        currentuser: user,
        //userName: user!.displayName,
        userEmail: user!.email,
        userImage: user.photoURL
      );
      setState(() {
        loading = false;
      });
      Get.to(() => HomePage(),
          transition: Transition.cupertino, duration: Duration(seconds: 1));
      return user;
    } catch (e) {
      //print(e.message);
    }
  }

  // static Future<User?> login(
  //     {required String email,
  //     required String password,
  //     required BuildContext context}) async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;
  //   try {
  //     UserCredential userCredential = await auth.signInWithEmailAndPassword(
  //         email: email, password: password);
  //     user = userCredential.user;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == "user-not-found") {
  //       print("No User found for this email");
  //     }
  //   }
  //   return user;
  // }

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

                                                    FirebaseAuth auth =
                                                        FirebaseAuth.instance;
                                                    User? user;
                                                    String email =
                                                        emailController.text;
                                                    String password =
                                                        passwordController.text;
                                                    if (email.isEmpty ||
                                                        !RegExp("^[a-zA-z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]")
                                                            .hasMatch(email)) {
                                                      final message =
                                                          'Please Enter Correct Email';
                                                      Fluttertoast.showToast(
                                                          msg: message,
                                                          fontSize: 18);
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    } else if (password
                                                        .isEmpty) {
                                                      final message =
                                                          'Please Enter Password';
                                                      Fluttertoast.showToast(
                                                          msg: message,
                                                          fontSize: 18);
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    } else {
                                                      try {
                                                        UserCredential
                                                            userCredential =
                                                            await auth.signInWithEmailAndPassword(
                                                                email:
                                                                    emailController
                                                                        .text,
                                                                password:
                                                                    passwordController
                                                                        .text);

                                                        route();
                                                        // user = userCredential.user;
                                                        // Navigator.of(context)
                                                        //     .pushReplacement(
                                                        //         MaterialPageRoute(
                                                        //             builder: (context) =>
                                                        //                 const HomeScreen()));
                                                      } on FirebaseAuthException catch (e) {
                                                        if (e.code ==
                                                            "user-not-found") {
                                                          //print("No User found for this email");
                                                          showSnack(
                                                              'No User found for this email');
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                        }
                                                      }
                                                    }
                                                    setState(() {
                                                      loading = false;
                                                    });
                                                    // User? user = await login(
                                                    //     email: emailController.text,
                                                    //     password: passwordController.text,
                                                    //     context: context);
                                                    // print(user);
                                                    // String email = emailController.text;
                                                    // String password =
                                                    //     passwordController.text;
                                                    // if (email.isEmpty ||
                                                    //     !RegExp("^[a-zA-z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]")
                                                    //         .hasMatch(email)) {
                                                    //   showSnack(
                                                    //       'Please Enter Correct Email!!!');
                                                    //   FocusScope.of(context)
                                                    //       .requestFocus(FocusNode());
                                                    // } else if (password.isEmpty) {
                                                    //   showSnack('Please Enter Password!!!');
                                                    //   FocusScope.of(context)
                                                    //       .requestFocus(FocusNode());
                                                    // } else {
                                                    //   Navigator.of(context).pushReplacement(
                                                    //       MaterialPageRoute(
                                                    //           builder: (context) =>
                                                    //               const HomeScreen()));
                                                    // }
                                                  },
                                                  icon: const Icon(
                                                    Icons.arrow_forward,
                                                  )),
                                            )
                                    ],
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(right: 170.0),
                                  //   child: TextButton(
                                  //       onPressed: () {
                                  //         Navigator.pushReplacement(
                                  //             context,
                                  //             MaterialPageRoute(
                                  //                 builder: (context) =>
                                  //                     const ForgotPassword()));
                                  //       },
                                  //       child: const Text(
                                  //         'Forgot Password',
                                  //         style: TextStyle(

                                  //           color: Colors.white,
                                  //           backgroundColor: Color(0xff4c505b),
                                  //           fontSize: 17,
                                  //         ),
                                  //       )),
                                  // ),

                                  const SizedBox(
                                    height: 40,
                                  ),
                                  // if(loading)...[
                                  //   const SizedBox(height:15),
                                  //   const Center(child: const CircularProgressIndicator())
                                  // ],
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Tooltip(
                                          message: 'SignIn With Google',
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, right: 20.0),
                                            child: loading
                                                ? CircularProgressIndicator()
                                                : GestureDetector(
                                                    onTap: () => googleSignUp(),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Color.fromRGBO(
                                                            255, 207, 96, 1),
                                                      ),
                                                      child: new Icon(
                                                        FontAwesomeIcons.google,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: 'SignIn With Facebook',
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, right: 20.0),
                                            child: GestureDetector(
                                              onTap: () {},
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(
                                                      255, 207, 96, 1),
                                                ),
                                                child: new Icon(
                                                  FontAwesomeIcons.facebook,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: 'SignIn With Phone',
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 10.0, right: 20.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                    () => PhoneAuthentication(),
                                                    transition:
                                                        Transition.cupertino,
                                                    duration:
                                                        Duration(seconds: 1));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(
                                                      255, 207, 96, 1),
                                                ),
                                                child: new Icon(
                                                  FontAwesomeIcons.phone,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tooltip(
                                          message: 'SignIn With Email-Password',
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(() => MyRegister(),
                                                    transition:
                                                        Transition.cupertino,
                                                    duration:
                                                        Duration(seconds: 1));
                                                // Navigator.pushReplacement(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             MyRegister()));
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromRGBO(
                                                      255, 207, 96, 1),
                                                ),
                                                child: new Icon(
                                                  FontAwesomeIcons.userPlus,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     TextButton(
                                  //         onPressed: () {
                                  //           Navigator.pushReplacement(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                   builder: (context) =>
                                  //                       const ForgotPassword()));
                                  //         },
                                  //         child: const Text(
                                  //           'Forgot Password',
                                  //           style: TextStyle(
                                  //             decoration:
                                  //                 TextDecoration.underline,
                                  //             color: Color(0xff4c505b),
                                  //             fontSize: 18,
                                  //           ),
                                  //         )),
                                  //   ],
                                  // )
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
