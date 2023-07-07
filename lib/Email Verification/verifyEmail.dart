import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supreme_fitness/Screens/UI/DashboardPage.dart';
import 'package:supreme_fitness/Screens/UI/HomePage.dart';
import 'package:supreme_fitness/login.dart';

import '../Declarations/DashboardScreen.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResentEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResentEmail = true;
      });
    } catch (e) {
      final message = e.toString();
      Fluttertoast.showToast(msg: message, fontSize: 16);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: dashboardColors[10],
            shadowColor: dashboardColors[10].withAlpha(0),
            title: const Text(
              "Verify Email",
              style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
            ),
          ),

          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("A Verification email has been sent to your email.",
                style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                SizedBox(height: 24,),
                ElevatedButton.icon(
                  onPressed: canResentEmail ? sendVerificationEmail : null, 
                  icon: Icon(Icons.email,size: 32,), 
                  label: Text("Resent Email",style: TextStyle(fontSize: 24),)),
                  SizedBox(height: 8,),
                  TextButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: Text("Cancel",style: TextStyle(fontSize: 24),)),
                    //   TextButton(
                    // style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                    // onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyLogin())),
                    // child: Text("Click this to Login",style: TextStyle(fontSize: 24),)),
              ],
            ),
          )
        );
}
