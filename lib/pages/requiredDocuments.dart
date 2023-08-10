
import 'dart:async';
import 'dart:developer';

import 'package:e_survey/args/BigArgs.dart';
import 'package:e_survey/args/CarImputArgs.dart';
import 'package:e_survey/pages/dataInputCarInformation.dart';
import 'package:e_survey/pages/signin.dart';
import 'package:e_survey/utility/LifecycleWatcherState.dart';
import 'package:e_survey/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'damage_dashboard.dart';
import 'home.dart';
class RequiredDocuments extends StatefulWidget {
  const RequiredDocuments({Key? key}) : super(key: key);

  @override
  _RequiredDocumentsState createState() => _RequiredDocumentsState();
}

class _RequiredDocumentsState extends LifecycleWatcherState<RequiredDocuments>  {
  static const String policyPrefKey = 'policy_pref';
  String savedPolicy ="";
  static const String vinPrefKey = 'vin';
  String savedVin ="";
  static const String backLicencePrefKey = 'back_licence_pref';
  SharedPreferences? _prefs;
  String savedFrontLicense ="";
  static const String frontLicencePrefKey = 'front_licence_pref';
  String savedBacktLicense ="";
  static const String userIDPrefKey = 'userId_pref';
  String userId="";
  static const String backCarRegistrationrefKey = 'back_CarRegistration_pref';
  String savedFrontCarRegistration ="";
  static const String frontCarRegistrationPrefKey = 'front_CarRegistration_pref';
  String savedBackCarRegistration="";
  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      this._prefs=prefs);
      _loadImageDir();

    });

    super.initState();
  }





  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(userId),
      accountEmail: Text(userId),
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
        ListTile(
          title:  Row(
            children: <Widget>[
              SizedBox(width: 5,),
              Icon(Icons.home),
              Text('Home'),

            ],
          ),

          onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => Home() ))

        ),
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
              await   _prefs!.clear(),
//Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>Signin())),
            Navigator.of(context)
                  .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
                Signin()), (Route<dynamic> route) => false)
        //    Navigator.of(context).popUntil(ModalRoute.withName('/'))
            }
        ),

      ],
    );

    final args =ModalRoute.of(context)!.settings.arguments as BigArgs;
    log("nnnnnnnnnnn") ;
    log(args.carId);
    log("nnnnnnnnnnn") ;
    return   Scaffold(
      drawer: Drawer(
        child: drawerItems,
      ),
      body:
      Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),

          child:Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(

                flex: 1, child:   Text("Documents required",
                  // style: GoogleFonts.pacifico(
                  //     fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blue)

              ),
              ),
              Expanded(
                flex:6,
                child: GridView.count(
                  crossAxisCount: 2,

                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[

                    // Text(""),
                    makeDashboardItem2("Driving License ", savedFrontLicense.isNotEmpty&&savedBacktLicense.isNotEmpty?Icons.check:Icons.drive_eta ,"/DriverLicenceDashboard",context,'','','',onGoBack("")),
                    makeDashboardItem2("Car Registration", savedFrontCarRegistration.isNotEmpty&&savedBackCarRegistration.isNotEmpty?Icons.check:Icons.car_rental,"/carRegistration",context,'','','',onGoBack("")),
                    makeDashboardItem2("Vin number", savedVin.isNotEmpty?Icons.check:Icons.car_rental,"/vin",context,'','','',onGoBack("")),
                    makeDashboardItem2("policy", savedPolicy.isNotEmpty?Icons.check:Icons.task,"/policy",context,'','','',onGoBack("")),

                    //makeDashboardItem("", Icons.task,"/",context),

                  ],
                ),
              ),


Expanded(
  flex: 1,

  child:

SizedBox(

),
),
          Expanded(
            flex: 1,
            child:


              Row(
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
                                  fontSize: 30,
                                  fontWeight:
                                  FontWeight.bold)),
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
                          onPressed: ()  {
                            Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DamageDashboard(),settings: RouteSettings(
                                arguments:BigArgs (carId: args.carId,bodyType: args.bodyType,doors: args.doors,fName: args.fName,fatherName:args.fatherName,lName:args.lName,brand: args.brand,tradeMark: args.tradeMark,companyCode: args.companyCode,notification: args.notification,notificationId: args.notificationId),
                                )),
                            ).then(onGoBack);

                            }
,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  fontWeight:
                                  FontWeight.bold)),
                        ),
                      ))

                ],
              ),
          )
              ,

            ]

            ,)


      ),



    );
  }
  void _loadImageDir(){
    setState(() {
      this.savedBacktLicense=this._prefs?.getString(backLicencePrefKey)??"";
      this.savedFrontLicense=this._prefs?.getString(frontLicencePrefKey)??"";
      this.savedBackCarRegistration=this._prefs?.getString(backCarRegistrationrefKey)??"";
      this.savedFrontCarRegistration=this._prefs?.getString(frontCarRegistrationPrefKey)??"";
      this.userId=this._prefs?.getString(userIDPrefKey)??"";
      this.savedVin=this._prefs?.getString(vinPrefKey)??"";
      this.savedPolicy=this._prefs?.getString(policyPrefKey)??"";
    });
  }

  @override
  void onDetached() {

  }

  @override
  void onInactive() {
  }

  @override
  void onPaused() {
  }

  @override
  void onResumed() {

  }
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
