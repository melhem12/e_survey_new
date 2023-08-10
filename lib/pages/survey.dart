import 'dart:convert';
import 'dart:developer';

import 'package:e_survey/Models/claimsResponse.dart';
import 'package:e_survey/args/SearrchSurveyArgs.dart';
import 'package:e_survey/args/mySurveyArgs.dart';
import 'package:e_survey/pages/claimsList.dart';
import 'package:e_survey/service/mySurveyApi.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Survey extends StatefulWidget {

  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {

  List <claimsResponse> claims=[];
  static const String tokenPrefKey = 'token_pref';
  static const String userIDPrefKey = 'userId_pref';
  SharedPreferences? _prefs;
  String userId="";
  String token ="";
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      this._prefs=prefs);
      _loadUserId();

    }
    );
    log("myToken");
    log(token);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SearrchSurveyArgs;


    return Scaffold(
      appBar: AppBar
        (title: Text("Survey"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
    child:  FutureBuilder(
      future: mySurveyApi().get_survey(args.companyCode, args.passNumber, args.policyNumber, args.plateNumber, args.plateCharacter,token),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              log("////////////////////");
             // log(snapshot.data[0].toString());
              return
            ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, index){
                    return
                      GestureDetector(
                        onTap: (){
                          log( snapshot.data[index].notification);
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>ClaimsList(snapshot.data[index].notification,snapshot.data[index].companyCode,snapshot.data[index].notificationId)));
                        },
                        child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data[index].notification,
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
                           DateTime.parse(snapshot.data[index].reportedDate).day.toString()
+"/" + DateTime.parse(snapshot.data[index].reportedDate).month.toString()+"/" + DateTime.parse(snapshot.data[index].reportedDate).year.toString()
                              ,
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


                        )



                    );
                  },
                )

                ;
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