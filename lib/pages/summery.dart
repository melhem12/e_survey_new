import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:e_survey/Models/CarsSurveyDamagedPartsBean.dart';
import 'package:e_survey/Models/PartsModel.dart';
import 'package:e_survey/args/mySurveyArgs.dart';
import 'package:e_survey/pages/claimsList.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:e_survey/service/PartMetApi.dart';
import 'package:e_survey/utility/sql_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Summery extends StatefulWidget {
  String? carId;
  String? fName;
  String? fatherName;
  String? lName;
  String? brand;
  String? tradeMark;
  String? companyCode;
  String? notification;
  String? notificationId;
  Summery(this.carId, this.fName, this.fatherName, this.lName, this.brand,
      this.tradeMark, this.companyCode, this.notification, this.notificationId);

  @override
  _SummeryState createState() => _SummeryState();
}

class _SummeryState extends State<Summery> {
  List<PartsModel> pmList = [];
  late Future<List<PartsModel>> futureSavedParts = Future.value([]);
  SharedPreferences? _prefs;
  static const String tokenPrefKey = 'token_pref';
  String token='';
  late Position _position;
  static const String frontLicencePrefKey = 'front_licence_pref';
  static const String userIDPrefKey = 'userId_pref';
  static const String pathsListPrefKey = 'pathsList_pref';
  List<String> paths = [];
  String userId = "";
  String savedFrontLicense = "";
  static const String backCarRegistrationrefKey = 'back_CarRegistration_pref';
  String savedFrontCarRegistration ="";
  static const String frontCarRegistrationPrefKey = 'front_CarRegistration_pref';
  String savedBackCarRegistration="";
  static const String policyPrefKey = 'policy_pref';
  String savedPolicy ="";
  static const String vinPrefKey = 'vin';
  String savedVin ="";
  static const String backLicencePrefKey = 'back_licence_pref';
  String savedBackLicense ="";


  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadUserId();
      _loadImageDir();
      _loadPaths();
      if (paths.isNotEmpty) {
      }
    });
    getDamaged(widget.carId.toString());
    getPosition();
    super.initState();
  }

  getDamaged(String carId) async {
    final data = await SQLHelper.getDamaged();
    if (data.toSet().isEmpty) {
      futureSavedParts = PartMetApi().get_Damage_Parts(carId,token);
      pmList = await futureSavedParts;

      for (var i in pmList) {
        _addDamage(
            i.surveyDamagedDescription,
            i.surveyDamagedPartsId,
            i.surveyDamagedPartCode,
            i.surveyDamagedReview,
            i.surveyDamagedSeverity,
            i.surveyDamagedSurveyId,
            i.surveyDamagedPartDescription,
            i.surveyDamagedPartArabicDescription,
            i.metParentPart);
      }
      _refreshData();
    } else {
      _refreshData();
    }
    log(widget.carId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 50),

          child: FloatingActionButton(

            onPressed: () {
              save();
            },
            child: const Icon(Icons.upload),
            backgroundColor: Colors.blue,
          ),
        ),
        appBar: AppBar(
          title: Text("Summary"),
        ),
        body:
        Container(
          padding:EdgeInsets.all(10) ,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Client Name :"+widget.fName.toString() +
                        " " +
                        widget.fatherName.toString() +
                        " " +
                        widget.lName.toString()),

                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(" Car Maker : "+widget.brand.toString() ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Car Model : "+

                        widget.tradeMark.toString()),
                  ],
                ),
              ),
              Expanded(
                  flex: 12,
                  child:
                  pmList.length>0?

                  ListView.builder(
                    // padding: EdgeInsets.all(10.0),
                    itemCount: pmList.length,
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                          onTap: () {

                          },
                          child: Card(
                            color: pmList[index].metParentPart.toString().isEmpty
                                ? Colors.blue
                                : Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    pmList[index]
                                        .surveyDamagedPartArabicDescription,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: pmList[index].metParentPart.toString().isEmpty
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 5.0,
                                  ),

                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        pmList[index]
                                            .surveyDamagedPartDescription,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color:  pmList[index].metParentPart.toString().isEmpty
                                            ? Colors.white
                                            : Colors.black,
                                        ),
                                      ),
                                      IconButton(
                                        icon:  Icon(Icons.delete ,color: pmList[index].metParentPart.toString()
                                            .isNotEmpty?Colors.black:Colors.white,
                                        )
                                        ,
                                        onPressed: () {
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text('remove Part'),
                                              content: const Text(
                                                'Are you sure you want to remove this Part',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(
                                                      context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(
                                                      context, 'yes'),
                                                  child: const Text('yes'),
                                                ),
                                              ],
                                            ),
                                          ).then((returnVal) async {
                                            if (returnVal == "yes") {
                                              if (pmList[index]
                                                  .metParentPart
                                                  .isEmpty) {
                                                log(pmList[index]
                                                    .surveyDamagedPartCode
                                                    .toString());

                                                deleteByMetParent(pmList[index]
                                                    .surveyDamagedPartCode
                                                    .toString());

                                                deleteByCode(pmList[index]
                                                    .surveyDamagedPartCode);
                                              } else {
                                                deleteByCode(pmList[index]
                                                    .surveyDamagedPartCode);
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),

                                  // SizedBox(
                                  //   height: 5.0,
                                  // ),
                                ],
                              ),
                            ),
                            elevation: 5.0,
                            shadowColor: Colors.black54,
                          ));
                    },
                  )
                  :
                  Center(
                  child: CircularProgressIndicator()
          ,
        )
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
                            onPressed: ()  async {
                              showDialog<String>(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                      title: const Text('finish survey'),
                                      content: const Text(
                                        'Are you sure you want to finish this survey',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.pop(
                                              context, 'yes'),
                                          child: const Text('yes'),
                                        ),
                                      ],
                                    ),
                              ).then((returnVal) async {
                                if (returnVal == "yes") {
                                  bool finished=await PartMetApi().finishSuvey(userId,widget.carId.toString(),token);
                                  if(finished)  {
                                    PartMetApi().insertRequestStatus(userId, widget.carId.toString(), "finish", _position.longitude.toString(), _position.latitude.toString(),token);

                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                        Colors.blue,
                                        content: Text("finish succes"),

                                      ),
                                    );
                                    //Navigator.of(context).pushReplacementNamed('/ClaimsList', arguments: mySurveyArgs('notficationId', widget.companyCode.toString(), widget.companyCode.toString()));
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
                                        ClaimsList( widget.notification.toString(), widget.companyCode.toString(),widget.notificationId.toString())
                                    ), (Route<dynamic> route) => false);


                                  }else{
                                    ScaffoldMessenger.of(
                                        context)
                                        .showSnackBar(
                                      SnackBar(
                                        backgroundColor:
                                        Colors.red,
                                        content: Text("finishing failed"),

                                      ),
                                    );  
                                  }
                                }
                              });


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
              ),
            ],
          ),
        ));
  }

  void _refreshData() async {
    pmList = [];
    final data = await SQLHelper.getDamaged();

    for (var i in data) {
      pmList.add(PartsModel(
        surveyDamagedDescription: i["surveyDamagedDescription"],
        surveyDamagedPartsId: i['surveyDamagedPartsId'],
        surveyDamagedPartCode: i['surveyDamagedPartCode'],
        surveyDamagedReview: i['surveyDamagedReview'],
        surveyDamagedSeverity: i['surveyDamagedSeverity'],
        surveyDamagedSurveyId: i['surveyDamagedSurveyId'],
        surveyDamagedPartDescription: i['surveyDamagedPartDescription'],
        surveyDamagedPartArabicDescription:
            i['surveyDamagedPartArabicDescription'],
        metParentPart: i['metParentPart'],
      ));
    }
    // log(partModelList[0].surveyDamagedPartCode.toString());
    // setState(() {
    //   _journals = data;
    //   _isLoading = false;
    // });

    setState(() {
      pmList;
    });
  }

  Future<void> _addDamage(
      String? surveyDamagedDescription,
      String? surveyDamagedPartsId,
      int surveyDamagedPartCode,
      String? surveyDamagedReview,
      int? surveyDamagedSeverity,
      String? surveyDamagedSurveyId,
      String? surveyDamagedPartDescription,
      String? surveyDamagedPartArabicDescription,
      String? metParentPart) async {
    await SQLHelper.createDamage(
        surveyDamagedDescription,
        surveyDamagedPartsId,
        surveyDamagedPartCode,
        surveyDamagedReview,
        surveyDamagedSeverity,
        surveyDamagedSurveyId,
        surveyDamagedPartDescription,
        surveyDamagedPartArabicDescription,
        metParentPart);
  }

  save() async {
 Position p = await   getLatAndLong();
 print(p.latitude);
 print(p.longitude);
    List<CarsSurveyDamagedPartsBean> damageList = [];
    for (var i in pmList) {
      damageList.add(CarsSurveyDamagedPartsBean(
        int.parse(widget.companyCode.toString()),
        i.surveyDamagedDescription,
        i.surveyDamagedPartCode,
        i.surveyDamagedReview,
        i.surveyDamagedSeverity,
        i.metParentPart,
        userId,
      ));
    }
 PartMetApi().insertRequestStatus(userId, widget.carId.toString(), "save", _position.longitude.toString(), _position.latitude.toString(),token);
    PartMetApi().addDamagePart(damageList, widget.carId.toString(),token);
    if (savedFrontLicense.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedFrontLicense, widget.notification.toString(),token);
    }
    if (savedBackLicense.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedBackLicense, widget.notification.toString(),token);
    }
    if (savedBackCarRegistration.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedBackCarRegistration, widget.notification.toString(),token);
    }
    if (savedFrontCarRegistration.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedFrontCarRegistration, widget.notification.toString(),token);
    }
    if (savedVin.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedVin, widget.notification.toString(),token);
    }
    if (savedPolicy.isNotEmpty) {
      PartMetApi()
          .uploadImage(savedPolicy, widget.notification.toString(),token);
    }
    if (paths.isNotEmpty) {
      for (var path in paths) {
        PartMetApi().uploadImage(path, widget.notification.toString(),token);
      }
    }
  }

  void deleteByCode(int code) {
    SQLHelper.deleteByCode(code);

    _refreshData();
  }

  void deleteByMetParent(String code) {
    SQLHelper.deleteByMetParent(code);
  }

  void _loadUserId() {
    setState(() {
      this.userId = this._prefs?.getString(userIDPrefKey) ?? "";
      this.token=this._prefs?.getString(tokenPrefKey)??"";

    });
  }

  void _loadImageDir() {
    setState(() {
      this.savedFrontLicense =
          this._prefs?.getString(frontLicencePrefKey) ?? "";
      this.savedVin=this._prefs?.getString(vinPrefKey)??"";
      this.savedPolicy=this._prefs?.getString(policyPrefKey)??"";
      this.savedBackCarRegistration=this._prefs?.getString(backCarRegistrationrefKey)??"";
      this.savedFrontCarRegistration=this._prefs?.getString(frontCarRegistrationPrefKey)??"";
      this.savedBackLicense=this._prefs?.getString(backLicencePrefKey)??"";

    });
  }

  void _loadPaths() {
    setState(() {
      log("hyyyyyyyyyyyy");
      this.paths = this._prefs?.getStringList(pathsListPrefKey)??[];
    });
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
    _position=await Geolocator.getCurrentPosition().then((value) => value);
    return _position;
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





}
