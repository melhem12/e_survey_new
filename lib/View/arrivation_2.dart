import 'dart:io';

import 'package:e_survey/View/tema_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/MissionsModel.dart';
import '../controllers/RefreshController.dart';
import '../service/TemaServiceApi.dart';
import 'expert_missions.dart';
import 'expert_missions2.dart';

class ArrivationVerification2 extends StatefulWidget {
  const ArrivationVerification2({Key? key}) : super(key: key);

  @override
  _ArrivationVerification2State createState() =>
      _ArrivationVerification2State();
}

class _ArrivationVerification2State extends State<ArrivationVerification2> {
  late Mission m;
  late Position _position;

  final box = FlutterSecureStorage();
  bool progress = false;

  @override
  void initState() {
    m = Get.arguments as Mission;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width *
        0.4; // Example width, adjust as needed
    double buttonHeight = 50;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: AppBar(
            title: Text(
              "الوصول",
              textAlign: TextAlign.right, // Align text to the right
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            titleSpacing: NavigationToolbar.kMiddleSpacing,
          ),
          body: progress
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              m.accidentNotification,
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 18),
                            ),
                            SizedBox(height: 60),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      child: Text(
                                        "غير موجود أو لا أستطيع الوصول",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () async {
                                        // Perform 'Not Arrive' action here
                                        updateArrivedStatus(false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                        textStyle: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: SizedBox(
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      child: Text(
                                        "وصلت",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      onPressed: () async {
                                       updateArrivedStatus(true);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 80),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: SizedBox(
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      child: Text(
                                        "رقم السائق",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      onPressed: () async {
                                        callNumber(m.accidentCustomerPhone);
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: SizedBox(
                                    width: buttonWidth,
                                    height: buttonHeight,
                                    child: ElevatedButton(
                                      child: Text(
                                        "مركز الاتصال",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ),
                                      onPressed: () async {
                                        callNumber("70832070");
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.blue,
                                          textStyle: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
    );
  }

  callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> updateArrivedStatus(bool status) async {
    final RefreshController refreshController = Get.find<RefreshController>();

    _position = await getLatAndLong();
    final token = await box.read(key: "token");
    bool success = await TemaServiceApi().updateArrivedStatus(
        status,
        m.accidentId,
        token.toString(),
        _position.longitude.toString(),
        _position.latitude.toString());
    if (success) {
      Get.offAll(TemaMenu(), arguments: m);
    }
    else{
      refreshController.needRefresh.value = true;
      Platform.isIOS
          ? Get.offAll(() => ExpertMissions2())
          : Get.offAll(() => ExpertMissions());
    }



  }

  Future<Position> getLatAndLong() async {
    // _position=await Geolocator.getCurrentPosition().then((value) => value);
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return _position;
  }
}
