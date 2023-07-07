import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/adminHome.dart';
import 'package:supreme_fitness/forgotPassword.dart';
import 'package:supreme_fitness/homescreen.dart';
import 'package:supreme_fitness/providers/userProvider.dart';
import 'package:supreme_fitness/register.dart';
import 'package:supreme_fitness/trainerDashboard/trainerDashboard.dart';

class trainerLogin extends StatefulWidget {
  const trainerLogin({Key? key}) : super(key: key);

  @override
  _trainerLoginState createState() => _trainerLoginState();
}

class _trainerLoginState extends State<trainerLogin> {
  final GlobalKey<ScaffoldState> _mainScaffoldKey =
      new GlobalKey<ScaffoldState>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("addTrainer");

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionReference.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    final email = querySnapshot.docs.map((e) => e['Email']).toList();

    print(allData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getData();
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
    return WillPopScope(
        onWillPop: _onWillPop,
        child: ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: (Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/login.png'),
                    fit: BoxFit.cover),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                key: _mainScaffoldKey,
                body: Stack(
                  children: [
                    Container(),
                    Container(
                      padding: const EdgeInsets.only(left: 35, top: 145),
                      child: const Text(
                        'Welcome\nBack',
                        style: TextStyle(color: Colors.white, fontSize: 33),
                      ),
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
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForgotPassword()));
                                      },
                                      child: Text('Forgot Password?'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xff4c505b),
                                        onPrimary: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              12), // <-- Radius
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextField(
                                    style: const TextStyle(color: Colors.black),
                                    controller: emailController,
                                    focusNode: focusEmail,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        fillColor: Colors.grey.shade100,
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
                                    style: const TextStyle(),
                                    obscureText: true,
                                    focusNode: focusPassword,
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sign In',
                                        style: TextStyle(
                                            fontSize: 27,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor:
                                            const Color(0xff4c505b),
                                        child: IconButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              QuerySnapshot querySnapshot =
                                                  await collectionReference
                                                      .get();

                                              final allData = querySnapshot.docs
                                                  .map((doc) => doc.data())
                                                  .toList();

                                              final Email = querySnapshot.docs
                                                  .map((doc) => doc['Email'])
                                                  .toList();
                                              
                                              final Password = querySnapshot.docs
                                                 .map((doc) => doc['Phone'])
                                                  .toList();
                                              // var EmailString = Email.join();
                                              // var PasswordString =
                                              //     Password.join();
                                              print(allData);
                                              print(Email);
                                              print(Password);
                                              // if (Email ==
                                              //         emailController.text &&
                                              //     Password ==
                                              //         passwordController.text) {
                                              //   // print("Success");
                                              //   Navigator.of(context)
                                              //       .pushReplacement(
                                              //           MaterialPageRoute(
                                              //               builder: (context) =>
                                              //                   const trainerDashoard()));
                                              // }
                                              //else {
                                              //   FocusScopeNode currentFocus =
                                              //       FocusScope.of(context);

                                              //   if (!currentFocus
                                              //       .hasPrimaryFocus) {
                                              //     currentFocus.unfocus();
                                              //   }

                                              //   showSnack(
                                              //           'No User found for this email');
                                              //       FocusScope.of(context)
                                              //           .requestFocus(
                                              //               FocusNode());
                                              // }
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
}
