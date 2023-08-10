import 'dart:developer';

import 'package:e_survey/View/expert_missions.dart';
import 'package:e_survey/View/new_mission.dart';
import 'package:e_survey/View/notes.dart';
import 'package:e_survey/args/personalInfoArgs.dart';
import 'package:e_survey/pages/CarInfoInput.dart';
import 'package:e_survey/pages/DriverLicenceDashboard.dart';
import 'package:e_survey/pages/HistorySearch.dart';
import 'package:e_survey/pages/Policy.dart';
import 'package:e_survey/pages/bridge_page.dart';
import 'package:e_survey/pages/claimsList.dart';
import 'package:e_survey/pages/dashboard.dart';
import 'package:e_survey/pages/dataInputCarInformation.dart';
import 'package:e_survey/pages/dataInputPersonalInformation.dart';
import 'package:e_survey/pages/driverLicenseImage.dart';
import 'package:e_survey/pages/home.dart';
import 'package:e_survey/pages/metPage.dart';
import 'package:e_survey/pages/mySurvey.dart';
import 'package:e_survey/pages/parts.dart';
import 'package:e_survey/pages/requiredDocuments.dart';
import 'package:e_survey/pages/searchSurvey.dart';
import 'package:e_survey/pages/signin.dart';
import 'package:e_survey/pages/survey.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'View/damage_part.dart';
import 'ViewModels/MissionsViewModel.dart';
import 'args/claimsListArgs.dart';
import 'firebase_options.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
void  main()  async=>
    {
  //Get.find().scheduleTimeout(5000),

WidgetsFlutterBinding.ensureInitialized(),
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),

      await GetStorage.init(),



//FirebaseMessaging messaging = FirebaseMessaging.instance,
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler),

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
print('Got a message whilst in the foreground!');
print('Message data: ${message.data}');

if (message.notification != null) {
print('Message also contained a notification: ${message.notification}');
}
}),

      runApp(GetMaterialApp(
        initialRoute: '/',
// onGenerateRoute: (settings){
//   if(settings.name==DataInputPersonalInformation.routeName){
//     final args = settings.arguments as claimsListArgs ;
//     log("tttttttttttttttt");
//     log(args.carId);
//     log("tttttttttttttttt");
//     return MaterialPageRoute(
//       builder: (context) {
//         return  DataInputPersonalInformation(
//           companyCode: args.companyCode.toString(),
//           carId: args.carId.toString(),
//
//           vehicleNumber: args.vehicleNumber.toString(),
//         );
//       },
//     );
//   }
// },
//         getPages: [
//         //  GetPage(name: '/', page: () => const MyHomePage()),
//           GetPage(name: '/newM', page: () =>  NewMission()),
//          // GetPage(name: '/', page: () =>  Signin()),
//         ],
        routes: {
          '/home': (context) => Home(),
          '/missions': (context) => ExpertMissions(),
          '/dashboard': (context) => Dashboard(),
          '/': (context) => Signin(),
          '/mySurvey': (context) => mySurvey(),
          '/Survey': (context) => Survey(),
          '/SearchSurvey': (context) => SearchSurvey(),
          '/CarInfoInput': (context) => CarInfoInput(),
          '/RequiredDocuments': (context) => RequiredDocuments(),
          '/DriverLicenceImage': (context) => DriverLicenceImage(),
          '/DriverLicenceDashboard': (context) => DriverLicenceDashboard(),
          '/HistorySearch': (context) => HistorySearch(),
          '/policy': (context) => Policy(),
        },

      ))

    }
    ;