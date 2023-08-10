import 'dart:async';
import 'dart:developer';
//import 'dart:html';

import 'package:e_survey/Models/CarParts.dart';
import 'package:e_survey/Models/CarsSurveyDamagedPartsBean.dart';
import 'package:e_survey/Models/Met.dart';
import 'package:e_survey/Models/PartsModel.dart';
import 'package:e_survey/pages/metPage.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' as io;

import 'package:http/http.dart';
class PartMetApi{
  List<PartsModel> parts = [];
  List<CarParts> carparts = [];
  List<Met> mets = [];
  Future<List<PartsModel>> get_Damage_Parts(String carId , String token) async {
     parts=[];
    var response = await   http.get(Uri.parse(AppUrl.getAllDamagedParts+"carId="+carId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',

        });


    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body)['carsSurveyDamagedPartsReceiveBeanList'];
      for (var i in extractedData) {
        parts.add(PartsModel(
            surveyDamagedDescription: i["surveyDamagedDescription"],
            surveyDamagedPartsId: i['surveyDamagedPartsId'],
            surveyDamagedPartCode:i['surveyDamagedPartCode'],
            surveyDamagedReview:i['surveyDamagedReview'],
            surveyDamagedSeverity:i['surveyDamagedSeverity'],
          surveyDamagedSurveyId:i['surveyDamagedSurveyId'],
          surveyDamagedPartDescription:i['surveyDamagedPartDescription'],
          surveyDamagedPartArabicDescription:i['surveyDamagedPartArabicDescription'],
          metParentPart:i['metParentPart'],
        ));

    }
      }
    else {

      throw Exception('Failed to  get counter');
    }

    return parts;
  }


  Future<List<CarParts>> get_Car_Parts(String partSubgroup,String doors,String bodyType,String direction,String description ,String token ) async {

    carparts=[];
    var response = await  http.get(Uri.parse(AppUrl.getCarParts+"partSubgroup="+partSubgroup+"&doors="+doors+"&bodyType="+bodyType+"&direction="+direction+"&description="+description),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',

        }).timeout(Duration(seconds: 100));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body)['carPartBeanList'];
      log(extractedData.toString());
      for (var i in extractedData) {
        carparts.add(CarParts(
          partId: i["partId"],
          partDescription: i["partDescription"].toString(),
          partArabicDescription: i["partArabicDescription"].toString(),
          relatedCount: i["relatedCount"],
          metCount: i["metCount"],
        ));

      }
    }
    else {

      throw Exception('Failed to  get counter');
    }

    return carparts;
  }




  Future<List<Met>> get_Car_met(String partSubgroup,String doors,String bodyType,String partId ,String token) async {
    mets=[];

    var response = await  http.get(Uri.parse(AppUrl.getPartMet+"partSubgroup="+partSubgroup+"&doors="+doors+"&bodyType="+bodyType+"&partId="+partId),  headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(Duration(seconds: 100));
    if (response.statusCode == 200) {
      final extractedData = json.decode(response.body)['partMetBeanList'];
      log(extractedData.toString());
      for (var i in extractedData) {
        mets.add(Met(
          partId: i["partId"],
          partDescription: i["partDescription"].toString(),
          partArabicDescription: i["partArabicDescription"].toString(),
        ));

      }
    }
    else {

      throw Exception('Failed to  get counter');
    }

    return mets;
  }






  // Future<void> getPartTest(String partSubgroup,String doors,String bodyType,String direction,String description,String token) async {
  //   var httpClient = io.HttpClient();
  //
  //   var request = await httpClient.getUrl(Uri.parse(AppUrl.getCarParts+"partSubgroup="+partSubgroup+"&doors="+doors+"&bodyType="+bodyType+"&direction="+direction+"&description="+description));
  //   try {
  //     var response = await request
  //         .close()
  //         .then(
  //           (r) async =>{
  //         print( await utf8.decodeStream(r))
  //
  //           }
  //     )
  //         .timeout(
  //       const Duration(seconds: 60),
  //     );
  //
  //
  //   } on TimeoutException catch (_) {
  //     print('Timed out');
  //     request.abort();
  //   }
  //
  // }



  Future uploadImage(String filename,String notication,String token) async {
  var request = http.MultipartRequest('POST', Uri.parse(AppUrl.sendImage+"/"+notication));
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


  Future<bool> addDamagePart( List<CarsSurveyDamagedPartsBean> damagedParts,String carId,String token) async {
   // log(damagedParts[0].surveyDamagedSeverity.toString());

    Map<String,dynamic> req_body = new Map<String,dynamic>();
    req_body['carId']=carId;
    req_body['carsSurveyDamagedPartsBean']=damagedParts.map((i) => i.toJson()).toList();
    log(req_body.toString());
    final response = await post(
        Uri.parse(AppUrl.addDamagePart),
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
  Future<bool> finishSuvey( String userId,String carId,String token) async {

    final response = await get(Uri.parse(AppUrl.finishSurvey+"?carId="+carId+"&userId="+userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      return true;
    }else{
      return false;
    }
  }

  Future<bool> insertRequestStatus( String userId,String carId,String typology,String longitude,String latitude,String token) async {

    Map<String,dynamic> req_body = new Map<String,dynamic>();
    req_body['carId']=carId;
    req_body['userId']= userId;
    req_body['typology']= typology;
    req_body['longitude']= longitude;
    req_body['latitude']= latitude;
    log(req_body.toString());
    final response = await post(
        Uri.parse(AppUrl.insertRequestStatus,),
        headers: {'Content-Type': 'application/json',
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