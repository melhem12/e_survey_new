import 'dart:convert';
import 'dart:developer';

import 'package:e_survey/Models/company.dart';
import 'package:e_survey/args/SearrchSurveyArgs.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:flutter/material.dart';
import 'package:e_survey/service/companyService.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchSurvey extends StatefulWidget {


  @override
  _SearchSurveyState createState() => _SearchSurveyState();

}

class _SearchSurveyState extends State<SearchSurvey> {
late Company _company = Company(companyId:0,companyName: '');
double height=15;
String passNum='';
String policyNumber='';
String plateNum='';
String plateChar='';
static const String tokenPrefKey = 'token_pref';
String token='';
SharedPreferences? _prefs;
@override
  void initState() {
  SharedPreferences.getInstance().then((prefs) {
    setState(() => this._prefs = prefs);
    _loadUserId();
  });
  log("..........");
  log(token);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return   MaterialApp(
      
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text("Search survey")),
          body: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 10.0),
                    child: Text("Survey-Search",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        )),
                  ),

                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 10.0),



                    child :  FutureBuilder<List<Company>>(

                          future: CompanyService().get_data(token),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Company>> snapshot) {
                            if (!snapshot.hasData) return CircularProgressIndicator();
                            return DropdownButton<Company>(

                              items: snapshot.data!
                                  .map((comp) => DropdownMenuItem<Company>(
                                child: Text(comp.companyName),


                                value: comp,
                              ))
                                  .toList(),
                              onChanged: ( value) {
                                setState(() {
                                  _company=value!;

                                });
                              },
                              isExpanded: true,
                              //value: _cu
                              // rrentUser,
                              hint: Text(_company.companyName.isEmpty?"Choose a company":_company.companyName
                              ),

                            );
                          }),

                  ),












                  TextField(
                    onChanged: (String value){
                      log("???????????????");
                      passNum=value;
                      log(value);
                    },
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      labelText: 'Pass Number',
                      isDense: true,
                      hintText: "Enter Pass Number",
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
                  SizedBox(
                    height: height,
                  ),
                  Container(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,









                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // margin: EdgeInsets.symmetric(horizontal: 0.5),
                        // margin: EdgeInsets.all(5.0),
                        Expanded(
                          flex: 6,
                          child: TextField(
                            onChanged: (String value){
                              log("???????????????");
                              plateNum=value;
                              log(value);
                            },
                            style: TextStyle(

                              color: Colors.blue,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Plate Number',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              isDense: true,

                              hintText: "Plate Number",
                              fillColor: Colors.grey[300],
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,


                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),







                        Expanded(
                          flex: 6,
                          child: TextField(
                            onChanged: (String value){
                              log("???????????????");
                              plateChar=value;
                              log(value);
                            },
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Plate Charachter',
                              labelStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              isDense: true,
                              hintText: "Plate Char",
                              fillColor: Colors.grey[300],
                              filled: true,
                              hintStyle: TextStyle(
                                color: Colors.blue,
                              ),
                              border: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height,
                  ),
                  TextField(
                    onChanged: (String value){
                      log("???????????????");
                      policyNumber=value;
                      log(value);
                    },
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Policy Number ',
                      isDense: true,
                      labelStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      hintText: "Enter Policy Number",
                      hintStyle: TextStyle(
                        color: Colors.blue,
                      ),
                      border: InputBorder.none,
                      fillColor: Colors.grey[300],
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue),
                      ),
                      filled: true,
                    ),
                  ),
                  SizedBox(
                    height: height,
                  ),






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
                                      fontWeight: FontWeight.bold)),
                            ),
                          )),
                      SizedBox(
                        width: 10,
                      ),







                      Expanded(
                          flex: 1,
                          child: Container(
                            child: ElevatedButton(
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),

                              onPressed: () {
Navigator.pushNamed(context, "/Survey",arguments: SearrchSurveyArgs(_company.companyId.toString(),passNum,policyNumber,plateNum,plateChar));
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                  textStyle: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          )),
    );;
  }
void _loadUserId() {
  setState(() {
    this.token=this._prefs?.getString(tokenPrefKey)??"";

  });
}
}

