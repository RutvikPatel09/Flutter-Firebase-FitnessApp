import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/BMI/bmi_calculator.dart';
import 'package:supreme_fitness/Feedback/feedback.dart';
import 'package:supreme_fitness/login.dart';
import 'package:supreme_fitness/providers/userProvider.dart';

import 'drawer/my_drawer_header.dart';
import 'drawer/my_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // signOut() async {
  //   await auth.signOut();
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => const MyLogin()));
  // }
  

  var currentPage = DrawerSections.Dashboard;

  Future signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await GoogleSignIn().signOut();
    await auth.signOut();
    await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyLogin()));
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    //UserProvider userProvider = Provider.of(context);
    //userProvider.getUserData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          drawer: Drawer(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    //MyHeaderDrawer(userProvider: userProvider),
                    MyDrawerList()
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: const Color(0xff4c505b),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                child: GestureDetector(
                  onTap: () async {
                    // signOut();
                    await signOut();
                  },
                  child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xff4c505b),
                      child: Icon(Icons.logout, size: 17, color: Colors.white)),
                ),
              ),
            ],
          ),
          body: 
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              buildImageCard(),
              buildImageCard1()
            ],
          ),
        ));
        
  }

  Widget buildImageCard() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                  "https://media.istockphoto.com/id/1361979553/vector/indikator-bmi-on-white-background-chart-concept-vector-icon.jpg?s=612x612&w=0&k=20&c=pTA-NeyIyU_rtmZ0TVjVQqiM5037e9jxmA87TVuENhA="),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const BMICalculator()));
                },
              ),
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

    Widget buildImageCard1() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                  "https://img.freepik.com/premium-vector/we-want-your-feedback-text-colorful-bright-speech-bubble-background-feedback-opinion-concept_499817-280.jpg?w=2000"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const FeedbackData()));
                },
              ),
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );


  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.Dashboard ? true : false),
          menuItem(2, "My Profile", Icons.verified_user,
              currentPage == DrawerSections.MyProfile ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          //UserProvider userProvider = Provider.of(context);
          //  userProvider.getUserData();
          //userProvider.currentUserData;
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.MyProfile;

              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => MyProfile(
              //               userProvider: UserProvider(),
              //             )));
            } 
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              )),
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ))
            ],
          ),
        ),
      ),
    );
  }


}


enum DrawerSections {
  Dashboard,
  MyProfile,
}
