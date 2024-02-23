import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/accepted-mission.dart';
import 'package:e_survey/View/new_mission.dart';
import 'package:e_survey/View/tema_menu.dart';
import 'package:e_survey/ViewModels/MissionsViewModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:android_intent/android_intent.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../controllers/RefreshController.dart';
import '../pages/signin.dart';

void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class ExpertMissions extends StatefulWidget {
  const ExpertMissions({Key? key}) : super(key: key);

  @override
  State<ExpertMissions> createState() => _ExpertMissionsState();
}

class _ExpertMissionsState extends State<ExpertMissions> {
  late Position _position;
  bool _isFetchingMoreData = false;
  final RefreshController refreshController = Get.find<RefreshController>();


  final box = GetStorage();
  String token = "";
  String? filter;
  ReceivePort? _receivePort;
  final storage = FlutterSecureStorage();
  ScrollController _scrollController = ScrollController();

  // MissionsViewModel? controller; // Already nullable

  MissionsViewModel controller = Get.put(MissionsViewModel());

  @override
  void initState() {
    super.initState();
    _initTokenAndController();

    _scrollController.addListener(_onScroll);
    getPosition();
    _setupFirebaseMessaging();
    _setupForegroundTask();
    _setupPeriodicUpdates();
    ever(refreshController.needRefresh, (_) {
      if (refreshController.needRefresh.value) {
        refreshData();
        refreshController.needRefresh.value = false; // Reset the flag
      }
    });
  }

  void refreshData() {
    // Logic to refresh your data
    controller.refreshData();
  }

  void _setupFirebaseMessaging() {
    String userId = box.read("userId").toString();
    FirebaseMessaging.instance.subscribeToTopic(userId);
  }

  void _setupForegroundTask() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissionForAndroid();
      _initForegroundTask();
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        _registerReceivePort(newReceivePort);
      }
    });
  }

  void _setupPeriodicUpdates() {
    Timer.periodic(const Duration(seconds: 200), (Timer timer) async {
      controller.refreshData();
      // Position? currentPosition = await getLatAndLong();
      // if (currentPosition != null) {
      //   await TemaServiceApi().updateGeoLocation(
      //       currentPosition.latitude.toString(), currentPosition.longitude.toString(), token);
      // }
    });
  }

  void _initTokenAndController() async {
    TemaServiceApi().refreshToken(context);
    String? storedToken = await storage.read(key: "token");
    if (storedToken != null) {
      setState(() {
        token = storedToken;
      });
    }
  }

  Timer scheduleTimeout([int milliseconds = 10000]) =>
      Timer(Duration(milliseconds: milliseconds), handleTimeout);

  void handleTimeout() {
    log("kkkkkkkkkkkkkkkkkkkkk");
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isFetchingMoreData && controller != null) {
        setState(() {
          _isFetchingMoreData = true;
        });
        controller.currentPage++;
        controller.getData(page: controller.currentPage).then((_) {
          setState(() {
            _isFetchingMoreData = false;
          });
        });
      }
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "token");
    await storage.delete(key: "refresh_token");

    box.remove("userId");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Signin()));
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(box.read("userId").toString()),
      accountEmail: Text(box.read("userId").toString()),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person,
          size: 65,
          color: Colors.blue,
        ),
      ),
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
            title: Row(
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Icon(Icons.exit_to_app),
                SizedBox(
                  width: 5,
                ),
                Text('Logout'),
              ],
            ),
            onTap: () async => {logout()}),
      ],
    );

    return WithForegroundTask(
        child: Scaffold(
      drawer: Drawer(
        child: drawerItems,
      ),
      bottomNavigationBar:
          GetStorage().read('status') == "on" ? _bottomBar() : _bottomBarRed(),
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text("قائمة الطلبات"),
            InkWell(
                child: const Icon(Icons.refresh_outlined),
                onTap: () {
                  controller?.refreshData();
                })
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (String value) {
                  filter = value;
                  if (value.trim().isNotEmpty) {
                    controller!.searchMission(value);
                  } else {
                    controller!.getData();
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
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: controller.missions.length +
                        (_isFetchingMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.missions.length) {
                        // If it's the last item and we are fetching data, show spinner
                        return Center(child: CircularProgressIndicator());
                      }

                      final Mission mission = controller.missions[index];
                      print(
                          'mission ${mission.accidentId}: ${mission.accidentStatus}');
                      return InkWell(
                        key: ValueKey(mission.accidentId),

                        onTap: () => {
                          if (mission.accidentStatus.toString() == "new")
                            {_navigateAndRefresh(context, mission)}
                          else if (mission.accidentStatus.toString() ==
                              "accepted")
                            {
                              if (mission.accdentArrivedStatus == true)
                                {Get.to(TemaMenu(), arguments: mission)}
                              else
                                {Get.to(AcceptedMission(), arguments: mission)}
                            }
                        },
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
                                Text(mission.accidentCustomerName.toString(),
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
                                  mission.accidentNotification.toString(),
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
    ));
  }

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.canDrawOverlays) {
      await FlutterForegroundTask.openSystemAlertWindowSettings();
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    // Android 13 and higher, you need to allow notification permission to expose foreground service notification.
    final NotificationPermission notificationPermissionStatus =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'notification_channel_id',
        channelName: 'Foreground Notification',
        channelDescription:
            'This notification appears when the aforeground service is running.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
        buttons: [
          const NotificationButton(
            id: 'geoTracker',
            text: 'geoTracker',
            textColor: Colors.orange,
          ),
          const NotificationButton(
            id: 'testButton',
            text: 'Test',
            textColor: Colors.grey,
          ),
        ],
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<bool> _startForegroundTask() async {
    print("start fg service");

    // You can save data using the saveData function.
    await FlutterForegroundTask.saveData(key: 'customData', value: 'hello');

    // Register the receivePort before starting the service.
    final ReceivePort? receivePort = FlutterForegroundTask.receivePort;
    final bool isRegistered = _registerReceivePort(receivePort);
    if (!isRegistered) {
      print('Failed to register receivePort!');
      return false;
    }

    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Foreground Service is running',
        notificationText: 'Tap to return to the app',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() async {
    return await FlutterForegroundTask.stopService();
  }

  bool _registerReceivePort(ReceivePort? receivePort) {
    _closeReceivePort();

    if (receivePort != null) {
      _receivePort = receivePort;
      _receivePort?.listen((message) {
        if (message is int) {
          //  print('eventCount: $message');
        } else if (message is String) {
          if (message == 'onNotificationPressed') {
            Get.to(ExpertMissions());
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
      controller!.getData();
    }
  }

  Future getPosition() async {
    LocationPermission permission;
    _gpsService();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  // Future<Position> getLatAndLong() async {
  //   // _position=await Geolocator.getCurrentPosition().then((value) => value);
  //   _position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   return _position;
  // }
  //

  Future<Position?> getLatAndLong() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return null; // Return null if location service is not enabled
    }
    try {
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return _position;
    } catch (e) {
      // Handle exception (e.g., location permissions are denied)
      return null;
    }
  }

  Future _gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    }
    return true;
  }

  /*Show dialog if GPS not enabled and open settings location*/
  Future _checkGps() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AwesomeDialog(
            context: context,
            title: "services",
            body: Column(
              children: [
                const Text('Please make sure you enable GPS and try again'),
                TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      intent.launch();
                      Navigator.of(context, rootNavigator: true).pop();
                      _gpsService();
                    })
              ],
            ))
          ..show();
      }
    }
  }

  Widget _bottomBar() {
    return Material(
        color: Colors.green,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "اضغط هنا لجعل حالة التطبيق غير منوفر",
                style: TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(
                  Icons.stop,
                  color: Colors.white,
                ),
                onPressed: () async {
                  setState(() {
                    GetStorage().write("status", "off");
                  });
                  _stopForegroundTask();
                  await TemaServiceApi().updateGeoLocation(
                      _position.latitude.toString(),
                      _position.longitude.toString(),
                      token);

                  TemaServiceApi().updateGeoStatus("notAvailable", token);
                },
              ),
            ]));
  }

  Widget _bottomBarRed() {
    return Material(
      color: Colors.red,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "اضغط هنا لجعل حالة التطبيق  منوفر",
            style: TextStyle(color: Colors.white),
          ),
          IconButton(
            icon: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: () async {
              GetStorage().write("status", "on");
              setState(() {});
              TemaServiceApi().updateGeoStatus("available", token);
              _position = (await getLatAndLong())!;
              await TemaServiceApi().updateGeoLocation(
                  _position.latitude.toString(),
                  _position.longitude.toString(),
                  token);

              _startForegroundTask();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class MyTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  final _storage = FlutterSecureStorage();

//  int _eventCount = 0;
  late Position _position;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    _sendPort = sendPort;
    final customData =
        await FlutterForegroundTask.getData<String>(key: 'customData');
    print('customData: $customData');
  }

  Future<Position?> getLatAndLong() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      return null; // Return null if location service is not enabled
    }
    try {
      _position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return _position;
    } catch (e) {
      // Handle exception (e.g., location permissions are denied)
      return null;
    }
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    FlutterForegroundTask.updateService(
        notificationTitle: 'Tema Service Running...',
        notificationText: 'Enter ......');

    print('before getLong ');
    getLatAndLong();

    final token = await _storage.read(key: "token");
    print("My token: ${token ?? 'Token not available'}");

    await TemaServiceApi().updateGeoLocation(
        _position.latitude.toString(), _position.longitude.toString(), token!);
    log(_position.latitude.toString());

    print("My lattitude " + _position.latitude.toString());
    print("My longitude " + _position.longitude.toString());
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    print('onDestroy');
  }

  @override
  void onNotificationButtonPressed(String id) {
    print('onNotificationButtonPressed >> $id');
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp("/");
    _sendPort?.send('onNotificationPressed');
  }
}
