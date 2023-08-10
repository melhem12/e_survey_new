import 'dart:developer';

import 'package:e_survey/Models/ClaimDetailResponse.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class claimsApi{
  List<ClaimDetailResponse> claimsDetails = [];

  Future<List<ClaimDetailResponse>> get_claims_details(String notificationId ,String companyCode,String token) async {
    var response = await   http.get(Uri.parse(AppUrl.claimsDetails+"notificationId="+notificationId+"&companyCode="+companyCode),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',

        });

    if (response.statusCode == 200) {
      final claimsDetailsData = json.decode(response.body)['claimDetailBeanList'];
      for (var i in claimsDetailsData) {
        claimsDetails.add(ClaimDetailResponse(
          pasNumber :i["pasNumber"].toString(),
          reportedDate:i["reportedDate"].toString(),
          carId:i["carId"].toString(),
          phoneNumber:i["phoneNumber"].toString(),
          licenseNumber:i["licenseNumber"].toString(),
          surveyDamagedLockedUser:i["surveyDamagedLockedUser"].toString(),
          notificationId:i["notificationId"].toString(),
          vehicleOwnerName:i["vehicleOwnerName"].toString(),
          accidentLocation:i["accidentLocation"].toString(),
          lossDate:i["lossDate"].toString(),
          plateNumber:i["plateNumber"].toString(),
          modelYear:i["modelYear"].toString(),
          policyNumber:i["policyNumber"].toString(),
          vehicleNumber:i["vehicleNumber"].toString(),
          brandTrademark:i["brandTrademark"].toString(),

        )
        );

      }
      log(claimsDetails.length.toString());

    }
      else {

      throw Exception('Failed to  get claimDetailBeanList');
    }

    return claimsDetails;
  }



  Future<bool> deleteCarsSurvey(String carId ,String userId, String token) async {
    var response = await   http.delete(Uri.parse(AppUrl.deleteCarsSurvey+carId+"&userId="+userId),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',

        });
    if (response.statusCode == 200) {
return true;
    }
   else if(response.statusCode==405){
      return false;
    }
    else {
      throw Exception('connection error');
    }
  }

  Future<String> insertLossCar(String notification ,String userId,String token) async {
    var response = await   http.post(Uri.parse(AppUrl.insertLossCar),
        headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',

    }
    ,
    body: jsonEncode(<String, String>{
    'userId': userId,
    'notification': notification
    }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {
      final data = json.decode(response.body);
      return    data["carId"].toString();
    }
    else {

      throw Exception('Failed to  get insert loass car');
    }

  }




  Future<void> insertCarsSurvey(String carId ,String userId,String token) async {
    var response = await   http.post(Uri.parse(AppUrl.insertCarsSurvey),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
      ,
      body: jsonEncode(<String, String>{
        'userId': userId,
        'carId': carId
      }),);
    if (response.statusCode == 201 ||response.statusCode == 200) {

    }
    else {

      throw Exception('Failed to  get insert loass car');
    }

  }





}