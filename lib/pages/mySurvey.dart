import 'dart:convert';
import 'dart:developer';

import 'package:e_survey/Models/claimsResponse.dart';
import 'package:e_survey/service/mySurveyApi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'claimsList.dart';



class mySurvey extends StatefulWidget {
  @override
  _mySurveyState createState() => _mySurveyState();
}

class _mySurveyState extends State<mySurvey> {
List <claimsResponse> claims=[];
SharedPreferences? _prefs;
static const String tokenPrefKey = 'token_pref';
static const String userIDPrefKey = 'userId_pref';
String userId="";
String token ="";
  @override
 void  initState()
   {
     SharedPreferences.getInstance().then((prefs) {
     setState(() =>
     this._prefs=prefs);
     _loadUserId();
     log("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
     log(userId);
     asyncMethod(userId);

     }) ;

    super.initState();
  }

void asyncMethod(String uId) async {
  // claimsResponse c  =  claimsResponse(notificationId:'sjbbabf',claimStatusCode:'djkfkfjad',reportedDate:'djdj',companyCode:'ddjd', notification: 'ccc');
  // claimsResponse d  =  claimsResponse(notificationId:'sjbbabf',claimStatusCode:'djkfkfjad',reportedDate:'djdj',companyCode:'ddjd', notification: 'ccc');
  //
  // claims.add(c);
  // claims.add(d);
  setState(() async {
    claims=  await mySurveyApi().get_data(uId,token);

  });
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar
        (title: Text(""),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: claims.length,
              itemBuilder: (BuildContext context, index){
                return
                  GestureDetector(
                    onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ClaimsList(claims[index].notification,claims[index].companyCode,claims[index].notificationId)));
                },
              child:  Card(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          claims[index].notification,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.italic,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          claims[index].reportedDate,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                      ],
                    ),
                  ),
                  elevation: 5.0,
                  shadowColor: Colors.black54,
              ), );
              },
            ),
          ),

        ],
      ),
    );
  }

void _loadUserId(){
  setState(() {
    this.userId=this._prefs?.getString(userIDPrefKey)??"";
    this.token=this._prefs?.getString(tokenPrefKey)??"";

  });
}
}