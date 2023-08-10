
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:e_survey/Models/CarParts.dart';
import 'package:e_survey/Models/PartsModel.dart';
import 'package:e_survey/Models/description.dart';
import 'package:e_survey/Models/direction.dart';
import 'package:e_survey/Models/partGroup.dart';
import 'package:e_survey/args/CarImputArgs.dart';
import 'package:e_survey/pages/metPage.dart';
import 'package:e_survey/service/PartMetApi.dart';
import 'package:e_survey/service/constantsApi.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'dataInputPersonalInformation.dart';
import 'package:e_survey/utility/sql_helper.dart';

class parts extends StatefulWidget {
  String? doors;
  String? bodyType;
  String? carId;

   parts(this.doors,
      this.bodyType,
      this.carId,) ;
  @override
  _partsState createState() => _partsState();
}

class _partsState extends State<parts> {
    bool isLoading = false;
    String partDesc='';
    String damageDesc='';
    bool clicked= false;
    static const String tokenPrefKey = 'token_pref';
    String token='';
    SharedPreferences? _prefs;

     Future<List<PartGroup>> futurePartGroup=Future.value([]);
     Future<List<Direction>> futureDirection=Future.value([]);
     Future<List<Description>> futureDescription=Future.value([]);
     Future<List<PartsModel>> futureSavedParts=Future.value([]);
    int _radioVal = 25;
    List<PartsModel> pmList=[];

    // Group Value for Radio Button.
    int id = 1;
   late  Future <List<CarParts>> futureCarParts= Future.value([]);
    late PartGroup _partGroup= PartGroup(code: '', description: '');
    late Description _description= Description(code: '', description: '');
    late Direction _direction =Direction(code: '', description: '');

    @override
    void initState() {
      SharedPreferences.getInstance().then((prefs) {
        setState(() => this._prefs = prefs);
        _loadUserId();
        futurePartGroup=ConstantsApi().get_part_group(token);

        futureDescription=ConstantsApi().getDescription(token);
        futureDirection=ConstantsApi().getDirection(token);
        getDamaged(widget.carId.toString());
      });


    print("/////////////");
      print(widget.carId);


    super.initState();
  }
  getDamaged(String carId) async{
    List<Description>descList=await futureDescription;
    _description=descList[0];
    final data = await SQLHelper.getDamaged();
    if(data.toSet().isEmpty){
      print("emptyyyyyyyy");
    futureSavedParts= PartMetApi().get_Damage_Parts(carId,token);
    pmList= await futureSavedParts;

    for(var i  in pmList){
      _addDamage(i.surveyDamagedDescription, i.surveyDamagedPartsId, i.surveyDamagedPartCode, i.surveyDamagedReview, i.surveyDamagedSeverity, i.surveyDamagedSurveyId, i.surveyDamagedPartDescription, i.surveyDamagedPartArabicDescription,i.metParentPart);
    }
    }
    else{
      _refreshData();
    }
  }
    TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text(" Car Parts")),
          body:

          SafeArea(
    child: SingleChildScrollView(
    child: Card(

    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
    padding: const EdgeInsets.all(16.0),
    child:
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 250,
                width: double.infinity,
          margin: new EdgeInsets.symmetric(vertical: 10.0),
                child:
              Card(

                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child:  TextField(
                              onChanged: (String value){
                                partDesc=value;
                              },
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              decoration: InputDecoration(
                                labelStyle: TextStyle(
                                  color: Colors.blue,
                                ),
                                labelText: 'Part Description',
                                isDense: true,
                                fillColor: Colors.grey[300],
                                filled: true,
                                hintStyle: TextStyle(
                                  color: Colors.blue,
                                ),
                                border: InputBorder.none,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(  color: Colors.blue,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(flex:1,child:   Text("Side",
                              style: TextStyle(
                               fontSize: 14,
                                color: Colors.grey,
                              )),),
                          Expanded(
                            flex: 2,
                            child:

                          StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return FutureBuilder<List<PartGroup>>(
                                    future: futurePartGroup,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                            List<PartGroup>> snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      return DropdownButton<PartGroup>(
                                        items: snapshot.data!
                                            .map((grp) =>
                                            DropdownMenuItem<PartGroup>(
                                              child:
                                              Text(grp.description),
                                              value: grp,
                                            ))
                                            .toList(),
                                        onChanged: (PartGroup? value) {
                                          setState(() => _partGroup = value!);
                                        },
                                        isExpanded: true,
                                        //   value: _brands==null?Brands(carBrandId: "carBrandId", carBrandDescription: "carBrandDescription"):_brands,
                                        value: _partGroup.code.isEmpty
                                            ? snapshot.data![0]
                                            : snapshot.data![
                                        snapshot.data!.indexOf(_partGroup)],
                                        hint: Text("Select part Group type"),);
                                    });
                              }),

                          ),  Expanded(flex:1,child:   Text("Position",
                              style: TextStyle(
                               // fontSize: 14,
                                color: Colors.grey,
                              )),),
                          Expanded(
                            flex: 2,
                            child:

                            StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return FutureBuilder<List<Direction>>(
                                      future: futureDirection,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<
                                              List<Direction>> snapshot) {
                                        if (!snapshot.hasData)
                                          return CircularProgressIndicator();
                                        print( snapshot.data![0].description);

                                        return DropdownButton<Direction>(
                                          items: snapshot.data!
                                              .map((dir) =>
                                              DropdownMenuItem<Direction>(
                                                child:
                                                Text(dir.description),
                                                value: dir,
                                              ))
                                              .toList(),
                                          onChanged: (Direction? value) {
                                            setState(() => _direction = value!);
                                          },
                                          isExpanded: true,
                                          //   value: _brands==null?Brands(carBrandId: "carBrandId", carBrandDescription: "carBrandDescription"):_brands,
                                          value: _direction.code.isEmpty
                                              ? snapshot.data![0]
                                            :  snapshot.data![
                                          snapshot.data!.indexOf(_direction)],
                                          hint: Text("Select direction"),);
                                      });
                                }),

                          ),
                          Expanded(flex: 2,
                              child: TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16.0),

                                          )
                                      )
                                      ,//    minWith: double.infinity,

                                  ),

                              onPressed: () async {
                               // showLoaderDialog(context);

                                setState(() {
                                  isLoading = true;
                                });
                                await Future.delayed(const Duration(seconds: 1));
                                  if(_partGroup.code.isEmpty){
                                 List<PartGroup> pg= await futurePartGroup;
                                 setState(() {
                                   _partGroup=pg[0];
                                 });

                                  }
                                  if(_direction.code.isEmpty){
                                    List<Direction> di= await futureDirection;
                                    setState(() {
                                      _direction=di[0];
                                    });
                                  }
                                  //pd.show(max: 100, msg: 'Load Car  Parts');
                                  //_dialog.show(message: 'Loading...', type:  SimpleFontelicoProgressDialogType.normal );
                              futureCarParts = PartMetApi().get_Car_Parts(_partGroup.code, widget.doors.toString(), widget.bodyType.toString(), _direction.code, partDesc,token);
                                setState(() {
                                  isLoading = false;
                                });
                                  // _dialog.hide();
                                 // PartMetApi().getPartTest(_partGroup.code, widget.doors.toString(), widget.bodyType.toString(), _direction.code, partDesc);
                                  setState(() {

                                });
                               // Navigator.pop(context);

                              },
                              child: Text(
                                "Filter",
                                style: TextStyle(color: Colors.white, fontSize: 20),

                              ))
                          )





                        ]
    ),


    ),
    ),
              ),


              Container(
                  height: 300,
                  width: double.infinity,
                  child:(isLoading)
                      ?
                      Center(

                          child:


                      CircularProgressIndicator(
                        color: Colors.white,

                        strokeWidth: 2,
                      )
                      ):
                  FutureBuilder(
                  future: futureCarParts,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {

                      return ListView.builder(
                        padding: EdgeInsets.all(2.0),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, index) {
                          return GestureDetector(
                              onTap: () {
                                if(saved(snapshot.data[index].partId)){
                                  deleteByCode(int.parse(snapshot.data[index].partId));
                                  deleteByMetParent(snapshot.data[index].partId);
                                }
                                else {
                                  _showDial(getRandomString(10),
                                      int.parse(snapshot.data[index].partId),
                                      "", snapshot.data[index].partDescription,
                                      snapshot.data[index]
                                          .partArabicDescription, "");
                                }
                              },

                              child: Card(
                                color:

                                saved(snapshot.data[index].partId)? Colors.blue: Colors.white,
                                child: Padding(

                                  padding: EdgeInsets.all(10.0),
                                  child: Column(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].partArabicDescription,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color:  saved(snapshot.data[index].partId)? Colors.white: Colors.black
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),

                                          Text(
                                            snapshot.data[index].partDescription
                                            ,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: saved(snapshot.data[index].partId)? Colors.white: Colors.black,
                                            ),
                                          ),


                                    //  Row(
                                    //    mainAxisAlignment: MainAxisAlignment.end,
                                    //    children: [
                                    //   snapshot.data[index].metCount >0
                                    //       ?  FlatButton(
                                    //     color: Colors.lightBlue,
                                    //     onPressed: () {
                                    //       if(saved(snapshot.data[index].partId)) {
                                    //         Navigator.of(context).push(
                                    //             MaterialPageRoute(
                                    //                 builder: (context) =>
                                    //                     MetPage(
                                    //                         _partGroup.code,
                                    //                         widget.doors
                                    //                             .toString(),
                                    //                         widget.bodyType
                                    //                             .toString(),
                                    //                         snapshot
                                    //                             .data[index]
                                    //                             .partId)
                                    //             ));
                                    //       }
                                    //     },
                                    //     child: Text('MET',
                                    //         style: TextStyle(color: Colors.white, fontSize: 16)),
                                    //   )
                                    //       :Text(""),
                                    //
                                    // ]
                                    //
                                    //  ),
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
                      );
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return CircularProgressIndicator();
                    }
                  })




              ),
SizedBox(
  height: 10,
),


              Container(
                height: 30,
                child:
                Container(
                  width: double.infinity,
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
            )

            ],
          ),
    ),
        ),
    ),
          ),

    );
  }

    showLoaderDialog(BuildContext context){
      AlertDialog alert=AlertDialog(
        content: new Row(
          children: [
            CircularProgressIndicator(),
            Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
          ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
    }


   bool saved( String partId){
      List<String> partIdsLit =[];
      partIdsLit = pmList.map((part) => part.surveyDamagedPartCode.toString()).toList();
    return  partIdsLit.contains(partId);
    }


    void _showDial(   String? surveyDamagedPartsId,int surveyDamagedPartCode,String? surveyDamagedSurveyId,String? surveyDamagedPartDescription,String ? surveyDamagedPartArabicDescription,String? metParentPart
      ) {
      showDialog(

        context: context,
        builder: (BuildContext context) {

          return StatefulBuilder(

            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(

                title: new Text("Review"),
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.only(left: 20,right: 20),
                  // clipBehavior: Clip.antiAliasWithSaveLayer,
                content:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[




                  Text("severity" ),
                  Row(
                    children: [25,50,75,100]
                        .map((int index) => Row(children:[ Radio<int>(
                      value: index,

                        groupValue: this._radioVal,
                        onChanged: (int? value) {
                          if (value != null) {
                            setState(() => this._radioVal = value);
                          }
                        },
                    ),Text(index.toString()+"%",style: TextStyle(fontSize: 12),)
                    ],
                    )

                    )
                        .toList(),
                  ),

                      StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setState) {
                            return FutureBuilder<List<Description>>(
                                future: futureDescription,
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                        List<Description>> snapshot) {
                                  if (!snapshot.hasData)
                                    return CircularProgressIndicator();
                                  return DropdownButton<Description>(
                                    items: snapshot.data!
                                        .map((desc) =>
                                        DropdownMenuItem<Description>(
                                          child:
                                          Text(desc.description),
                                          value: desc,
                                        ))
                                        .toList(),
                                    onChanged: (Description? value) {
                                      setState(() => _description = value!);
                                    },
                                    isExpanded: true,
                                    value: _description.code.isEmpty
                                        ? snapshot.data![0]
                                        : snapshot.data![snapshot.data!.indexOf(_description)],
                                    hint: Text("Select Description"),);

                                }
                                );
                          }


                          ),

                  TextField(
                    onChanged: (String value){
                      damageDesc=value;
                    },
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      labelText: 'Details',
                      isDense: true,
                      fillColor: Colors.grey[300],
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(  color: Colors.blue,

                        ),
                      ),
                    ),
                  ),
                  // Row(children : [ Radio(value: "value", groupValue: ['1','2','3'], onChanged:null),
                  // ],),
                  // TextField(),

                ]),
                actions:<Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                            context,
                            'Cancel'),
                    child: const Text(
                        'Cancel'),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                            context,
                            'yes'),
                    child: const Text(
                        'yes'),
                  ),
                ],
              );
            },
          );
        },
      ).then((returnVal) async {
        if (returnVal == "yes") {
          _addDamage( damageDesc, surveyDamagedPartsId, surveyDamagedPartCode,  _description.description ,_radioVal, surveyDamagedSurveyId, surveyDamagedPartDescription, surveyDamagedPartArabicDescription, metParentPart);
             print(damageDesc);
             print(_description.description );
          print(_radioVal);
        }
      });
    }
  Future<void> insertIntoSqlite() async {

  }

    Future<void> _addDamage(String ? surveyDamagedDescription, String? surveyDamagedPartsId,int surveyDamagedPartCode, String?  surveyDamagedReview ,int ?surveyDamagedSeverity,String? surveyDamagedSurveyId,String? surveyDamagedPartDescription,String ? surveyDamagedPartArabicDescription,String? metParentPart ) async {
      await SQLHelper.createDamage(surveyDamagedDescription,  surveyDamagedPartsId, surveyDamagedPartCode,  surveyDamagedReview ,surveyDamagedSeverity, surveyDamagedSurveyId,surveyDamagedPartDescription,surveyDamagedPartArabicDescription,metParentPart);

_refreshData();

     // _refreshJournals();
    }
    void _refreshData() async {
      pmList=[];
      final data = await SQLHelper.getDamaged();


      for (var i in data) {
        pmList.add(PartsModel(
          surveyDamagedDescription: i["surveyDamagedDescription"],

          surveyDamagedPartsId: i['surveyDamagedPartsId'],
          surveyDamagedPartCode:i['surveyDamagedPartCode'],
          surveyDamagedReview:i['surveyDamagedReview'],
          surveyDamagedSeverity:i['surveyDamagedSeverity'],
          surveyDamagedSurveyId:i['surveyDamagedSurveyId'],
          surveyDamagedPartDescription:i['surveyDamagedPartDescription'],
          surveyDamagedPartArabicDescription:i['surveyDamagedPartArabicDescription'],
          metParentPart:i['metParentPart'],
        ));
print("Clone success");

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
    void deleteByCode(int code){
      SQLHelper.deleteByCode(code);

    _refreshData();




    }
    void deleteByMetParent(String code){
      SQLHelper.deleteByMetParent(code);
      _refreshData();
    }

    void _loadUserId() {
      setState(() {
        this.token=this._prefs?.getString(tokenPrefKey)??"";

      });
    }
    Future<String> showToken() async {
      var sharedPreferences = await SharedPreferences.getInstance();
    token=  sharedPreferences.getString(tokenPrefKey).toString();
      print("hiii");
      setState(() {

      });
      return token;

    }
    var  _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();

    String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
