import 'dart:async';

import 'package:e_survey/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DriverLicenceDashboard extends StatefulWidget {
  const DriverLicenceDashboard({Key? key}) : super(key: key);

  @override
  _DriverLicenceDashboardState createState() => _DriverLicenceDashboardState();
}

class _DriverLicenceDashboardState extends State<DriverLicenceDashboard> {
  static const String backLicencePrefKey = 'back_licence_pref';
  SharedPreferences? _prefs;
  String savedFrontLicense ="";
  static const String frontLicencePrefKey = 'front_licence_pref';
  String savedBacktLicense ="";
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
    return   Scaffold(

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
                  //     fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blue),
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue)),




              ),
              Expanded(
                flex:3,
                child: GridView.count(
                  crossAxisCount: 2,

                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[

                    // Text(""),
                    makeDashboardItem2("Front Side Of Driver License", savedFrontLicense.isNotEmpty?Icons.check:Icons.camera,"/DriverLicenceImage",context,'','','',onGoBack("")),
                    makeDashboardItem2("Back Side Of Driver License",savedBacktLicense.isNotEmpty?Icons.check:Icons.camera,"/BackDriverLicenceImage",context,'','','',onGoBack("")),


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
                        )
                    ),



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

    });
    
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
