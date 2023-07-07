// ignore: file_names
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Exercise/exercise.dart';
import 'package:supreme_fitness/ExerciseCategory/category.dart';
import 'package:supreme_fitness/Reports/reports.dart';
import 'package:supreme_fitness/Trainer/addTrainer.dart';
import 'package:supreme_fitness/healthyFood/addHealthyFood.dart';
import 'package:supreme_fitness/providers/userProvider.dart';
import 'package:supreme_fitness/uploadVideos/uploadExerciseVideos.dart';

import 'adminDrawer/my_admin_header_drawer.dart';
import 'drawer/my_profile.dart';
import 'login.dart';

// ignore: camel_case_types
class adminHome extends StatefulWidget {
  const adminHome({super.key});

  @override
  State<adminHome> createState() => _adminHomeState();
}

// ignore: camel_case_types
class _adminHomeState extends State<adminHome> {
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

  var text = [
    "Category",
    "Exercise",
    "Healthy Food",
    "Workout Videos",
    "Reports"
  ];

  var navigationLinks = [
    ExerciseCategory(),
    Exercise(),
    addHealthyFood(),
    uploadExerciseVideos(),
    Reports()
  ];

  var images = [
    "assets/images/menu.png",
    "assets/images/exercise1.png",
    "assets/images/healthy-food.png",
    "assets/images/circled-play.png",
    "assets/images/report.png",
  ];

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      MyAdminHeaderDrawer(userProvider: userProvider),
                      MyDrawerList()
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
                iconTheme: const IconThemeData(color: Colors.black),
                backgroundColor: dashboardColors[10],
                shadowColor: dashboardColors[10].withAlpha(0),
                title: const Text(
                  "Hello, Admin",
                  style:
                      TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
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
                          child: Icon(Icons.logout,
                              size: 17, color: Colors.white)),
                    ),
                  ),
                ]),
            body: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: text.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.only(top: 18.0, left: 5, right: 5),
                    child: new GestureDetector(
                      child: new Card(
                        elevation: 0.5,
                        child: new Container(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Image.asset(
                                images[index],
                                height: 70,
                                width: 70,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: Text(text[index]),
                            ),
                          ],
                        )),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => navigationLinks[index]));
                      },
                    ),
                  );
                })
            //itemBuilder: itemBuilder)
            // ListView(
            //   padding: EdgeInsets.all(16),
            //   children: [
            //     buildImageCard(),
            //     buildImageCard1(),
            //     buildImageCard2(),
            //     buildImageCard3(),
            //     buildImageCard4(),
            //   ],
            // ),

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
                  "https://i.ytimg.com/vi/-hUZ2Sz4HW0/maxresdefault.jpg"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Exercise()));
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
                  "https://wellcurve.in/blog/wp-content/uploads/2021/09/food-good-for-heart.jpg"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const addHealthyFood()));
                },
              ),
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

  Widget buildImageCard2() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                  "https://www.shutterstock.com/image-photo/category-word-written-on-wood-260nw-1336568840.jpg"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ExerciseCategory()));
                },
              ),
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

  Widget buildImageCard3() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                  "https://www.igeeksblog.com/wp-content/uploads/2021/09/How-to-upload-videos-to-YouTube-from-iPhone-or-iPad.jpg"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const uploadExerciseVideos()));
                },
              ),
              height: 200,
              fit: BoxFit.cover,
            ),
          ],
        ),
      );

  Widget buildImageCard4() => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink.image(
              image: NetworkImage(
                  "https://www.actitime.com/wp-content/uploads/2018/12/Reports.png"),
              //colorFilter: ColorFilters.greyscale,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Reports()));
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

enum DrawerSections { Dashboard }
