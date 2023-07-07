import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Email Verification/verifyEmail.dart';
import '../login.dart';
import '../providers/userProvider.dart';

// ignore: must_be_immutable
class MyHeaderDrawer extends StatefulWidget {
  //const MyHeaderDrawer({super.key});
  UserProvider userProvider;
  MyHeaderDrawer({required this.userProvider});
  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  void initState() {
    CheckUserConnection();
    super.initState();
  }

  bool ActiveConnection = false;
  var T;
  var phoneNumber;
  var condition;
  var userData1;
  Future CheckUserConnection() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          print("Turn off the data and repress again");
          var userData = widget.userProvider.currentUserData;
          User user = FirebaseAuth.instance.currentUser!;
          String? phone = user.phoneNumber;
          final condition1 = userData.userEmail;
          phoneNumber = phone;
          condition = condition1;
          userData1 = userData;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        print("Turn On the data and repress again");
        var obtainedEmail = sharedPreferences.getString('Email');
        T = obtainedEmail.toString();

        print("Email:- " + T);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(a);
    //print(user);
    // setState(() {
    //   T = obtainedEmail;
    // });

    if (condition != null || T !=null) {
      return Container(
        color: Color.fromRGBO(9, 26, 46, 1),
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 70,
              child: CircleAvatar(
                backgroundImage: 
                NetworkImage(userData1.userImage),
                radius: 40,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ActiveConnection ? userData1.userEmail : T,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.verified_sharp,
                    color: Color.fromRGBO(255, 207, 96, 1),
                  ),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Container(
        color: Color.fromRGBO(9, 26, 46, 1),
        width: double.infinity,
        height: 200,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 70,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg"),
                radius: 40,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  phoneNumber.toString(),
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.verified_sharp,
                    color: Color.fromRGBO(255, 207, 96, 1),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }

    // return Container(
    //   color: Color(0xff4c505b),
    //   width: double.infinity,
    //   height: 200,
    //   padding: EdgeInsets.only(top: 20),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Container(
    //         margin: EdgeInsets.only(bottom: 20),
    //         height: 70,
    //         child: CircleAvatar(
    //           backgroundImage: NetworkImage(
    //               "https://t4.ftcdn.net/jpg/00/65/77/27/360_F_65772719_A1UV5kLi5nCEWI0BNLLiFaBPEkUbv5Fv.jpg"),
    //           radius: 40,
    //         ),
    //       ),
    //       Text(
    //         userData.userEmail,
    //         style: TextStyle(color: Colors.grey[200], fontSize: 14),
    //       )
    //     ],
    //   ),
    // );
  }
}
