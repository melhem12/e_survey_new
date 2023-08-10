import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class FrontCarRegistration extends StatefulWidget {
  const FrontCarRegistration({Key? key}) : super(key: key);

  @override
  _FrontCarRegistrationState createState() => _FrontCarRegistrationState();
}

class _FrontCarRegistrationState extends State<FrontCarRegistration> {

  File? _imageFile;
  final _picker = ImagePicker();
  static const String frontCarRegistrationrefKey = 'front_CarRegistration_pref';
  String savedFrontCarRegistration="";

  SharedPreferences? _prefs;
  @override
  void initState() {

    SharedPreferences.getInstance().then((prefs) {
      setState(() =>
      this._prefs=prefs);
      _loadImageDir();
      if(savedFrontCarRegistration.isNotEmpty){
        setState(() => this._imageFile = File(savedFrontCarRegistration));
      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

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

                      flex: 1, child:   Text("Front Car Registration",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 40,color: Colors.blue),



                    ),
                    ),
                    Expanded(
                        flex: 7, child:
                    ListView(
                      children: <Widget>[
                        ButtonBar(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.photo_camera,color: Colors.blue,),
                              onPressed: () async => _pickImageFromCamera(),
                              tooltip: 'Shoot picture',
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo,color: Colors.blue,),
                              onPressed: () async => _pickImageFromGallery(),
                              tooltip: 'Pick from gallery',
                            ),
                          ],
                        ),
                        if (this._imageFile == null)
                          const Placeholder(color: Colors.blue,)
                        else
                          Image.file(this._imageFile!),
                      ],
                    )
                    ),

                    // Expanded(
                    //     flex: 1,
                    //     child: Container(
                    //       child: ElevatedButton(
                    //
                    //         child: Icon(
                    //           Icons.arrow_back,
                    //           color: Colors.white,
                    //           size: 30,
                    //         ),
                    //
                    //         onPressed: () {
                    //           Navigator.pop(context);
                    //         },
                    //         style: ElevatedButton.styleFrom(
                    //             primary: Colors.blue,
                    //
                    //             textStyle: TextStyle(
                    //                 fontSize: 30,
                    //                 fontWeight:
                    //                 FontWeight.bold)),
                    //
                    //       ),
                    //     )
                    // )
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
                  ]))


      );;
  }
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
      _setStringPref(pickedFile.path);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
      _setStringPref(pickedFile.path);
    }
  }


  Future<void> _setStringPref(String imgdir) async {
    await this._prefs?.setString(frontCarRegistrationrefKey, imgdir);
  }
  void _loadImageDir(){
    setState(() {
      this.savedFrontCarRegistration=this._prefs?.getString(frontCarRegistrationrefKey)??"";
    });
  }
}
