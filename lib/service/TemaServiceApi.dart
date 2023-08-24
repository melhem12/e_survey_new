
import 'dart:developer';
import 'dart:io';

import 'package:e_survey/Models/AppBodly.dart';
import 'package:e_survey/Models/AppDamagesParts.dart';
import 'package:e_survey/Models/AppPictures.dart';
import 'package:e_survey/Models/Doubts.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../Models/AccidentConditionModel.dart';
import '../Models/AppDamage.dart';
import '../Models/AppNotes.dart';
import '../Models/Responsability.dart';
class TemaServiceApi{

  List<AppDamage> appDamages=[];
  late AccidentConditionModel accidentConditionModel;
   AppPictures   appPictures = AppPictures(appPicturesId: '', carsAppAccidentId: '', appPicturesGeneral: '', appPicturesCarDamage: '', appPicturesTpPolicy: '', appPicturesDLvr1: '', appPicturesDLvr2: '', appPicturesOptional1: '', appPicturesOptional2: '', appPicturesOptional3: '');

AppNotes  appNotes=AppNotes(notesId: '', carsAppAccidentId: '', notesRemark: '', voiceNote: '');
  AppBodly appBodly=AppBodly(bodlyId: '', carsAppAccidentId: '0', bodlyInsCountLightInj: 0, bodlyInsCountSeverInj: 0, bodlyInsCountDeath: 0, bodlyTpCountLightInj: 0, bodlyTpCountSeverInj: 0, bodlyTpCountDeath: 0);
   List<Responsability> responsabilities=[];



  List<AppDamagePartResponse> damageList =<AppDamagePartResponse> [];
  List<Doubts> doubtsList=[];



  Future<void> updateAccidentStatus(String status ,String accidentId,String token) async {
    var response = await   http.post(Uri.parse(AppUrl.updateAccidentStatus),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, String>{
        'accidentId': accidentId,
        'status': status
      }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {

    }
    else {

      throw Exception('Failed to  get insert loass car');
    }

  }
  Future<bool> updateArrivedStatus(String pinCode ,String accidentId,String token) async {
  print("mmmmmmmmmm"+pinCode);
  log(token);
  log(accidentId);
    bool  success = false;

    var response = await   http.post(Uri.parse(AppUrl.updateArrivedStatus),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, String>{
        'accidentID': accidentId,
         'pinCode': pinCode
      }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {
      log("kkkkkkkkkkkkkk");
      log(response.body);
      final data = json.decode(response.body);
      success=  data["verficationSuccess"];

      return success;
    }
    else {

      throw Exception('Failed to  get insert loass car');
    }

  }
  Future<List<AppDamage>> get_AppDamage(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.damageCap) ,  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      appDamages = [];
      final extractedData = json.decode(utf8.decode(response.bodyBytes));
      if(extractedData != null) {
        List data = extractedData['damageCapList'];
        for (var i in data) {
          appDamages.add(AppDamage(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return appDamages;
  }
  Future<List<Responsability>> get_responsability(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.responsabilities) ,  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      responsabilities = [];
      final extractedData = json.decode((utf8.decode(response.bodyBytes)));
      if(extractedData != null) {
        List data = extractedData['responsabilityList'];
        for (var i in data) {
          responsabilities.add(Responsability(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return responsabilities;
  }
  Future<List<Doubts>> get_doubts(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.doubts) ,  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      doubtsList = [];
      final extractedData = json.decode((utf8.decode(response.bodyBytes)));
      if(extractedData != null) {
        List data = extractedData['doubtsList'];
        for (var i in data) {
          doubtsList.add(Doubts(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return doubtsList;
  }


  Future<void> insertAccidentConditions( String accidentId,String token, String accidentConditionsTPFDamage,String accidentConditionsResponsib,String accidentConditionsDoubts , int accidentConditiosTPCount) async {
    var response = await http.post(Uri.parse(AppUrl.insertAccidentConditions),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, dynamic>{
        'carsAppAccidentId': accidentId,
        'accidentConditionsTPFDamage': accidentConditionsTPFDamage,
        'accidentConditionsResponsib': accidentConditionsResponsib,
        'accidentConditionsDoubts': accidentConditionsDoubts,
        'accidentConditiosTPCount': accidentConditiosTPCount,

      }),);
    if (response.statusCode == 201 || response.statusCode == 200) {

    }
    else {
      throw Exception('Failed to  get insert loass car');
    }
  }
    Future<AccidentConditionModel> getAccidentCondition(String token , String accidentId) async {
      final url = Uri.parse(AppUrl.accidentConditions+"?accidentId="+accidentId);
      http.Response response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });
      if (response.statusCode == 200) {
        try {
          log("done");
          log(AccidentConditionModel.fromJson(jsonDecode(response.body)).accidentConditionsDoubts);
          accidentConditionModel=AccidentConditionModel.fromJson(jsonDecode(response.body));

        } catch (e) {
          log(e.toString());
       //   Get.snackbar('can not get data', e.toString());
        }

      }
      return accidentConditionModel ;
    }









  Future<AppPictures> getAccPictures(String token , String accidentId) async {
    final url = Uri.parse(AppUrl.getAccPictures+"?accidentId="+accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appPictures=AppPictures.fromJson(jsonDecode(response.body));

      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }

    }
    return appPictures ;
  }


  Future<AppNotes> getNotes(String token , String accidentId) async {
    final url = Uri.parse(AppUrl.getNotes+"?accidentId="+accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appNotes=AppNotes.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }

    }
    return appNotes ;
  }











  Future uploadImage(String filename,String name,String token,String accidentId) async {
    var request = http.MultipartRequest('POST', Uri.parse(AppUrl.uploadAccidentPicturesToDatabase+"?accidentId="+accidentId+"&name="+name));
    request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filename,
        )
    );
    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'});

    var res = await request.send();
  }
  Future<AppBodly> getCarsAppBodly(String token , String accidentId) async {
    final url = Uri.parse(AppUrl.getCarsAppBodly+"?accidentId="+accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appBodly=AppBodly.fromJson(jsonDecode(response.body));

      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }

    }
    return appBodly ;
  }


  Future<List<AppDamagePartResponse>> getCarsAppDamageParts(String token , String accidentId) async {
    final url = Uri.parse(AppUrl.getCarsAppDamageParts+"?accidentId="+accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        damageList.addAll(AppDamagesParts.fromJson(jsonDecode(response.body)).appDamagePartResponses);

      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }

    }
    return damageList ;
  }




  Future<void> updateCarsAppBodly( String accidentId,String token ,AppBodly myAppBodly) async {
    var response = await http.post(Uri.parse(AppUrl.updateCarsAppBodly),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, dynamic>{
        'carsAppAccidentId': accidentId,
        'bodlyInsCountDeath': myAppBodly.bodlyInsCountDeath,
        'bodlyInsCountLightInj': myAppBodly.bodlyInsCountLightInj,
        'bodlyInsCountSeverInj': myAppBodly.bodlyInsCountSeverInj,
        'bodlyTPCountLightInj': myAppBodly.bodlyTpCountLightInj,
        'bodlyTPCountSeverInj': myAppBodly.bodlyTpCountSeverInj,
        'bodlyTPCountDeath': myAppBodly.bodlyTpCountDeath,



      }),);
    if (response.statusCode == 201 || response.statusCode == 200) {

    }
    else {
      throw Exception('Failed to  get insert loass car');
    }
  }




  Future uploadNotes(String? filename, String notesRemark, String token, String carsAppAccidentId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.uploadNotes + "?carsAppAccidentId=$carsAppAccidentId&notesRemark=$notesRemark"),
    );

    if (filename != null) {
      var file = File(filename);
      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            filename,
          ),
        );
      } else {
        print('File does not exist.');
      }
    }

    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    var res = await request.send();
  }

  Future<void> updateGeoLocation(String latitude ,String longitude,String token) async {
    print("lllllllllllllllllllllllll location");
    var response = await   http.post(Uri.parse(AppUrl.updateGeoLocation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, String>{
        'longitude': longitude,
        'latitude': latitude
      }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {

    }
    else {

      throw Exception('Failed to  get insert location ');
    }

  }


  void updateGeoStatus(String status ,String token) async {
    var response = await   http.post(Uri.parse(AppUrl.updateGeoStatus),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, String>{
        'status': status,

      }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {

    }
    else {

      throw Exception('Failed to  get insert location ');
    }

  }







  Future<bool> updateCarsAppDamageParts( List<AppDamagePartResponse> damagedParts,String token,String accidentId) async {
    // log(damagedParts[0].surveyDamagedSeverity.toString());

    Map<String,dynamic> req_body = <String,dynamic>{};
    req_body['accidentId']=accidentId;

    req_body['carsAppDamagePartsRequest']=damagedParts.map((i) => i.toJson()).toList();
    log(req_body.toString());
    final response = await post(
        Uri.parse(AppUrl.updateCarsAppDamageParts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(req_body));
    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }




  }



