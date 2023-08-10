import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../Models/AppPictures.dart';
import 'body_damages.dart';
class AccidentImages extends StatefulWidget {
  const AccidentImages({Key? key}) : super(key: key);
  @override
  _AccidentImagesState createState() => _AccidentImagesState();
}

class _AccidentImagesState extends State<AccidentImages> {

  final _picker = ImagePicker();
  AppPictures  appPictures=AppPictures(appPicturesId: '', carsAppAccidentId: '', appPicturesGeneral: '', appPicturesCarDamage: '', appPicturesTpPolicy: '', appPicturesDLvr1: '', appPicturesDLvr2: '', appPicturesOptional1: '', appPicturesOptional2: '', appPicturesOptional3: '');
  File? _imageFile1;
  File? _imageFile2;
  File? _imageFile3;
  File? _imageFile4;
  File? _imageFile5;
  File? _imageFile6;
  File? _imageFile7;
  File? _imageFile8;
    Image? img1;
    bool loaded=false;
  final box= GetStorage();
  late  Mission  m;
@override
  void initState() {
  m=Get.arguments as Mission ;
    // TODO: implement initState
    super.initState();
    getAccPictures();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(appBar: AppBar(title: Text('صور الحادث')),
      backgroundColor: Colors.white,
     body: SafeArea(
        child:
        loaded==true?const Center(child: CircularProgressIndicator()):
        SingleChildScrollView(
        child:

        Card(
    child: Padding(
    padding: const EdgeInsets.all(8.0),

    child:

    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children:  <Widget>[

             Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Row(
                      children: <Widget>[
       if (appPictures.appPicturesGeneral.isNotEmpty)
        Expanded(  flex: 2,child:     Image.memory(base64Decode(appPictures.appPicturesGeneral),height: 50,width: 50,))
                       else if (this._imageFile1== null)
                          const  Expanded(  flex: 2,child:  Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))

                        else
       Expanded(  flex: 2,child:   Image.file(this._imageFile1!,width: 50,height: 50,)),

    Expanded(  flex: 5,child:    ButtonBar(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                              onPressed: () async => _pickImageFromCamera("appPicturesGeneral"),
                              tooltip: 'Shoot picture',
                            ),
                            IconButton(
                              icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                              onPressed: () async => _pickImageFromGallery("appPicturesGeneral"),
                              tooltip: 'Pick from gallery',
                            ),
                          ],
                        )),

    Expanded(  flex: 5,child:        Text("صورة شاملة عن الحادث",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

                      ],
                    ),
        ),

        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Row(
          children: <Widget>[
            if (appPictures.appPicturesCarDamage.isNotEmpty)
            Expanded(  flex: 2,child:  Image.memory(base64Decode(appPictures.appPicturesCarDamage),height: 50,width: 50,))
       else   if (this._imageFile2 == null)
              const  Expanded(  flex: 2,child:   Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
            else
       Expanded(  flex: 2,child:   Image.file(this._imageFile2!,width: 50,height: 50,),),
      Expanded(  flex: 5,child:   ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromCamera("appPicturesCarDamage"),
                  tooltip: 'Shoot picture',
                ),
                IconButton(
                  icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromGallery("appPicturesCarDamage"),
                  tooltip: 'Pick from gallery',
                ),

    ],
            )),
      Expanded(  flex: 5,child:    Text("أضرار السيارة",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

        ],
      ),
        ),
      Container(
        // margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
        child: Row(
          children: <Widget>[
            if (appPictures.appPicturesTpPolicy.isNotEmpty)
          Expanded(  flex: 2 ,child:   Image.memory(base64Decode(appPictures.appPicturesTpPolicy),height: 50,width: 50,))
            else
            if (this._imageFile3 == null)
              const Expanded(  flex: 2 ,child: Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
            else
       Expanded(  flex: 2 ,child: Image.file(this._imageFile3!,width: 50,height: 50,)),
      Expanded(flex: 5,child:      ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromCamera("appPicturesTPPolicy"),
                  tooltip: 'Shoot picture',
                ),
                IconButton(
                  icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromGallery("appPicturesTPPolicy"),
                  tooltip: 'Pick from gallery',
                ),
              ],
            ),),
    Expanded(  flex: 5,child:  Text("بوليصةالطرف الثالث",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

          ],
        ),
      ),
        Container(
       // margin: const EdgeInsets.all(15.0),
       padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (appPictures.appPicturesDLvr1.isNotEmpty)
              Expanded(  flex: 2,child: Image.memory(base64Decode(appPictures.appPicturesDLvr1),height: 50,width: 50,))
            else
            if (this._imageFile4 == null)
              Expanded(  flex: 2 , child: Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
            else
       Expanded(  flex: 2, child:   Image.file(this._imageFile4!,width: 50,height: 50,)),
          Expanded(flex: 5,child:   ButtonBar(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromCamera("appPicturesDLvr1"),
                  tooltip: 'Shoot picture',
                ),
                IconButton(
                  icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                  onPressed: () async => _pickImageFromGallery("appPicturesDLvr1"),
                  tooltip: 'Pick from gallery',
                ),

              ],
            ),
    ),

      Expanded(  flex: 5,child:  Text("رخصة القيادة ودفتر السيارة 1",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

          ],
        ),
      ),



    Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
      if (appPictures.appPicturesDLvr2.isNotEmpty)
        Expanded(  flex: 2,child:  Image.memory(base64Decode(appPictures.appPicturesDLvr2),height: 50,width: 50,))
      else
      if (this._imageFile5 == null)
         const Expanded(  flex: 2,child:Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
      else
       Expanded(  flex: 2,child: Image.file(this._imageFile5!,width: 50,height: 50,),),
      Expanded(  flex: 5,child: ButtonBar(
      children: <Widget>[
      IconButton(
      icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
      onPressed: () async => _pickImageFromCamera("appPicturesDLvr2"),
      tooltip: 'Shoot picture',
      ),
      IconButton(
      icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
      onPressed: () async => _pickImageFromGallery("appPicturesDLvr2"),
      tooltip: 'Pick from gallery',
      ),
      ],
      )),
      Expanded(  flex: 5,child:Text("رخصة القيادة ودفتر السيارة 2",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

      ],
      ),
    ),






        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Row(
            children: <Widget>[
              if (appPictures.appPicturesOptional1.isNotEmpty)
            Expanded(  flex: 2,child:     Image.memory(base64Decode(appPictures.appPicturesOptional1),height: 50,width: 50,))
              else
                if (this._imageFile6 == null)
                  const   Expanded(  flex: 2,child:   Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
                else
       Expanded(  flex: 2,child:    Image.file(this._imageFile6!,width: 50,height: 50,)),
      Expanded(  flex: 5,child:      ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromCamera("appPicturesOptional1"),
                    tooltip: 'Shoot picture',
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromGallery("appPicturesOptional1"),
                    tooltip: 'Pick from gallery',
                  ),
                ],
              )),
      Expanded(  flex: 5,child:    Text("صورة اختيارية 1",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Row(
            children: <Widget>[
              if (appPictures.appPicturesOptional2.isNotEmpty)
            Expanded(  flex: 2,child:   Image.memory(base64Decode(appPictures.appPicturesOptional2),height: 50,width: 50,))
              else
                if (this._imageFile7 == null)
                  const   Expanded(  flex: 2,child:   Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
                else
       Expanded(  flex: 2,child:   Image.file(this._imageFile7!,width: 50,height: 50,)),
      Expanded(  flex: 5,child:    ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromCamera("appPicturesOptional2"),
                    tooltip: 'Shoot picture',
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromGallery("appPicturesOptional2"),
                    tooltip: 'Pick from gallery',
                  ),
                ],
              )),
      Expanded(  flex: 5,child:  Text("صورة اختيارية 2",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

            ],
          ),
        ),

        Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey)
          ),
          child: Row(
            children: <Widget>[
              if (appPictures.appPicturesOptional3.isNotEmpty)
            Expanded(  flex: 2,child:   Image.memory(base64Decode(appPictures.appPicturesOptional3),height: 50,width: 50,))
              else
                if (this._imageFile8 == null)
                  const   Expanded(  flex: 2,child:   Placeholder(color: Colors.blue,fallbackWidth:50.0,fallbackHeight: 50.0,))
                else
       Expanded(  flex: 2,child:     Image.file(this._imageFile8!,width: 50,height: 50,)),
      Expanded(  flex: 5,child:    ButtonBar(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.photo_camera,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromCamera("appPicturesOptional3"),
                    tooltip: 'Shoot picture',
                  ),
                  IconButton(
                    icon: const Icon(Icons.photo,color: Colors.blue,size: 30,),
                    onPressed: () async => _pickImageFromGallery("appPicturesOptional3"),
                    tooltip: 'Pick from gallery',
                  ),

                ],
              )),
      Expanded(  flex: 5,child:    Text("صورة اختيارية 3",style: TextStyle(color: Colors.blue),textAlign: TextAlign.left)),

        ],
          ),
        ),
        Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    child: ElevatedButton(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.arrow_back)),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "العودة", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                              ,fontSize: 12,),
                            ),
                          ),

                        ],
                      ),
                      onPressed: () async {
                        Get.back(result: 'hello');

                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight:
                              FontWeight.bold)),
                    ),
                  )),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: ElevatedButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.accessibility_new)),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "الأضرار الجسدية", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                              ,fontSize: 12,),
                            ),
                          ),

                        ],
                      ),


                      onPressed: () async {
                       Get.to(const BodyDamageView(),arguments: m);

                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          textStyle: TextStyle(
                              fontSize: 30,
                              fontWeight:
                              FontWeight.bold)),
                    ),
                  ))
            ]
        ),

      ],
    )
    ),

    )
    )
     )
    )
    ;
  }

  Future<void> _pickImageFromGallery(String name) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery , imageQuality: 50);
    if (pickedFile != null) {
      if(name=="appPicturesGeneral"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile1= File(pickedFile.path));
      }
      if(name=="appPicturesCarDamage"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile2= File(pickedFile.path));

      }
      if(name=="appPicturesTPPolicy"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile3= File(pickedFile.path));

      }
      if(name=="appPicturesDLvr1"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile4= File(pickedFile.path));

      }
      if(name=="appPicturesDLvr2"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile5= File(pickedFile.path));

      }
      if(name=="appPicturesOptional1"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile6= File(pickedFile.path));

      }
      if(name=="appPicturesOptional2"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile7= File(pickedFile.path));

      }
      if(name=="appPicturesOptional3"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile8= File(pickedFile.path));

      }
     // _setStringPref(pickedFile.path);
    }
  }

  Future<void> _pickImageFromCamera(String name ) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera , imageQuality: 50);
    if (pickedFile != null) {
      if(name=="appPicturesGeneral"){
        log("pppppppppppp");
        log("picture"+ pickedFile.path);
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile1= File(pickedFile.path));

      }
      if(name=="appPicturesCarDamage"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile2= File(pickedFile.path));

      }
      if(name=="appPicturesTPPolicy"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile3= File(pickedFile.path));

      }
      if(name=="appPicturesDLvr1"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile4= File(pickedFile.path));

      }
      if(name=="appPicturesDLvr2"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile5= File(pickedFile.path));

      }
      if(name=="appPicturesOptional1"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile6= File(pickedFile.path));

      }
      if(name=="appPicturesOptional2"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile7= File(pickedFile.path));

      }
      if(name=="appPicturesOptional3"){
        await TemaServiceApi().uploadImage(pickedFile.path, name, box.read('token'), m.accidentId);

        setState(() => this._imageFile8= File(pickedFile.path));

      }
    //  _setStringPref(pickedFile.path);
    }
  }
  void getAccPictures() async{
    setState(() {
      loaded=true;
    });

    appPictures =await TemaServiceApi().getAccPictures(box.read('token'), m.accidentId);
loaded=false;

setState(() {

});
  }

}

