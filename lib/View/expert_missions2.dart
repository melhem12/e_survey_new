import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/accepted-mission.dart';
import 'package:e_survey/View/new_mission.dart';
import 'package:e_survey/View/tema_menu.dart';
import 'package:e_survey/ViewModels/MissionsViewModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

// The callback function should always be a top-level function.
// void startCallback() {
//   // The setTaskHandler function must be called to handle the task in the background.
//   FlutterForegroundTask.setTaskHandler(MyTaskHandler());
// }



class ExpertMissions2 extends StatefulWidget {
  const ExpertMissions2({Key? key}) : super(key: key);

  @override
  State<ExpertMissions2> createState() => _ExpertMissions2State();
}

class _ExpertMissions2State extends State<ExpertMissions2> {
  late Position _position;
  final box = GetStorage();
  String token="";
  String? filter;
  ReceivePort? _receivePort;
  final MissionsViewModel controller =
  Get.put(MissionsViewModel(initialToken: GetStorage().read("token")));

//  ExpertMissions({Key? key}) : super(key: key);


  @override
  void initState() {

    FirebaseMessaging.instance
        .subscribeToTopic(box.read("userId").toString());
     //initializeService() ;

    super.initState();

    token=box.read("token");
    // _initForegroundTask();
    // _ambiguate(WidgetsBinding.instance)?.addPostFrameCallback((_) async {
    //   // You can get the previous ReceivePort without restarting the service.
    //   if (await FlutterForegroundTask.isRunningService) {
    //     final newReceivePort = await FlutterForegroundTask.receivePort;
    //     _registerReceivePort(newReceivePort);
    //   }
    // });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
     // await _requestPermissionForAndroid();
     // _initForegroundTask();

      // You can get the previous ReceivePort without restarting the service.
      // if (await FlutterForegroundTask.isRunningService) {
      //   final newReceivePort = FlutterForegroundTask.receivePort;
      //   _registerReceivePort(newReceivePort);
      // }
    });
    print("///////////KKKKKKKKLLLLL");

    getPosition();
    Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
      // if (!_isRunning) {
      //   timer.cancel();
      // }
      controller.getData(GetStorage().read('token'));
     // _position=   await getLatAndLong();
     // await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);
    });
  }
  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);
  void handleTimeout() {
    log("kkkkkkkkkkkkkkkkkkkkk");
  }


  @override
  Widget build (BuildContext context) {



    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(GetStorage().read("userId")),
      accountEmail: Text(box.read("userId")),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person ,size: 65,color: Colors.blue,),
      ),
      // otherAccountsPictures: <Widget>[
      //   CircleAvatar(
      //     backgroundColor: Colors.yellow,
      //     child: Text('A'),
      //   ),
      //   CircleAvatar(
      //     backgroundColor: Colors.red,
      //     child: Text('B'),
      //   )
      // ],
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        // ListTile(
        //   title:  Row(
        //     children: <Widget>[
        //       SizedBox(width: 5,),
        //       Icon(Icons.home),
        //       Text('Home'),
        //
        //     ],
        //   ),
        //
        //   onTap: () => Navigator.of(context).pushNamed('/home'),
        //
        // ),
        ListTile(
            title:  Row(
              children: <Widget>[
                SizedBox(width: 5,),
                Icon(Icons.exit_to_app),
                SizedBox(width: 5,),
                Text('Logout'),

              ],
            ),

            onTap: () async => {
              Navigator.of(context).pushNamed('/'),
              box.erase(),
            }
        ),

      ],
    );

     return
       // WithForegroundTask(
      //  child :
    Scaffold(
      drawer: Drawer(
        child: drawerItems,
      ),
      bottomNavigationBar: GetStorage().read('status')=="on"?_bottomBar():_bottomBarRed(),
      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text("قائمة الطلبات"),
            InkWell(
                child: const Icon(Icons.refresh_outlined),
                onTap: () {
                  controller.getData(GetStorage().read("token"));
                })
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 1,
                child: Text("First"),
              ),
              const PopupMenuItem(
                value: 2,
                child: Text("Second"),
              ),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // <-- alignments

          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextField(
                onChanged : (String value)  {
                  filter = value;
                  if(value.trim().isNotEmpty){
                    controller.searchMission(value);

                  }
                  else{
                    controller.getData(GetStorage("token").toString());
                  }
                },
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Colors.blue,
                  ),
                  labelText: 'Filter',
                  isDense: true,
                  fillColor: Colors.grey[300],
                  filled: true,
                  hintStyle: const TextStyle(
                    color: Colors.blue,
                  ),
                  border: InputBorder.none,
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Card(
                      color: Colors.green,
                      child: Text(""),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.blue,
                      child: Text(""),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.red,
                      child: Text(""),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.grey,
                      child: Text(""),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: const <Widget>[
                  Expanded(
                    child: Text(
                      "جديد",
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "قيد المعالجة",
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "لم يلب",
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text(
                      "مغلق",
                      textAlign: TextAlign.center,
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
            Expanded(
              flex: 17,
              child: Obx(() {
                if (controller.missions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: controller.missions.length,
                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final Mission mission = controller.missions[index];
                      print('mission ${mission.accidentId}: ${mission.accidentStatus}');
                      return InkWell(
                        key: ValueKey(mission.accidentId),

                        onTap: () => {
                          if (mission.accidentStatus.toString() == "new")
                            {_navigateAndRefresh(context, mission)}
                          else if(mission.accidentStatus.toString() == "accepted"){
                            if(mission.accdentArrivedStatus==true){
                              Get.to(TemaMenu(),arguments: mission)

                            }else{
                              Get.to(AcceptedMission(),arguments: mission)

                            }
                          }
                        }


                        ,
                        //
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    mission.accidentCustomerName.toString(),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color:
                                        mission.accidentStatus.toString() ==
                                            "new"
                                            ? Colors.green
                                            : mission.accidentStatus
                                            .toString() ==
                                            "rejected"
                                            ? Colors.red
                                            : mission.accidentStatus
                                            .toString() ==
                                            "accepted"
                                            ? Colors.blue
                                            : Colors.grey)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(mission.time.toString()),
                                    ]),
                                Text(
                                  mission.accidentId.toString(),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: mission.accidentStatus
                                          .toString() ==
                                          "new"
                                          ? Colors.green
                                          : mission.accidentStatus.toString() ==
                                          "rejected"
                                          ? Colors.red
                                          : mission.accidentStatus
                                          .toString() ==
                                          "accepted"
                                          ? Colors.blue
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }),
            ),

            // _buildContentView(),

          ],
        ),

      ),
    // )
    );
  }
  // Widget _buildContentView() {
  //   buttonBuilder(String text, {VoidCallback? onPressed}) {
  //     return ElevatedButton(
  //       child: Text(text),
  //       onPressed: onPressed,
  //     );
  //   }
  //
  //   return Center(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         buttonBuilder('start', onPressed:() async {
  //           print("start ................");
  //           await TemaServiceApi().updateGeoStatus("available", GetStorage().read("token").toString());
  //
  //           _startForegroundTask() ;
  //
  //
  //         }
  //         ),
  //         buttonBuilder('stop', onPressed:() async {
  //           _stopForegroundTask();
  //           await TemaServiceApi().updateGeoStatus("notAvailable", GetStorage().read("token"));
  //
  //         } ),
  //       ],
  //     ),
  //   );
  // }

//   open(Mission mission , context) {
// if(mission.accidentStatus=="new"){
//  // Get.toNamed("/newMission");
//   Get.to(NewMission());
// //Navigator.push(context, NewMission());
// }







  // Future<void> _initForegroundTask() async {
  //   FlutterForegroundTask.init(
  //       androidNotificationOptions: AndroidNotificationOptions(
  //         channelId: 'notification_channel_id',
  //         channelName: 'Foreground Notification',
  //         channelDescription:
  //         'This notification appears when the foreground service is running.',
  //         channelImportance: NotificationChannelImportance.DEFAULT,
  //         priority: NotificationPriority.DEFAULT,
  //         iconData: const NotificationIconData(
  //           resType: ResourceType.mipmap,
  //           resPrefix: ResourcePrefix.ic,
  //           name: 'launcher',
  //           backgroundColor: Colors.orange,
  //         ),
  //         buttons: [
  //           const NotificationButton(id: 'geoTracker', text: 'geoTracker'),
  //           const NotificationButton(id: 'testButton', text: 'Test'),
  //         ],
  //       ),
  //       iosNotificationOptions: const IOSNotificationOptions(
  //         showNotification: true,
  //         playSound: true,
  //       ),
  //       foregroundTaskOptions: const ForegroundTaskOptions(
  //         interval: 5000,
  //         autoRunOnBoot: true,
  //         allowWifiLock: true,
  //       )
  //   );
  // }


  // Future<void> _requestPermissionForAndroid() async {
  //   if (!Platform.isAndroid) {
  //     return;
  //   }
  //
  //   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  //   // onNotificationPressed function to be called.
  //   //
  //   // When the notification is pressed while permission is denied,
  //   // the onNotificationPressed function is not called and the app opens.
  //   //
  //   // If you do not use the onNotificationPressed or launchApp function,
  //   // you do not need to write this code.
  //   if (!await FlutterForegroundTask.canDrawOverlays) {
  //     // This function requires `android.permission.SYSTEM_ALERT_WINDOW` permission.
  //     await FlutterForegroundTask.openSystemAlertWindowSettings();
  //   }
  //
  //   // Android 12 or higher, there are restrictions on starting a foreground service.
  //   //
  //   // To restart the service on device reboot or unexpected problem, you need to allow below permission.
  //   if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
  //     // This function requires `android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` permission.
  //     await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  //   }
  //
  //   // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
  //   final NotificationPermission notificationPermissionStatus =
  //   await FlutterForegroundTask.checkNotificationPermission();
  //   if (notificationPermissionStatus != NotificationPermission.granted) {
  //     await FlutterForegroundTask.requestNotificationPermission();
  //   }
  // }


  // void _initForegroundTask() {
  //   FlutterForegroundTask.init(
  //     androidNotificationOptions: AndroidNotificationOptions(
  //       id: 500,
  //       channelId: 'notification_channel_id',
  //       channelName: 'Foreground Notification',
  //       channelDescription:
  //       'This notification appears when the foreground service is running.',
  //       channelImportance: NotificationChannelImportance.HIGH,
  //       priority: NotificationPriority.HIGH,
  //       iconData: const NotificationIconData(
  //         resType: ResourceType.mipmap,
  //         resPrefix: ResourcePrefix.ic,
  //         name: 'launcher',
  //         backgroundColor: Colors.orange,
  //       ),
  //       buttons: [
  //         const NotificationButton(
  //           id: 'geoTracker',
  //           text: 'geoTracker',
  //           textColor: Colors.orange,
  //         ),
  //         const NotificationButton(
  //           id: 'testButton',
  //           text: 'Test',
  //           textColor: Colors.grey,
  //         ),
  //       ],
  //     ),
  //     iosNotificationOptions: const IOSNotificationOptions(
  //       showNotification: true,
  //       playSound: false,
  //     ),
  //     foregroundTaskOptions: const ForegroundTaskOptions(
  //       interval: 5000,
  //       isOnceEvent: false,
  //       autoRunOnBoot: true,
  //       allowWakeLock: true,
  //       allowWifiLock: true,
  //     ),
  //   );
  // }




  // Future<bool> _startForegroundTask() async {
  //   print("start fg service");
  //   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  //   // onNotificationPressed function to be called.
  //   //
  //   // When the notification is pressed while permission is denied,
  //   // the onNotificationPressed function is not called and the app opens.
  //   //
  //   // If you do not use the onNotificationPressed or launchApp function,
  //   // you do not need to write this code.
  //   if (!await FlutterForegroundTask.canDrawOverlays) {
  //     final isGranted =
  //     await FlutterForegroundTask.openSystemAlertWindowSettings();
  //     if (!isGranted) {
  //       print('SYSTEM_ALERT_WINDOW permission denied!');
  //       return false;
  //     }
  //   }
  //
  //   // You can save data using the saveData function.
  //   await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
  //
  //   ReceivePort? receivePort;
  //   if (await FlutterForegroundTask.isRunningService) {
  //     return FlutterForegroundTask.restartService();
  //   } else {
  //     return FlutterForegroundTask.startService(
  //       notificationTitle: 'Foreground Service is running',
  //       notificationText: 'Tap to return to the app',
  //       callback: startCallback,
  //
  //
  //
  //     );
  //   }
  //
  //   return _registerReceivePort(receivePort);
  // }





  // Future<bool> _startForegroundTask() async {
  //   print("start fg service");
  //
  //   // You can save data using the saveData function.
  //   await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');
  //
  //   // Register the receivePort before starting the service.
  //   final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
  //   final bool isRegistered = _registerReceivePort(receivePort);
  //   if (!isRegistered) {
  //     print('Failed to register receivePort!');
  //     return false;
  //   }
  //
  //   if (await FlutterForegroundTask.isRunningService) {
  //     return FlutterForegroundTask.restartService();
  //   } else {
  //     return FlutterForegroundTask.startService(
  //       notificationTitle: 'Foreground Service is running',
  //       notificationText: 'Tap to return to the app',
  //       callback: startCallback,
  //     );
  //   }
  // }




  // Future<bool> _stopForegroundTask() async {
  //   return await FlutterForegroundTask.stopService();
  // }

  bool _registerReceivePort(ReceivePort? receivePort) {
    _closeReceivePort();

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        if (message is int) {
          //  print('eventCount: $message');
        } else if (message is String) {
          if (message == 'onNotificationPressed') {
            Get.to(ExpertMissions2());
          }
        } else if (message is DateTime) {
          print('timestamp: ${message.toString()}');
        }
      });

      return true;
    }

    return false;
  }

  void _closeReceivePort() {
    _receivePort?.close();
    _receivePort = null;
  }

  T? _ambiguate<T>(T? value) => value;












  void _navigateAndRefresh(BuildContext context, Mission mission) async {
    final result = await Get.to(const NewMission(), arguments: mission);
    if (result != null) {
      //mission.getEMR(''); // call your own function here to refresh screen
      controller.getData(GetStorage().read("token"));
      // Get.reloadAll(force: true ,key:key);
      //Get.reset();
    }
  }










  Future getPosition() async{
    LocationPermission permission;
    _gpsService();
    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
    }

  }
  Future<Position> getLatAndLong() async{
    // _position=await Geolocator.getCurrentPosition().then((value) => value);
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return _position;
  }
  Future _gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    }
    return true;
  }


  // Future<void> initializeService() async {
  //   final service = FlutterBackgroundService();
  //  // service.invoke("setAsForeground");
  //   /// OPTIONAL, using custom notification channel id
  //   // const AndroidNotificationChannel channel = AndroidNotificationChannel(
  //   //   'my_foreground', // id
  //   //   'MY FOREGROUND SERVICE', // title
  //   //   description:
  //   //   'This channel is used for important notifications.', // description
  //   //   importance: Importance.low, // importance must be at low or higher level
  //   // );
  //
  //   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //   // FlutterLocalNotificationsPlugin();
  //
  //   if (Platform.isIOS || Platform.isAndroid) {
  //     // await flutterLocalNotificationsPlugin.initialize(
  //     //   const InitializationSettings(
  //     //     iOS: DarwinInitializationSettings(),
  //     //     android: AndroidInitializationSettings('ic_bg_service_small'),
  //     //   ),
  //     // );
  //   }
  //
  //
  //   // await flutterLocalNotificationsPlugin
  //   //     .resolvePlatformSpecificImplementation<
  //   //     AndroidFlutterLocalNotificationsPlugin>()
  //   //     ?.createNotificationChannel(channel);
  //
  //   await service.configure(
  //     androidConfiguration: AndroidConfiguration(
  //       // this will be executed when app is in foreground or background in separated isolate
  //       onStart: onStart,
  //
  //       // auto start service
  //       autoStart: true,
  //       isForegroundMode: true,
  //
  //       notificationChannelId: 'my_foreground',
  //       initialNotificationTitle: 'AWESOME SERVICE',
  //       initialNotificationContent: 'Initializing',
  //       foregroundServiceNotificationId: 888,
  //     ),
  //     iosConfiguration: IosConfiguration(
  //       // auto start service
  //       autoStart: true,
  //
  //       // this will be executed when app is in foreground in separated isolate
  //       onForeground: onStart,
  //
  //       // you have to enable background fetch capability on xcode project
  //       onBackground: onIosBackground,
  //     ),
  //   );
  //
  //   service.startService();
  // }






  // @pragma('vm:entry-point')
  // Future<bool> onIosBackground(ServiceInstance service) async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   DartPluginRegistrant.ensureInitialized();
  //
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.reload();
  //   final log = preferences.getStringList('log') ?? <String>[];
  //   log.add(DateTime.now().toIso8601String());
  //   await preferences.setStringList('log', log);
  //
  //   return true;
  // }












  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {

        AwesomeDialog(context: context ,title: "services",body:Column(
          children: [
            const Text('Please make sure you enable GPS and try again'),
            TextButton(child: Text('Ok'),
                onPressed: () {
                  final AndroidIntent intent = AndroidIntent(
                      action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                  intent.launch();
                  Navigator.of(context, rootNavigator: true).pop();
                  _gpsService();
                })
          ],

        ) )..show();

      }
    }
  }
  Widget _bottomBar(){
    return Material(
        color:Colors.green,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              const Text("اضغط هنا لجعل حالة التطبيق غير منوفر",style: TextStyle(color: Colors.white),)
              ,
              IconButton( icon: const Icon(Icons.stop,color: Colors.white,), onPressed: () async {


                // final service = FlutterBackgroundService();
                // var isRunning = await service.isRunning();
                // if (isRunning) {
                //   service.invoke('stopService');
                // }

                sendToNative(0);

                setState(()  {

                  GetStorage().write("status", "off");
                });



                //_stopForegroundTask();
            //    await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);

                TemaServiceApi().updateGeoStatus("notAvailable", GetStorage().read("token"));
              },

              ),
            ]
        )
    );
  }
  Widget _bottomBarRed(){
    return Material(
      color:Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          const Text("اضغط هنا لجعل حالة التطبيق  منوفر",style: TextStyle(color: Colors.white),)

          ,IconButton( icon: const Icon(Icons.play_arrow ,color: Colors.white,), onPressed: () async {

            GetStorage().write("status", "on");



            sendToNative(2);

            // final service = FlutterBackgroundService();
            // var isRunning = await service.isRunning();
            // service.invoke("setAsBackground");
            // if (!isRunning) {
            //   service.startService();
            // }




            setState(()  {



            });
            TemaServiceApi().updateGeoStatus("available", GetStorage().read("token").toString());
            _position=   await getLatAndLong();
        //    await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);

            //_startForegroundTask() ;










          },

          ),



        ],
      ),
    );
  }


  Future<void> sendToNative(int val) async {
    const MethodChannel _channel =
    const MethodChannel("FlutterFramework/swift_native");


    final arguments = {
      'value1': val,
      'value2': 3,
      'token': box.read('token'),

    };


    final result = await _channel.invokeMethod('getSum',arguments);
    print("result from iOS native + Swift ${result}");
  }


}





// class MyTaskHandler extends TaskHandler {
//   SendPort? _sendPort;
//
// //  int _eventCount = 0;
//   late Position _position;
//   Future<Position> getLatAndLong() async{
//     print('getLatAndLong  ---- ');
//     _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//     return _position;
//   }
//   // @override
//   // Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//   //   _sendPort = sendPort;
//   //
//   //   // You can use the getData function to get the stored data.
//   //   final customData =
//   //   await FlutterForegroundTask.getData<String>(key: 'customData');
//   //   print('customData: $customData');
//   // }
//
//   @override
//   Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
//     _sendPort = sendPort;
//
//     // You can use the getData function to get the stored data.
//     final customData =
//     await FlutterForegroundTask.getData<String>(key: 'customData');
//     print('customData: $customData');
//   }
//
//   // @override
//   // Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
//   //   FlutterForegroundTask.updateService(
//   //     notificationTitle: 'Tema Service Running...',
//   //     //notificationText: 'eventCount: $_eventCount'
//   //   );
//   //
//   //   // Send data to the main isolate.
//   //   // sendPort?.send(_eventCount);
//   //
//   //   // _eventCount++
//   //   // ;
//   //   print('before getLong ');
//   //   getLatAndLong();
//   //
//   //   print("My token "+GetStorage().read("token"));
//   //
//   //   TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), GetStorage().read("token"));
//   //
//   //   print("My lattitude "+_position.latitude.toString());
//   //   print("My longitude "+_position.longitude.toString());
//   // }
//
//
//
//   @override
//   Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
//     FlutterForegroundTask.updateService(
//
//
//
//         notificationTitle: 'Tema Service Running...',
//         notificationText: 'Enter ......'
//
//     );
//
//     // // Send data to the main isolate.
//     // sendPort?.send(_eventCount);
//     //
//     // _eventCount++;
//
//
//     print('before getLong ');
//     getLatAndLong();
//
//     final token = GetStorage().read("token");
//     print("My token: ${token ?? 'Token not available'}");
//
//     await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);
//     log(_position.latitude.toString());
//
//
//     print("My lattitude "+_position.latitude.toString());
//     print("My longitude "+_position.longitude.toString());
//
//   }
//
//
//
//
//   @override
//   Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
//     print('onDestroy');
//   }
//
//   // Called when the notification button on the Android platform is pressed.
//   @override
//   void onNotificationButtonPressed(String id) {
//     print('onNotificationButtonPressed >> $id');
//   }
//
//   // Called when the notification itself on the Android platform is pressed.
//   //
//   // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
//   // this function to be called.
//   @override
//   void onNotificationPressed() {
//     // Note that the app will only route to "/resume-route" when it is exited so
//     // it will usually be necessary to send a message through the send port to
//     // signal it to restore state when the app is already started.
//     FlutterForegroundTask.launchApp("/");
//     _sendPort?.send('onNotificationPressed');
//   }
//
//
// }








// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Only available for flutter 3.0.0 and later
//   DartPluginRegistrant.ensureInitialized();
//
//   // For flutter prior to version 3.0.0
//   // We have to register the plugin manually
//
//   SharedPreferences preferences = await SharedPreferences.getInstance();
//   await preferences.setString("hello", "world");
//
//   /// OPTIONAL when use custom notification
//   // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//   // FlutterLocalNotificationsPlugin();
//
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });
//
//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   // bring to foreground
//   Timer.periodic(const Duration(seconds: 4), (timer) async {
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         /// OPTIONAL for use custom notification
//         /// the notification id must be equals with AndroidConfiguration when you call configure() method.
//         // flutterLocalNotificationsPlugin.show(
//         //   888,
//         //   'COOL SERVICE',
//         //   'Awesome ${DateTime.now()}',
//         //   const NotificationDetails(
//         //     android: AndroidNotificationDetails(
//         //       'my_foreground',
//         //       'MY FOREGROUND SERVICE',
//         //       icon: 'ic_bg_service_small',
//         //       ongoing: true,
//         //     ),
//         //   ),
//         // );
//
//         // if you don't using custom notification, uncomment this
//         service.setForegroundNotificationInfo(
//           title: "My App Service",
//           content: "Updated at ${DateTime.now()}",
//         );
//       }
//     }
//
//     /// you can see this log in logcat
//     print('FLUTTER BACKGROUND SERVICE: ${DateTime.now()}');
// //var _position=   await getLatAndLong();
//    // print('lattitude: ${_position.latitude}');
//
//   // await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), GetStorage().read('token'));
//     // test using external plugin
//     final deviceInfo = DeviceInfoPlugin();
//     String? device;
//     if (Platform.isAndroid) {
//       final androidInfo = await deviceInfo.androidInfo;
//       device = androidInfo.model;
//     }
//
//     if (Platform.isIOS) {
//       final iosInfo = await deviceInfo.iosInfo;
//       device = iosInfo.model;
//     }
//
//     service.invoke(
//       'update',
//       {
//         "current_date": DateTime.now().toIso8601String(),
//         "device": device,
//       },
//     );
//   });
// }







Future<Position> getLatAndLong() async{
  // _position=await Geolocator.getCurrentPosition().then((value) => value);
 var  _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

  return _position;
}