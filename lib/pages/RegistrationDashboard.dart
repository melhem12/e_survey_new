import 'dart:async';

import 'package:e_survey/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class RegistrationDashboard extends StatefulWidget {
  const RegistrationDashboard({Key? key}) : super(key: key);

  @override
  _RegistrationDashboardState createState() => _RegistrationDashboardState();
}

class _RegistrationDashboardState extends State<RegistrationDashboard> {
  static const String backCarRegistrationrefKey = 'back_CarRegistration_pref';
  SharedPreferences? _prefs;
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

                flex: 1, child:   Text("Car Registration",
                  // style: GoogleFonts.pacifico(
                  //     fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blue)
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue),

              ),
              ),
              Expanded(
                flex:3,
                child: GridView.count(
                  crossAxisCount: 2,

                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[

                    // Text(""),
                    makeDashboardItem2("Front Side Of Car Registration", savedFrontCarRegistration.isNotEmpty?Icons.check:Icons.camera,"/FrontCarRegistrationImage",context,'','','',onGoBack("")),
                    makeDashboardItem2("Back Side Of Car Registration",savedBackCarRegistration.isNotEmpty?Icons.check:Icons.camera,"/BackCarRegistrationImage",context,'','','',onGoBack("")),


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
      this.savedBackCarRegistration=this._prefs?.getString(backCarRegistrationrefKey)??"";
      this.savedFrontCarRegistration=this._prefs?.getString(frontCarRegistrationPrefKey)??"";

    });
  }
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }
}
