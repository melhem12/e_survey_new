import 'dart:math';

import 'package:e_survey/Models/Met.dart';
import 'package:e_survey/Models/PartsModel.dart';
import 'package:e_survey/Models/description.dart';
import 'package:e_survey/service/PartMetApi.dart';
import 'package:e_survey/service/constantsApi.dart';
import 'package:e_survey/utility/sql_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MetPage extends StatefulWidget {

  final String partSubgroup;
final String doors ;
final String bodyType;
final String partId;

  MetPage(this.partSubgroup, this.doors, this.bodyType, this.partId);

  @override
  _MetPageState createState() => _MetPageState();
}


class _MetPageState extends State<MetPage> {
  static const String tokenPrefKey = 'token_pref';
  String token='';
  SharedPreferences? _prefs;

  late  Future <List<Met>> futureMet= Future.value([]);
  String damageDesc='';
  late Future<List<Description>> futureDescription=Future.value([]);
  late Description _description= Description(code: '', description: '');

  int _radioVal = 25;
  List<PartsModel> mList=[];
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadUserId();
    });
    futureDescription=ConstantsApi().getDescription(token);
    getDesc();
    futureMet = PartMetApi().get_Car_met(widget.partSubgroup.toString(),widget.doors.toString(), widget.bodyType.toString(), widget.partId.toString(),token);
    _refreshData();
    super.initState();

  }
  getDesc() async{
    List<Description>descList=await futureDescription;
    _description=descList[0];
  }
  @override
  Widget build(BuildContext context) {
    return


      Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(" Car Mets")),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Expanded(flex: 20,
              child: FutureBuilder(
              future: futureMet,
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

                            }
                            else {
                              _showDial(getRandomString(10),
                                  int.parse(snapshot.data[index].partId),
                                  "", snapshot.data[index].partDescription,
                                  snapshot.data[index]
                                      .partArabicDescription, widget.partId.toString());
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


                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        snapshot.data[index].partDescription
                                        ,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: saved(snapshot.data[index].partId)? Colors.white: Colors.black,
                                        ),
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
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                 return Center(
                    child: CircularProgressIndicator()
                    ,
                  );
                }
              }


)
        ),
        Expanded(
          flex: 1,
            child:  Container(
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
      ],),
    );
  }



  void _refreshData() async {
    mList=[];
    final data = await SQLHelper.getDamaged();


    for (var i in data) {
      mList.add(PartsModel(
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
      mList;
    });

  }



  bool saved( String partId){
    List<String> partIdsLit =[];
    partIdsLit = mList.map((part) => part.surveyDamagedPartCode.toString()).toList();
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
        print(_radioVal);
      }
    });
  }
  Future<void> _addDamage(String ? surveyDamagedDescription, String? surveyDamagedPartsId,int surveyDamagedPartCode, String?  surveyDamagedReview ,int ?surveyDamagedSeverity,String? surveyDamagedSurveyId,String? surveyDamagedPartDescription,String ? surveyDamagedPartArabicDescription,String? metParentPart ) async {
    await SQLHelper.createDamage(surveyDamagedDescription,  surveyDamagedPartsId, surveyDamagedPartCode,  surveyDamagedReview ,surveyDamagedSeverity, surveyDamagedSurveyId,surveyDamagedPartDescription,surveyDamagedPartArabicDescription,metParentPart);

    _refreshData();

    // _refreshJournals();
  }
  void deleteByCode(int code){
    SQLHelper.deleteByCode(code);
    _refreshData();

  }
  void _loadUserId() {
    setState(() {
      this.token=this._prefs?.getString(tokenPrefKey)??"";

    });
  }
  var  _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
