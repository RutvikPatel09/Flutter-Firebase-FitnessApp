import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supreme_fitness/Screens/UI/DashboardPage.dart';
import 'package:supreme_fitness/Screens/UI/HomePage.dart';
import 'package:supreme_fitness/providers/userProvider.dart';

import 'Declarations/DashboardScreen.dart';

class PhoneAuthentication extends StatefulWidget {
  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  bool otpVisibility = false;
  User? user;
  String verificationID = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(9, 26, 46, 1),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0, right: 150),
                child: Text(
                  "Phone\nVerification",
                  style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Image.asset(
                  'assets/images/img1.png',
                  width: 190,
                  height: 190,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.yellow,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Color.fromRGBO(59, 72, 89, 1),
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      hintText: "Phone Number",
                      prefix: Padding(
                        padding: EdgeInsets.all(2),
                        child: Text('+91'),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  maxLength: 10,
                ),
              ),
              // TextField(
              //   controller: phoneController,
              //   decoration: InputDecoration(
              //     hintText: 'Phone Number',
              //     prefix: Padding(
              //       padding: EdgeInsets.all(4),
              //       child: Text('+91'),
              //     ),
              //   ),
              //   maxLength: 10,
              //   keyboardType: TextInputType.phone,
              // ),
              Visibility(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.yellow,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Color.fromRGBO(59, 72, 89, 1),
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      hintText: "OTP",
                      prefix: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(''),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                  maxLength: 6,
                ),
                // child: TextField(
                //   controller: otpController,
                //   decoration: InputDecoration(
                //     hintText: 'OTP',
                //     prefix: Padding(
                //       padding: EdgeInsets.all(4),
                //       child: Text(''),
                //     ),
                //   ),
                //   maxLength: 6,
                //   keyboardType: TextInputType.number,
                // ),
                visible: otpVisibility,
              ),
              SizedBox(
                height: 10,
              ),
              MaterialButton(
                height: 40,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromRGBO(255, 207, 96, 1),
                onPressed: () {
                  if (otpVisibility) {
                    verifyOTP();
                  } else {
                    loginWithPhone();
                  }
                },
                child: Text(
                  otpVisibility ? "Verify" : "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginWithPhone() async {
    auth.verifyPhoneNumber(
      phoneNumber: '${"+91" + phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential).then((value) {
          print("You are logged in successfully");
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        otpVisibility = true;
        verificationID = verificationId;
        setState(() {});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationID, smsCode: otpController.text);

    //   final User? user = await auth.signInWithCredential(credential).user;
    // print("signed in " + user.displayName);
    // userProvider.addUserData(
    //   currentuser: user,
    //   //userName: user!.displayName,
    //   userEmail: user!.email,
    //   //userImage: user.photoURL
    // );

    await auth.signInWithCredential(credential).then((value) async {
      //   UserProvider userProvider = UserProvider();

      print("You are logged in successfully");
      Fluttertoast.showToast(
          msg: "You are logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16);
    }).whenComplete(() async {
      //UserProvider userProvider;
      //User user = FirebaseAuth.instance.currentUser!;
      //User? user = (await auth.signInWithCredential(credential)).user;
      //print(user);

      User user = auth.currentUser!;
      // String phone = '';
      // setState(() {
      //   String? phone = user.email;
      //   print(phone);
      // });

      //String? getEmail = auth.currentUser!.email;
      //print(getEmail);
      await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "userEmail": user.email,
        "userUid": user.uid,
        "userRole": "normalUser"
      });

      //userProvider.addUserData(userEmail: user!.email, currentuser: user);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  // void verifyOTP() async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationID, smsCode: otpController.text);

  //   await auth.signInWithCredential(credential).then(
  //     (value) {
  //       setState(() {
  //         user = FirebaseAuth.instance.currentUser!;
  //       });
  //     },
  //   ).whenComplete(
  //     () {
  //       if (user != null) {
  //         Fluttertoast.showToast(
  //           msg: "You are logged in successfully",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => DashboardPageClass(),
  //           ),
  //         );
  //       } else {
  //         Fluttertoast.showToast(
  //           msg: "your login is failed",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //       }
  //     },
  //   );
  // }
}
