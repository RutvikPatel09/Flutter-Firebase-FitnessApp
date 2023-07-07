import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supreme_fitness/AI%20BOT%20With%20ChatGPT/AIBOT.dart';
import 'package:supreme_fitness/BMI/bmi_calculator.dart';
import 'package:supreme_fitness/CaloriesNeed/dailyCaloriesNeed.dart';
import 'package:supreme_fitness/ChatBot/Bot.dart';
import 'package:supreme_fitness/Exercise/exercise.dart';
import 'package:supreme_fitness/Exercise/showExercise.dart';
import 'package:supreme_fitness/ExerciseCategory/category.dart';
import 'package:supreme_fitness/ExerciseCategory/showCategory.dart';
import 'package:supreme_fitness/Feedback/feedback.dart';
import 'package:supreme_fitness/OTPVerification/phone.dart';
import 'package:supreme_fitness/OTPVerification/verify.dart';
import 'package:supreme_fitness/Reports/reports.dart';
import 'package:supreme_fitness/Search/search.dart';
import 'package:supreme_fitness/Stripe%20Payment/payment.dart';
import 'package:supreme_fitness/TestAD.dart';
import 'package:supreme_fitness/Trainer/addTrainer.dart';
import 'package:supreme_fitness/adminHome.dart';
import 'package:supreme_fitness/drawer/my_profile.dart';
import 'package:supreme_fitness/forgotPassword.dart';
import 'package:supreme_fitness/healthyFood/WeightGainFood.dart';
import 'package:supreme_fitness/healthyFood/WeightLoss.dart';
import 'package:supreme_fitness/healthyFood/addHealthyFood.dart';
import 'package:supreme_fitness/healthyFood/healthyFood.dart';
import 'package:supreme_fitness/models/exercise.dart';
import 'package:supreme_fitness/providers/categoryProvider.dart';
import 'package:supreme_fitness/providers/exerciseProvider.dart';
import 'package:supreme_fitness/providers/favoriteProvider.dart';
import 'package:supreme_fitness/providers/feedbackProvider.dart';
import 'package:supreme_fitness/providers/healthyFoodProvider.dart';
import 'package:supreme_fitness/providers/profileDataProvider.dart';
import 'package:supreme_fitness/providers/trainerProvider.dart';
import 'package:supreme_fitness/providers/userProvider.dart';
import 'package:supreme_fitness/providers/videoProvider.dart';
import 'package:supreme_fitness/register.dart';
import 'package:supreme_fitness/splash_screen/splash_screen.dart';
import 'package:supreme_fitness/testPage.dart';
import 'package:supreme_fitness/trainerLogin.dart';
import 'package:supreme_fitness/uploadVideos/showVideos.dart';
import 'package:supreme_fitness/uploadVideos/uploadExerciseVideos.dart';
import 'AboutUS/aboutUs.dart';
import 'Email Verification/verifyEmail.dart';
import 'Live CHAT Support/LiveChatSupport.dart';
import 'Localization/localString.dart';
import 'PhoneAuthentication.dart';
import 'Screens/UI/DashboardPage.dart';
import 'Screens/UI/HomePage.dart';
import 'SplashScreen/AnimatedSplashScreen.dart';
import 'StepsCounter/stepCount.dart';
import 'healthyFood/filterData.dart';
import 'homescreen.dart';
import 'imageUpload.dart';
import 'localRegister.dart';
import 'login.dart';

// const channel = AndroidNotificationChannel(
//     'high_importance_channel', //id
//     'High Importance Notifications', //title
//     //'This Channel is used for important notifications.', //description
//     importance: Importance.high,
//     playSound: true);

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('A bg message just showed up : ${message.messageId}');
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  MobileAds.instance.initialize();

  Stripe.publishableKey =
      'pk_test_51MacvRSDrOtIQ2huPKam6CipvbOnASpLxOUKXqKwncPGnHn5AV7Bp3Dk4ESINKV0NM27DSozCKfYW6jOQuJY69Qk00g3chMLGK';
  //await MobileAds.instance.initialize();
  // RequestConfiguration requestConfiguration = RequestConfiguration(

  // )
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);
  // AwesomeNotifications().initialize(null, [
  //   NotificationChannel(
  //     channelKey: 'key1',
  //     channelName: 'Supreme Fitness',
  //     channelDescription: 'Notification',
  //     defaultColor: Colors.blueGrey,
  //     ledColor: Colors.white,
  //     playSound: true,
  //     enableLights: true,
  //     enableVibration: true
  //   )
  // ]);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //     alert: true, badge: true, sound: true);

  runApp(const MyApp());
  configLoading();
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => feedbackProvider()),
          ChangeNotifierProvider(create: (context) => categoryProvider()),
          ChangeNotifierProvider(create: (context) => exerciseProvider()),
          ChangeNotifierProvider(create: (context) => healthyFoodProvider()),
          ChangeNotifierProvider(create: (context) => videoProvider()),
          ChangeNotifierProvider(create: (context) => trainerProvider()),
          ChangeNotifierProvider(create: (context) => profileDataProvider()),
          ChangeNotifierProvider(create: (context) => FavoriteProvider())
        ],
        child: GetMaterialApp(
          translations: LocalString(),
          locale: Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          title: 'Supreme Fitness',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const AnimatedSplashScreen(),
          builder: EasyLoading.init(),
          // home: SplashScreen(
          //     duration: 5,
          //     gotoPage:
          //     StreamBuilder(
          //       stream: FirebaseAuth.instance.authStateChanges(),
          //       builder: (context, snapshot) {
          //         if (snapshot.hasData) {
          //           return VerifyEmail();
          //         }
          //         return const MyLogin();
          //       },
          //     )
          //     )
        ));
  }
}
