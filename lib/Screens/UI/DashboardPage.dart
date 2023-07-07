import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supreme_fitness/AboutUS/aboutUs.dart';
import 'package:supreme_fitness/Declarations/DashboardScreen.dart';
import 'package:supreme_fitness/Live%20CHAT%20Support/LiveChatSupport.dart';
import 'package:supreme_fitness/main.dart';
import 'package:supreme_fitness/providers/profileDataProvider.dart';
import 'package:supreme_fitness/providers/userProvider.dart';

import '../../AdmobService.dart';
import '../../Stripe Payment/payment.dart';
import '../../drawer/my_drawer_header.dart';
import '../../drawer/my_profile.dart';
import '../../login.dart';
import '../Widgets/1Body.dart';

class DashboardPageClass extends StatefulWidget {
  DashboardPageClass({Key? key}) : super(key: key);

  @override
  DashboardPageClassState createState() => DashboardPageClassState();
}

class DashboardPageClassState extends State<DashboardPageClass> {
  Future signOut() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    await GoogleSignIn().signOut();
    await auth.signOut();
    //if (!context.mounted) return;
    //Navigator.pop(context);

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyLogin()));
  }

  var currentPage = DrawerSections.Dashboard;
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

  @override
  void initState() {
    super.initState();
    //loadStatusData();
    _createBannerAd();
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

    //initBannerAd();
  }

  // void sendNotification() {
  //   setState(() {});
  //   flutterLocalNotificationsPlugin.show(
  //     1,
  //     "Testing",
  //     "Testing",
  //     NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         importance: Importance.high,
  //         color: Colors.blue,
  //         playSound: true,
  //         icon: '@mipmap/ic_launcher',
  //       )
  //     )
  //   );
  // }

  // late BannerAd bannerAd;
  // bool isAdLoaded = false;
  // var adUnit = "ca-app-pub-3940256099942544/6300978111"; //testing ad id

  // initBannerAd() {
  //   bannerAd = BannerAd(
  //       size: AdSize.banner,
  //       adUnitId: adUnit,
  //       listener: BannerAdListener(onAdLoaded: (ad) {
  //         setState(() {
  //           isAdLoaded = true;
  //         });
  //       }, onAdFailedToLoad: ((ad, error) {
  //         ad.dispose();
  //         print(error);
  //       })),
  //       request: const AdRequest());

  //   bannerAd.load();
  // }

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


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserProvider userProvider = Provider.of(context);
    userProvider.getUserData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            // floatingActionButton: FloatingActionButton(
            //   onPressed: sendNotification,
            //   tooltip: 'Increment',
            //   child: Icon(Icons.add),
            // ),
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
              iconTheme: const IconThemeData(color: Colors.black),
              backgroundColor: dashboardColors[10],
              shadowColor: dashboardColors[10],
              elevation: 0,
              title: const Text(
                'Supreme Fitness',
                style: TextStyle(color: Colors.black, fontFamily: 'Montserrat'),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () async {
                      Share.share(
                          'https://play.google.com/store/apps/details?id=com.google.android.apps.fitness&hl=en&gl=US');
                    },
                    child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(0xff4c505b),
                        child:
                            Icon(Icons.share, size: 17, color: Colors.white)),
                  ),
                ),
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
                        child:
                            Icon(Icons.logout, size: 17, color: Colors.white)),
                  ),
                ),
              ],
            ),
            
            body: buildBody(context),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LiveChatSupport()));
              },
              tooltip: 'Support',
              backgroundColor: Color(0xff4c505b),
              child: Icon(Icons.support_agent),
            ),
            bottomNavigationBar: statusToString == 'false'
                ? Container()
                : Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 52,
                    child: AdWidget(ad: _banner!),
                  )
                  ));
  }

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.Dashboard ? true : false),
          menuItem(2, "My Profile", Icons.verified_user,
              currentPage == DrawerSections.MyProfile ? true : false),
          menuItem(3, "Subscription", Icons.subscriptions,
              currentPage == DrawerSections.Subscriptions ? true : false),
          menuItem(4, "AboutUs", Icons.info,
              currentPage == DrawerSections.AboutUs ? true : false),
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
              Get.to(() => MyProfile(profileProvider: profileDataProvider()),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 3) {
              currentPage = DrawerSections.Subscriptions;

              Get.to(() => PaymentPage(),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
            } else if (id == 4) {
              currentPage = DrawerSections.AboutUs;

              Get.to(() => aboutUs(),
                  transition: Transition.cupertino,
                  duration: Duration(seconds: 1));
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

enum DrawerSections { Dashboard, MyProfile, Subscriptions, AboutUs }
