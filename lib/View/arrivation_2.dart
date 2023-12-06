import 'dart:io';

import 'package:e_survey/View/tema_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:geolocator/geolocator.dart';

import '../Models/MissionsModel.dart';
import '../service/TemaServiceApi.dart';
import 'expert_missions.dart';
import 'expert_missions2.dart';

class ArrivationVerification2 extends StatefulWidget {
  const ArrivationVerification2({Key? key}) : super(key: key);

  @override
  _ArrivationVerification2State createState() => _ArrivationVerification2State();
}

class _ArrivationVerification2State extends State<ArrivationVerification2> {
  late Mission m;
  late Position _position;

  final box = GetStorage();
  bool progress = false;

  @override
  void initState() {
    m = Get.arguments as Mission;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text("Arrive"),
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
                    m.accidentId,
                    style: TextStyle(color: Colors.blue, fontSize: 18),
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[


                      Expanded(
                        flex: 1,
                        child: Container(
                          child: ElevatedButton(
                            child: Text(
                              "غير موجود أو لا أستطيع الوصول ",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                            onPressed: () async {
                              // Perform 'Not Arrive' action here
                              _position=   await getLatAndLong();
                              // Perform 'Arrive' action here
                              bool success = await TemaServiceApi()
                                  .updateArrivedStatus(false, m.accidentId, box.read('token'),_position.longitude.toString(),_position.latitude.toString());
                              if (success) {

                                Platform.isIOS?
                                Get.offAll(()=>ExpertMissions2()):
                                Get.offAll(()=>ExpertMissions());                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),











                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),


                      Expanded(
                        flex: 1,
                        child: Container(
                          child: ElevatedButton(
                            child: Text(
                              "وصلت",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                            onPressed: () async {
                              _position=   await getLatAndLong();
                              // Perform 'Arrive' action here
                              bool success = await TemaServiceApi()
                                  .updateArrivedStatus(true, m.accidentId, box.read('token'),_position.longitude.toString(),_position.latitude.toString());
                              if (success) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text("Arrival Success"),
                                      content: Text("Success"),
                                    );
                                  },
                                );
                                Get.offAll(TemaMenu(), arguments: m);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const AlertDialog(
                                      title: Text("Arrival Failed"),
                                      content: Text("Failed to arrive"),
                                    );
                                  },
                                );
                              }
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
                  const SizedBox(height: 60),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
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
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
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
      ),
    );
  }

  callNumber(String number) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
  Future<Position> getLatAndLong() async{
    // _position=await Geolocator.getCurrentPosition().then((value) => value);
    _position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    return _position;
  }
}
