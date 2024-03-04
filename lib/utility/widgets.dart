import 'dart:async';

import 'package:e_survey/View/expert_missions.dart';
import 'package:e_survey/View/expert_missions2.dart';
import 'package:e_survey/args/CarImputArgs.dart';
import 'package:e_survey/pages/BackCarRegistration.dart';
import 'package:e_survey/pages/BackLicenseImage.dart';
import 'package:e_survey/pages/CarRegistrationDashboard.dart';
import 'package:e_survey/pages/DamagedPictures.dart';
import 'package:e_survey/pages/DriverLicenceDashboard.dart';
import 'package:e_survey/pages/FrontCarRegistration.dart';
import 'package:e_survey/pages/Policy.dart';
import 'package:e_survey/pages/RegistrationDashboard.dart';
import 'package:e_survey/pages/Vin.dart';
import 'package:e_survey/pages/driverLicenseImage.dart';
import 'package:e_survey/pages/home.dart';
import 'package:e_survey/pages/parts.dart';
import 'package:e_survey/pages/requiredDocuments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Color.fromRGBO(50, 62, 72, 1.0)),
     hintText: hintText,
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}
late final VoidCallback callback;

Card makeDashboardItem(String title, IconData icon,String path,BuildContext context) {
  return Card(
      elevation: 2,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: new InkWell(
          onTap: () {
            if(path=="/missions2"){
              Get.to(()=>ExpertMissions2());
              //Navigator.pushNamed(context, path);
             // Get.toNamed(path);
            }
            if(path=="/missions"){
              Get.to(()=>ExpertMissions());
              //Navigator.pushNamed(context, path);
              // Get.toNamed(path);
            }
            else {
              Get.toNamed(path);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.blue,
                  )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    textAlign: TextAlign.center,
                    style:
                    new TextStyle(fontSize: 18.0, color: Colors.black)),
              )
            ],
          ),
        ),
      ));
}

Card makeDashboardItem2(String title, IconData icon, String path,BuildContext context,String carId ,String var1 ,String var2, FutureOr futureOr) {
  return Card(
      elevation: 2,
      margin: new EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: InkWell(
          onTap: () {if(
          path=='/DriverLicenceDashboard'
          ){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>DriverLicenceDashboard()));
          }

          if(
          path=='/DriverLicenceImage'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>DriverLicenceImage()));
          }
          if(
          path=='/BackDriverLicenceImage'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>BackLicenseImage()));
          }
          if(
          path=='/FrontCarRegistrationImage'
          ){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>FrontCarRegistration()));
          }
          if(
          path=='/BackCarRegistrationImage'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>BackCarRegistration()));
          }
          if(
          path=='/carRegistration'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationDashboard()));
          }

          if(
          path=='/damagePictures'
          ){
            // Navigator.push(context,MaterialPageRoute(builder: (context)=>DamagedPictures()));
          }
          if(
          path=='/parts'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>parts(var1, var2,carId)));
          }
          if(
          path=='/vin'
          ){
            var value ;
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Vin()));
          }
          if(
          path=='/policy'
          ){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Policy())).then((value) => futureOr);
          }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              SizedBox(height: 50.0),
              Center(
                  child: Icon(
                    icon,
                    size: 40.0,
                    color: Colors.blue,
                  )),
              SizedBox(height: 20.0),
              new Center(
                child: new Text(title,
                    textAlign: TextAlign.center,

                    style:
                    new TextStyle(fontSize: 18.0, color: Colors.black)),
              )
            ],
          ),
        ),
      ));

}


MaterialButton longButtons(String title, Function fun,
    {Color color = Colors.blue, Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: fun(),
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
    height: 45,
    minWidth: 600,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  );
}

