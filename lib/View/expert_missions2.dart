import 'dart:async';
import 'dart:developer';

import 'package:android_intent/android_intent.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/accepted-mission.dart';
import 'package:e_survey/View/new_mission.dart';
import 'package:e_survey/View/tema_menu.dart';
import 'package:e_survey/ViewModels/MissionsViewModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../controllers/RefreshController.dart';
import '../pages/signin.dart';

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

class _ExpertMissions2State extends State<ExpertMissions2>
    with WidgetsBindingObserver {
  late Position _position;
  // final box = GetStorage();
  late String token;
  late String refreshToken;
  String userId = "";
  bool _isFetchingMoreData = false;
  final RefreshController refreshController = Get.find<RefreshController>();

  ScrollController _scrollController = ScrollController();

  final storage = FlutterSecureStorage();

  String? filter;
  MissionsViewModel controller = Get.put(MissionsViewModel());

//  ExpertMissions({Key? key}) : super(key: key);

  @override
  void initState() {
    getPosition();
    _setupFirebaseMessaging();
    _initTokenAndController();
    refreshData();
    _scrollController.addListener(_onScroll);
    // _setupPeriodicUpdates();
    ever(refreshController.needRefresh, (_) {
      if (refreshController.needRefresh.value) {
        refreshData();
        refreshController.needRefresh.value = false; // Reset the flag
      }
    });

    //initializeService() ;

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
    print("///////////KKKKKKKKLLLLL");
    WidgetsBinding.instance.addObserver(this);
  }

  void refreshData() {
    TemaServiceApi().refreshToken(context);
    // Logic to refresh your data
    controller.refreshData();
  }

  // void _setupPeriodicUpdates() {
  //   Timer.periodic(const Duration(seconds: 10), (Timer timer) async {
  //     controller.refreshData();
  //   });
  // }

  void _setupFirebaseMessaging() async{
    String? userId = await storage.read(key: "userId");
    FirebaseMessaging.instance.subscribeToTopic(userId!);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshData();

      // Code to execute when the app is resumed
      print('App resumed');
    }
  }

  void _initTokenAndController() async {
    String? storedToken = await storage.read(key: "token");
    String? storedRefreshToken = await storage.read(key: "refresh_token");
    String? storedUser = await storage.read(key: "userId");
    TemaServiceApi().refreshToken(context);
    storedToken = await storage.read(key: "token");
    storedRefreshToken = await storage.read(key: "refresh_token");
    if (storedToken != null) {
      setState(() {
        token = storedToken!;
        refreshToken=storedRefreshToken!;
        userId=storedUser!;
      });
    }
  }

  // Timer scheduleTimeout([int milliseconds = 10000]) =>
  //     Timer(Duration(milliseconds: milliseconds), handleTimeout);

  // void handleTimeout() {
  //   log("kkkkkkkkkkkkkkkkkkkkk");
  // }

  Future<void> logout() async {
    await storage.delete(key: "token");
    await storage.delete(key: "refresh_token");
    await storage.delete(key: "userId");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Signin()));
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(userId),
      accountEmail: Text(userId),
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

    return
        // WithForegroundTask(
        //  child :
        Scaffold(
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
                  controller.refreshData();
                })
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              // const PopupMenuItem(
              //   value: 1,
              //   child: Text("First"),
              // ),
              // const PopupMenuItem(
              //   value: 2,
              //   child: Text("Second"),
              // ),
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
                onChanged: (String value) {
                  filter = value;
                  if (value.trim().isNotEmpty) {
                    controller.searchMission(value);
                  } else {
                    controller.getData();
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
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          mission.accidentCustomerName
                                              .toString(),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: mission.accidentStatus
                                                          .toString() ==
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
                                      Text(mission.date.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle()),
                                    ]),
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
      // )
    );
  }

  T? _ambiguate<T>(T? value) => value;

  void _navigateAndRefresh(BuildContext context, Mission mission) async {
    final result = await Get.to(const NewMission(), arguments: mission);
    if (result != null) {
      //mission.getEMR(''); // call your own function here to refresh screen
      controller.getData();
      // Get.reloadAll(force: true ,key:key);
      //Get.reset();
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

  // Future<Position> getLatAndLong() async {
  //   // _position=await Geolocator.getCurrentPosition().then((value) => value);
  //   _position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //
  //   return _position;
  // }

  Future _gpsService() async {
    if (!(await Geolocator.isLocationServiceEnabled())) {
      _checkGps();
      return null;
    }
    return true;
  }

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

                  // final service = FlutterBackgroundService();
                  // var isRunning = await service.isRunning();
                  // if (isRunning) {
                  //   service.invoke('stopService');
                  // }
                  TemaServiceApi().refreshToken(context);
                  TemaServiceApi().updateGeoStatus("notAvailable", token);

                  int time=  await  TemaServiceApi().getWorkingTime(token );

                  sendToNative(0, token,refreshToken,time);

                  setState(() {
                    GetStorage().write("status", "off");
                  });

                  //_stopForegroundTask();
                  //    await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);

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
              TemaServiceApi().refreshToken(context);
              int time=  await  TemaServiceApi().getWorkingTime(token );
              TemaServiceApi().updateGeoStatus("available", token);
              sendToNative(2, token,refreshToken,time);

              // final service = FlutterBackgroundService();
              // var isRunning = await service.isRunning();
              // service.invoke("setAsBackground");
              // if (!isRunning) {
              //   service.startService();
              // }

              setState(() {});
              _position = await getLatAndLong();
              //    await TemaServiceApi().updateGeoLocation(_position.latitude.toString(), _position.longitude.toString(), token);

              //_startForegroundTask() ;
            },
          ),
        ],
      ),
    );
  }

  Future<void> sendToNative(int val, String token,String refreshToken,int time) async {
    const MethodChannel _channel =
        const MethodChannel("FlutterFramework/swift_native");

    final arguments = {
      'value1': val,
      'value2': 3,
      'token': token,
      'refreshToken': refreshToken,
      'time':time
    };

    final result = await _channel.invokeMethod('getSum', arguments);
    print("result from iOS native + Swift ${result}");
  }
}

Future<Position> getLatAndLong() async {
  // _position=await Geolocator.getCurrentPosition().then((value) => value);
  var _position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  return _position;
}
