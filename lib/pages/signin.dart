import 'dart:io' as io;
import 'dart:io';

import 'package:e_survey/Models//user.dart';
import 'package:e_survey/View/expert_missions.dart';
import 'package:e_survey/View/expert_missions2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/LoginResponse.dart';
import '../service/TemaServiceApi.dart';
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
  final storage = new FlutterSecureStorage();


  @override
  void  initState()
  {
    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      this._prefs=prefs);

    }
    );


    //_checkLoginStatus();

    super.initState();

  }


  Future<void> _checkLoginStatus() async {
    final token = await storage.read(key: "token");
    if (token != null && token.isNotEmpty) {
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      io.Platform.isIOS
          ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ExpertMissions2()))
          : Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ExpertMissions()));
    });
  }



  Future login() async {
    try {
      LoginResponse response = await TemaServiceApi().login(user.userId, user.password,context);
      // Handle the login response
      if (response.token.isNotEmpty) {
        print('Logged in successfully, token: ${response.token}');
        _setStringPref("userId", response.token);
        // box.write("token",response.token );
        box.write("userId",user.userId );
        await storage.write(key: "userId", value:user.userId);
        await storage.write(key: "token", value: response.token);
        await storage.write(key: "refresh_token", value: response.refreshToken);
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

      } else {
        print('Login failed');
      }
    } catch (e) {
      // Handle any errors that might occur
      print('Error during login: $e');
    }
  }
  User user = User('', '');
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: SingleChildScrollView(
          child: Stack(
      children: [
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
                              login();
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
