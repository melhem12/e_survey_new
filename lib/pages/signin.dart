import 'dart:developer';
import 'dart:io';

import 'package:e_survey/View/expert_missions.dart';
import 'package:e_survey/View/expert_missions2.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:e_survey/pages/dashboard.dart';
import 'package:e_survey/Models//user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'bridge_page.dart';
import 'home.dart';
import 'dart:io' as io;
class Signin extends StatefulWidget {

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final box = GetStorage();

  SharedPreferences? _prefs;
  static const String tokenPrefKey = 'token_pref';
  static const String userIDPrefKey = 'userId_pref';
String savedUid ="";
  final _formKey = GlobalKey<FormState>();


  @override
  void  initState()
  {
    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      this._prefs=prefs);

// _loadUserId();
//       if(savedUid.isNotEmpty){
//         Navigator.pushNamed(context, "/home");
//       }
    });

    if(box.read('isTemaUser')=="true" && box.read('isESurveyUser')=="true") {
      log("loged in ");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Bridge()));
      });
    }
    else
    if(box.read('isESurveyUser')=="true"){


      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
      });
    }
    else
    if(box.read('isTemaUser')=="true"){

      WidgetsBinding.instance.addPostFrameCallback((_) {
        io.Platform.isIOS?
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ExpertMissions2())):
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => ExpertMissions()));
      });
    }

    super.initState();

  }


  Future save() async {
    var res = await http.post(Uri.parse(AppUrl.login),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }
    ,

        body: jsonEncode(<String, String>{
          'userId': user.userId,
          'password': user.password
        }),);
        // body: <String, String>{
        //   'userId': user.userId,
        //   'password': user.password
        // });
    print(res.body);
   Map <String,dynamic>map =  jsonDecode(res.body);

     //data = json.decode(res.body);
    String uid=map['userId'];
    String tok =map['token'];
    bool isTemaUser  =map['temaUser'];
    bool isESurveyUser  = map['esurveyUser'];

    print(tok);
    _setStringPref(uid,tok);
    box.write('userId', uid);
    box.write('token', tok);
    box.write('isTemaUser',isTemaUser.toString());
    box.write('isESurveyUser',isESurveyUser.toString());

    if(isTemaUser && isESurveyUser){
      log("bridgeee");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Bridge()));
      });


    }
else
    if(isESurveyUser){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
      });
    }
    else
    if(isTemaUser){
if(Platform.isIOS){
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ExpertMissions2()));
  });
}else {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => ExpertMissions()));
  });
}


    }





  }

  User user = User('', '');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
      children: [

          // Positioned(
          //     top: 0,
          //     child: SvgPicture.asset(
          //       'assets/top.svg',
          //       width: 400,
          //       height: 150,
          //     )),
          Container(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150,
                  ),
                  Text(
                    "Claims",
                    // style: GoogleFonts.pacifico(
                    //     fontWeight: FontWeight.bold,
                    //     fontSize: 50,
                    //     color: Colors.blue),

                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 50,color: Colors.blue),

                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: TextEditingController(text: user.userId),
                      onChanged: (value) {
                        user.userId = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter userId';
                        }
                        return null;
                      },
                        //else if (RegExp(
                      //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      //       .hasMatch(value)) {
                      //     return null;
                      //   } else {
                      //     return 'Enter valid email';
                      //   }
                      // },
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.blue,
                          ),
                          hintText: 'Enter User Id',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: TextEditingController(text: user.password),
                      onChanged: (value) {
                        user.password = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.blue,
                          ),
                          hintText: 'Enter Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.blue)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.red))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(55, 16, 16, 0),
                    child: Container(
                      height: 50,
                      width: 400,
                      child: TextButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                  )
                          )),
                          // color: Colors.blue,
                          // shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(16.0)),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              save();
                            } else {
                              print("not ok");
                            }
                          },
                          child: Text(
                            "Signin",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                  ),
                  // Padding(
                  //     padding: const EdgeInsets.fromLTRB(95, 20, 0, 0),
                  //     child: Row(
                  //       children: [
                  //         // Text(
                  //         //   "Not have Account ? ",
                  //         //   style: TextStyle(
                  //         //       color: Colors.black, fontWeight: FontWeight.bold),
                  //         // ),
                  //         // InkWell(
                  //         //   // onTap: () {
                  //         //   //   Navigator.push(
                  //         //   //       context,
                  //         //   //       new MaterialPageRoute(
                  //         //   //           builder: (context) => Signup()));
                  //         //   // },
                  //         //   // child: Text(
                  //         //   //   "Esurvey",
                  //         //   //   style: TextStyle(
                  //         //   //       color: Colors.blue,
                  //         //   //       fontWeight: FontWeight.bold),
                  //         //   // ),
                  //         // ),
                  //       ],
                  //     ))
                ],
              ),
            ),
          )
      ],
    ),
        ));
  }
  Future<void> _setStringPref(String userId ,String token) async {

    await this._prefs?.setString(tokenPrefKey, token);
    await this._prefs?.setString(userIDPrefKey, userId);
  }
  void _loadUserId(){
    setState(() {
      this.savedUid=this._prefs?.getString(userIDPrefKey)??"";
    });
  }
}
