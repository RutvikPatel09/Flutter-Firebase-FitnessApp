import 'package:flutter/material.dart';
import '../providers/userProvider.dart';

// ignore: must_be_immutable
class MyAdminHeaderDrawer extends StatefulWidget {
  //const MyHeaderDrawer({super.key});
  UserProvider userProvider;
  MyAdminHeaderDrawer({required this.userProvider});
  @override
  State<MyAdminHeaderDrawer> createState() => _MyAdminHeaderDrawerState();
}

class _MyAdminHeaderDrawerState extends State<MyAdminHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    var userData = widget.userProvider.currentUserData;
    return Container(
      color: Color(0xff4c505b),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Container(
          //   margin: EdgeInsets.only(bottom: 20),
          //   height: 70,
          //   child: CircleAvatar(
          //     backgroundImage: NetworkImage(userData.userImage),
          //     radius: 40,
          //   ),
          // ),
          // Text(
          //   userData.userName,
          //   style: TextStyle(color: Colors.white, fontSize: 20),
          // ),
          Text(
            userData.userEmail,
            style: TextStyle(color: Colors.grey[200], fontSize: 14),
          )
        ],
      ),
    );
  }
}
