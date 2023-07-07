import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/Email%20Verification/verifyEmail.dart';
import 'package:supreme_fitness/login.dart';
import 'package:supreme_fitness/providers/userProvider.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final FocusNode focusEmail = FocusNode();
  final FocusNode focusPassword = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  void showSnack(String title) {
    final snackbar = SnackBar(
        content: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
      ),
    ));
    scaffoldMessengerKey.currentState?.showSnackBar(snackbar);
  }

  Future<bool> _onWillPop() async {
    return false;
  }


  final _auth = FirebaseAuth.instance;
  postDetailsToFirestore(String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    var uid = _auth.currentUser?.uid;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'userEmail': emailController.text,
      'userRole': 'normalUser',
      'userUid': uid
    });
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const VerifyEmail()));
  }

  late UserProvider userProvider;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: ScaffoldMessenger(
            key: scaffoldMessengerKey,
            child: Container(
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage('assets/images/login.png'),
              //       fit: BoxFit.cover),
              // ),
              child: Scaffold(
                backgroundColor: Color.fromRGBO(9, 26, 46, 1),
                body: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 35, top: 55),
                      child: const Text(
                        'Create\nAccount',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 33),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 105.0, top: 160),
                      child: Container(
                          child: Image.asset("assets/images/contract.png",
                              height: 180, width: 180)),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 35, right: 35),
                              child: Column(
                                children: [
                                  TextField(
                                    style: const TextStyle(color: Colors.white),
                                    cursorColor: Colors.yellow,
                                    controller: emailController,
                                    focusNode: focusEmail,
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
                                    controller: passwordController,
                                    cursorColor: Colors.yellow,
                                    focusNode: focusPassword,
                                    obscureText: passwordVisible,
                                    keyboardType: TextInputType.visiblePassword,
                                    maxLength: 8,
                                    decoration: InputDecoration(
                                        fillColor:
                                            Color.fromRGBO(59, 72, 89, 1),
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        filled: true,
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(passwordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off),
                                          onPressed: () {
                                            setState(() {
                                              passwordVisible =
                                                  !passwordVisible;
                                            });
                                          },
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            fontSize: 27,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      loading
                                          ? CircularProgressIndicator()
                                          : CircleAvatar(
                                              radius: 30,
                                              backgroundColor: Color.fromRGBO(
                                                  255, 207, 96, 1),
                                              child: IconButton(
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      loading = true;
                                                    });

                                                    String userEmail =
                                                        emailController.text;
                                                    String password =
                                                        passwordController.text;

                                                    String userRole =
                                                        "normalUser";

                                                    if (userEmail.isEmpty ||
                                                        !RegExp("^[a-zA-z0-9+_.-]+@[a-zA-z0-9.-]+.[a-z]")
                                                            .hasMatch(
                                                                userEmail)) {
                                                      final message =
                                                          'Please Enter Correct Email';
                                                      Fluttertoast.showToast(
                                                          msg: message,
                                                          fontSize: 18);
                                                    } else if (password
                                                        .isEmpty) {
                                                      final message =
                                                          'Please Enter Password';
                                                      Fluttertoast.showToast(
                                                          msg: message,
                                                          fontSize: 18);
                                                    } else {
                                                      try {
                                                        FirebaseAuth.instance
                                                            .createUserWithEmailAndPassword(
                                                                email:
                                                                    emailController
                                                                        .text,
                                                                password:
                                                                    passwordController
                                                                        .text)
                                                            .then((value) => {
                                                                  postDetailsToFirestore(
                                                                      userEmail,
                                                                      userRole)
                                                                });
                                                       } catch (signUpError) {
                                                        if (signUpError
                                                            is PlatformException) {
                                                          if (signUpError
                                                                  .code ==
                                                              'ERROR_EMAIL_ALREADY_IN_USE') {
                                                            final message =
                                                                'This email already been registered.';
                                                            Fluttertoast
                                                                .showToast(
                                                                    msg:
                                                                        message,
                                                                    fontSize:
                                                                        18);
                                                          }
                                                        }
                                                      }
                                                      // .catchError((e) {});
                                                      //  Navigator.push(
                                                      //         context,
                                                      //         MaterialPageRoute(
                                                      //             builder: (context) =>
                                                      //                 const HomeScreen()))
                                                      // .onError(
                                                      //     (error, stackTrace) =>
                                                      //         {
                                                      //           "Error ${error.toString()}",
                                                      //         },

                                                      //       );
                                                    }

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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 25),
                                        child: TextButton(
                                          onPressed: () {
                                            Get.to(() => MyLogin(),
                                                transition:
                                                    Transition.cupertino,
                                                duration: Duration(seconds: 1));
                                          },
                                          child: const Text(
                                            'Already Have an Account?',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Color.fromRGBO(
                                                    255, 207, 96, 1),
                                                fontSize: 18),
                                          ),
                                          style: const ButtonStyle(),
                                        ),
                                      )
                                    ],
                                  )
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
            )));
  }
}
