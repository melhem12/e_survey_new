import 'dart:developer';

import 'package:e_survey/pages/signin.dart';
import 'package:e_survey/utility/widgets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  SharedPreferences? _prefs;
  static const String tokenPrefKey = 'token_pref';

  static const String userIDPrefKey = 'userId_pref';
  String userId="";
String token ='';
  @override
  void  initState()
  {
    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
        this._prefs=prefs);
      _loadUserId();
      if(userId.isEmpty){
       Navigator.pushNamed(context, '/');
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (BuildContext context) => Signin()),
      // ModalRoute.withName('/'),);
      }
    });
print("testtokn................>>>>>>>>>>");

print(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(userId),
      accountEmail: Text(userId),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.person ,size: 65,color: Colors.blue,),
      ),
      // otherAccountsPictures: <Widget>[
      //   CircleAvatar(
      //     backgroundColor: Colors.yellow,
      //     child: Text('A'),
      //   ),
      //   CircleAvatar(
      //     backgroundColor: Colors.red,
      //     child: Text('B'),
      //   )
      // ],
    );
    final drawerItems = ListView(
      children: <Widget>[
        drawerHeader,
        ListTile(
          title:  Row(
            children: <Widget>[
              SizedBox(width: 5,),
              Icon(Icons.home),
              Text('Home'),

            ],
          ),

          onTap: () => Navigator.of(context).pushNamed('/home'),

        ),
        ListTile(
          title:  Row(
            children: <Widget>[
              SizedBox(width: 5,),
              Icon(Icons.exit_to_app),
          SizedBox(width: 5,),
              Text('Logout'),

            ],
          ),

          onTap: () async => {
            await   _prefs!.clear(),
            Navigator.of(context).pushNamed('/'),

          }
        ),

      ],
    );




    return Scaffold(
        drawer: Drawer(
          child: drawerItems,
        ),
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

                flex: 1, child:   Text("Home",
                 // style: GoogleFonts.pacifico(
                 //      fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blue)
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue),


              ),
              ),
              Expanded(
                flex:6,
                child: GridView.count(
                  crossAxisCount: 2,

                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[

                    // Text(""),
                    makeDashboardItem("My Survey", Icons.task,"/dashboard",context),
                    makeDashboardItem("new survey", Icons.search,"/SearchSurvey",context),
                    //makeDashboardItem("", Icons.task,"/",context),

                  ],
                ),
              ),

            ]

            ,)


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
