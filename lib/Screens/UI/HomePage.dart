import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/AI%20BOT%20With%20ChatGPT/AIBOT.dart';
import 'package:supreme_fitness/BMI/bmi_calculator.dart';
import 'package:supreme_fitness/CaloriesNeed/dailyCaloriesNeed.dart';
import 'package:supreme_fitness/ChatBot/Bot.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/ExerciseCategory/showCategory.dart';
import 'package:supreme_fitness/Feedback/feedback.dart';
import 'package:supreme_fitness/Live%20CHAT%20Support/LiveChatSupport.dart';
import 'package:supreme_fitness/StepsCounter/stepCount.dart';
import 'package:supreme_fitness/healthyFood/WeightGainFood.dart';
import 'package:supreme_fitness/localRegister.dart';
import 'package:supreme_fitness/uploadVideos/showVideos.dart';

import '../../AboutUS/aboutUs.dart';
import '../../AdmobService.dart';
import '../../NotificationService/NotificationServices.dart';
import '../../Stripe Payment/payment.dart';
import '../../customWidget/card_widget.dart';
import '../../customWidget/card_widget2.dart';
import '../../drawer/my_drawer_header.dart';
import '../../drawer/my_profile.dart';
import '../../login.dart';
import '../../main.dart';
import '../../providers/profileDataProvider.dart';
import '../../providers/userProvider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var currentPage = DrawerSections.Dashboard;

  NotificationServices notificationServices = NotificationServices();
  List<String> cardList = [
    "assets/images/healthyfoodbanner.png",
    "assets/images/challenge.png",
    "assets/images/fitnesss.png",
    "assets/images/exercisebanner.png",
  ];

  List<String> cardList2 = [
    "assets/images/eatwell.png",
    "assets/images/workout.png",
    "assets/images/food1.png",
    "assets/images/workout1.png",
    "assets/images/food.png",
    "assets/images/workout2.png",
  ];

  Future signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await GoogleSignIn().signOut();
    await auth.signOut();

    //if (!context.mounted) return;
    //Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyLogin()));
  }

  Future removeData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove('Email');

    Get.to(() => localRegister());
  }

  bool ActiveConnection = false;
  String T = "";
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;
          print("Turn off the data and repress again");
        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
        print("Turn On the data and repress again");
      });
    }
  }

  BannerAd? _banner;
  String? statusToString;

  void loadStatusData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("controlGoogleAds");
    QuerySnapshot querySnapshot = await collectionReference.get();

    final status = querySnapshot.docs.map((e) => e['AdStatus']);
    String statusToString1 = status.join();
    setState(() {
      statusToString = statusToString1;
      print(statusToString.toString());
    });
  }

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService.bannerAdUnitId!,
        listener: AdMobService.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  DateTime timeBackPressed = DateTime.now();

  Future<bool> _onWillPop() async {
    final difference = DateTime.now().difference(timeBackPressed);
    final isExitWarning = difference >= Duration(seconds: 2);
    timeBackPressed = DateTime.now();

    if (isExitWarning) {
      final message = 'Press back again to exit';
      Fluttertoast.showToast(msg: message, fontSize: 18);
      return false;
    } else {
      Fluttertoast.cancel();
      return true;
    }
  }

  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': 'HINDI', 'locale': Locale('hi', 'IN')},
  ];

  updateLanguage(Locale locale) {
    Get.back();
    Get.updateLocale(locale);
  }

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose Language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () {
                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(color: Colors.blue);
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  @override
  void initState() {
    loadStatusData();
    _createBannerAd();
    CheckUserConnection();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    //notificationServices.isTokenRefresh();
    notificationServices
        .getDeviceToken()
        .then((value) => {print('Device Token'), print(value)});
    // !ActiveConnection
    //     ? Fluttertoast.showToast(msg: "No Connection",fontSize: 18,toastLength: Toast.LENGTH_LONG)
    //     : Fluttertoast.showToast(msg: "");
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.title,
    //         NotificationDetails(
    //             android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //           color: Colors.blue,
    //           playSound: true,
    //           icon: '@mipmap/ic_launcher',
    //         )));
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new onMessageOpenedApp event was published!');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;

    //   if (notification != null && android != null) {
    //     showDialog(
    //         context: context,
    //         builder: (_) {
    //           return AlertDialog(
    //             title: Text(notification.title.toString()),
    //             content: SingleChildScrollView(
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text(notification.body.toString())],
    //               ),
    //             ),
    //           );
    //         });
    //   }
    // });
  }

  // void sendNotification() {
  //   setState(() {});
  //   flutterLocalNotificationsPlugin.show(
  //       1,
  //       "Testing",
  //       "Testing",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         importance: Importance.high,
  //         color: Colors.blue,
  //         playSound: true,
  //         icon: '@mipmap/ic_launcher',
  //       )));
  // }


  

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            backgroundColor: Color.fromRGBO(9, 26, 46, 1),
            drawer: Drawer(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      MyHeaderDrawer(userProvider: userProvider),
                      MyDrawerList()
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
                backgroundColor: Color.fromRGBO(9, 26, 46, 1),
                shadowColor: Color.fromRGBO(9, 26, 46, 1).withAlpha(0),
                title: Padding(
                  padding: EdgeInsets.only(left: 50),
                  child: Text(
                    'appName'.tr,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                actions: [
                  Tooltip(
                    message: 'Notifications',
                    child: IconButton(
                        onPressed: () async {
                          //sendNotification();

                          buildDialog(context);
                        },
                        icon: Icon(
                          Icons.language,
                          color: Colors.white,
                        )),
                  )
                ],
                leading: Builder(builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: IconButton(
                      icon: Image.asset("assets/icon/menu_icon.png",
                          color: Colors.white),
                      color: Colors.black,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  );
                })),
            body: SingleChildScrollView(
                child: Column(children: [
              !ActiveConnection
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        child: Text(
                          "No Connection, Some functionalities may not work if you want use them please enable internet.",
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.redAccent,
                              fontSize: 15),
                        ),
                      ),
                    )
                  : Container(),
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 295),
                    child: Text(
                      "Hello".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 210),
                    child: Text(
                      "Fitness Family".tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return CardWidget(cardImg: cardList[index]);
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 22,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: false,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return CardWidget2(cardImg: cardList2[index]);
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 22,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 207, 96, 1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Things to do",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 21,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 160.0),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Color.fromRGBO(255, 207, 96, 1),
                    child: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                )
              ]),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const showCategory()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Image.asset(
                              'assets/images/exercise1.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Workouts".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Regular Workouts".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  //color: dashboardColors[10],
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const countSteps()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.asset(
                              'assets/images/counter.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Steps Count".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Calculate Your Daily Steps".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  //color: dashboardColors[10],
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const dailyCaloriesNeed()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.asset(
                              'assets/images/calories.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Count Calories".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Calculate Your Daily Calories".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  //color: dashboardColors[10],
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BMICalculator()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Image.asset(
                              'assets/images/bmi.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "BMI".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Calculate Your BMI".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WeightGainFood()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Image.asset(
                              'assets/images/diet.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Healthy Food".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Nutritions & Diet".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const showVideos()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.0),
                            child: Image.asset(
                              'assets/images/play-button.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Videos".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Learn Exercises".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const FeedbackData()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/images/feedback.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "Feedback".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Give Your Valuable Feedback".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  height: 100,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(11),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Bot()));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              'assets/images/bot.png',
                              height: 150.0,
                              width: 100.0,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 25),
                            child: Text(
                              "AI Bot".tr,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Ask Your Questions".tr,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            "______________________________________",
                            style: TextStyle(
                                color: Color.fromRGBO(255, 207, 96, 1)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ])),
            bottomNavigationBar: statusToString == 'false'
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 52,
                    child: AdWidget(ad: _banner!),
                  )));
  }

  Widget MyDrawerList() {
    return Container(
      height: 700,
      color: Color.fromRGBO(9, 26, 46, 1),
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          menuItem(1, "Dashboard".tr, Icons.dashboard_outlined,
              currentPage == DrawerSections.Dashboard ? true : false),
          menuItem(2, "My Profile".tr, Icons.verified_user,
              currentPage == DrawerSections.MyProfile ? true : false),
          menuItem(3, "Subscription".tr, Icons.subscriptions,
              currentPage == DrawerSections.Subscriptions ? true : false),
          menuItem(4, "Live Chat Support".tr, Icons.support_agent,
              currentPage == DrawerSections.LiveChatSupport ? true : false),
          menuItem(5, "AboutUs".tr, Icons.info,
              currentPage == DrawerSections.AboutUs ? true : false),
          menuItem(6, "Share App".tr, Icons.share,
              currentPage == DrawerSections.ShareApp ? true : false),
          menuItem(7, "Logout".tr, Icons.logout,
              currentPage == DrawerSections.Logout ? true : false),
          Padding(
            padding: EdgeInsets.only(top: 130, right: 50),
            child: Text(
              "Version: 1.0.0",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected
          ? Color.fromRGBO(255, 207, 96, 1)
          : Color.fromRGBO(9, 26, 46, 1),
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
              Get.to(() => MyProfile(profileProvider: profileDataProvider()),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 3) {
              currentPage = DrawerSections.Subscriptions;

              Get.to(() => PaymentPage(),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 4) {
              currentPage = DrawerSections.LiveChatSupport;

              Get.to(() => LiveChatSupport(),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 5) {
              currentPage = DrawerSections.AboutUs;

              Get.to(() => aboutUs(),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 6) {
              currentPage = DrawerSections.ShareApp;
              Share.share(
                  'https://play.google.com/store/apps/details?id=com.google.android.apps.fitness&hl=en&gl=US');
            } else if (id == 7) {
              currentPage = DrawerSections.Logout;
              ActiveConnection ? signOut() : removeData();
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
                color: Color.fromRGBO(255, 207, 96, 1),
              )),
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
  Subscriptions,
  LiveChatSupport,
  AboutUs,
  ShareApp,
  Logout
}
