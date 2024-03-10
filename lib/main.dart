import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/expert_missions.dart';
import 'View/expert_missions2.dart';
import 'pages/home.dart';
import 'pages/signin.dart';
import 'pages/dashboard.dart';
import 'pages/mySurvey.dart';
import 'pages/survey.dart';
import 'pages/searchSurvey.dart';
import 'pages/carInfoInput.dart';
import 'pages/requiredDocuments.dart';
import 'pages/driverLicenceDashboard.dart';
import 'pages/historySearch.dart';
import 'pages/policy.dart';
import 'controllers/RefreshController.dart';
import 'firebase_options.dart';
import 'dart:io' as io;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

final storage = FlutterSecureStorage();

Future<void> _checkLoginStatus() async {
  final token = await storage.read(key: "token");
  if (token != null && token.isNotEmpty) {
    // Token exists, user is logged in
    runApp(GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      initialRoute: io.Platform.isIOS?'/missions2':'/missions', // or any other route you prefer
      routes: {
        '/home': (context) => Home(),
        '/missions2': (context) => ExpertMissions2(),
        '/missions': (context) => ExpertMissions(),
        '/dashboard': (context) => Dashboard(),
        '/': (context) => Signin(),
        '/mySurvey': (context) => mySurvey(),
        '/Survey': (context) => Survey(),
        '/SearchSurvey': (context) => SearchSurvey(),
        '/CarInfoInput': (context) => CarInfoInput(),
        '/RequiredDocuments': (context) => RequiredDocuments(),
        '/DriverLicenceDashboard': (context) => DriverLicenceDashboard(),
        '/HistorySearch': (context) => HistorySearch(),
        '/policy': (context) => Policy(),
      },
    ));
  } else {
    // Token doesn't exist, user is not logged in
    runApp(GetMaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Navigate to signin page
      routes: {
        '/home': (context) => Home(),
        '/missions2': (context) => ExpertMissions2(),
        '/missions': (context) => ExpertMissions(),
        '/dashboard': (context) => Dashboard(),
        '/': (context) => Signin(),
        '/mySurvey': (context) => mySurvey(),
        '/Survey': (context) => Survey(),
        '/SearchSurvey': (context) => SearchSurvey(),
        '/CarInfoInput': (context) => CarInfoInput(),
        '/RequiredDocuments': (context) => RequiredDocuments(),

        '/DriverLicenceDashboard': (context) => DriverLicenceDashboard(),
        '/HistorySearch': (context) => HistorySearch(),
        '/policy': (context) => Policy(),
      },
    ));
  }
}

void main() async {
  Get.put(RefreshController()); // Initializing the controller

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  _checkLoginStatus();
}
