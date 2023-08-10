import 'dart:async';
import 'dart:developer';

import 'package:e_survey/args/BigArgs.dart';
import 'package:e_survey/args/CarImputArgs.dart';
import 'package:e_survey/pages/signin.dart';
import 'package:e_survey/pages/summery.dart';
import 'package:e_survey/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class DamageDashboard extends StatefulWidget {
  const DamageDashboard({Key? key}) : super(key: key);

  @override
  _DamageDashboardState createState() => _DamageDashboardState();
}

class _DamageDashboardState extends State<DamageDashboard> {
  String savedBacktLicense = "";
  static const String userIDPrefKey = 'userId_pref';
  SharedPreferences? _prefs;
  String userId = "";
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BigArgs;
    log("nnnnnnnnnnn");
    log(args.carId);
    log("nnnnnnnnnnn");
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
                Icon(Icons.home),
                Text('Home'),
              ],
            ),
            onTap: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (BuildContext context) => Home()),
                (Route<dynamic> route) => false)
            //Navigator.push(context,MaterialPageRoute(builder: (context) => Home() ))

            ),
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
            onTap: () async => {
                  await _prefs!.clear(),
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Signin())),
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => Signin()),
                      (Route<dynamic> route) => false)
                  //    Navigator.of(context).popUntil(ModalRoute.withName('/'))
                }),
      ],
    );
    return Scaffold(
      drawer: Drawer(
        child: drawerItems,
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Text("Survey Damage  Details ",
                    // style: GoogleFonts.pacifico(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 40,
                    //     color: Colors.blue)
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue),
                ),
              ),
              Expanded(
                flex: 10,
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[
                    // Text(""),
                    makeDashboardItem2(
                        "Add Damage Part ",
                        Icons.car_repair,
                        "/parts",
                        context,
                        args.carId,
                        args.doors,
                        args.bodyType,onGoBack("")),
                    makeDashboardItem2("uploads Photos", Icons.camera,
                        "/damagePictures", context, '', '', '',onGoBack("")),

                    //makeDashboardItem("", Icons.task,"/",context),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: ElevatedButton(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: ElevatedButton(
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Summery(
                                          args.carId,
                                          args.fName,
                                          args.fatherName,
                                          args.lName,
                                          args.brand,
                                          args.tradeMark,
                                          args.companyCode,
                                          args.notification,
                                          args.notificationId)));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold)),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )),
    );
  }

    void _loadUser() {
    setState(() {
      this.userId = this._prefs?.getString(userIDPrefKey) ?? "";
    });
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
