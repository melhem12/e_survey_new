import 'dart:developer';

import 'package:e_survey/Models/HistoryModel.dart';
import 'package:e_survey/Models/claimsResponse.dart';
import 'package:e_survey/Models/company.dart';
import 'package:e_survey/service/companyService.dart';
import 'package:e_survey/service/mySurveyApi.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistorySearch extends StatefulWidget {
  const HistorySearch({Key? key}) : super(key: key);

  @override
  _HistorySearchState createState() => _HistorySearchState();
}

class _HistorySearchState extends State<HistorySearch> {
  String ? passNumber;
  DateTime? _selectedFromDate = DateTime.now();
  DateTime? _selectedToDate = DateTime.now();
  late Company _company = Company(companyId:0,companyName: '');
String from ='';
  String to ='';
  String userId="";
  static const String tokenPrefKey = 'token_pref';
  String token ="";
  late Future<List<HistoryModel>> myFuture=Future.value([]);
  TextEditingController _textEditingfromController =
  TextEditingController();
  TextEditingController _textEditingToController =
  TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const String userIDPrefKey = 'userId_pref';
  SharedPreferences? _prefs;
@override
  void initState() {
  SharedPreferences.getInstance().then((prefs) {
    setState(() =>
  this._prefs=prefs);
  _loadUser();

}
);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("History")),
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
    child: Form(
    key: _formKey,
              child:

              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 330,
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
                              Expanded(flex:2,child: Container(
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


)


                      ),
                              Expanded(flex:1,child:   SizedBox(

                              ),
                              ),
                              Expanded(
                                flex: 2,
                                child:  TextField(
                                  onChanged: (String value){
                                    passNumber=value;
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
                              Expanded(flex:1,child:   SizedBox(

                              ),
                              ),

                              Expanded(
                                flex: 2,
                                child:

                                TextField(
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: _textEditingfromController,
                                  onTap: () {
                                    _selectDate(context,
                                        _textEditingfromController, _selectedFromDate!);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'From',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "From",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    suffixIcon:
                                    Icon(Icons.calendar_today_outlined),
                                    fillColor: Colors.grey[300],
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),

                              ),
                              Expanded(flex:1,child:   SizedBox(

                              ),
                              ),
                              Expanded(
                                flex: 2,
                                child:

                                TextField(
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: _textEditingToController,
                                  onTap: () {
                                    _selectDate(context,
                                        _textEditingToController, _selectedToDate!);
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'To',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "To",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    suffixIcon:
                                    Icon(Icons.calendar_today_outlined),
                                    fillColor: Colors.grey[300],
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                          Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),
                              ),
                              Expanded(flex:1,child:   SizedBox(

                              ),
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
                                        log(passNumber!);
                                        myFuture = mySurveyApi().searchHistory(userId, passNumber!, from,_textEditingToController.text.toString(),_company.companyId.toString(),token);

                                        // _dialog.hide();
                                        setState(() {
                                        });
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
                        height: 370,
                        child: FutureBuilder(
                            future: myFuture,
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
                                         Card(
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
                                                      snapshot.data[index].surveyDate
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
                            ),
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
                  ),

                ],
              ),
            ),
          ),
        ),),
      ));
  }

  _selectDate(
      BuildContext context,
      TextEditingController _textEditingController,
      DateTime _selectedDate) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.blue,
                surface: Colors.blueGrey,
                onSurface: Colors.blue,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
            // child: ?child,
          );
        }
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      final DateFormat format = DateFormat('dd/MM/yyyy');
      log(_selectedDate.toString());
      _textEditingController
        ..text = format.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
      from=_textEditingController.text;
      log(from);

    }

  }
  void _loadUser(){
    setState(() {
      this.userId=this._prefs?.getString(userIDPrefKey)??"";
      this.token=this._prefs?.getString(tokenPrefKey)??"";

    });
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
