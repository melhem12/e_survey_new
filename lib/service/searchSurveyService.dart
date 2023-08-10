import 'package:intl/intl.dart';
import 'package:e_survey/Models/company.dart';
import 'package:http/http.dart';
import 'dart:convert';


class searchSurveySErvice {

  Future<String> get_count(String companyCode,String passNumber,String policynumber,String plateNumber,String plateCharacter,String token) async {
    try {
      String counter ='0';
    //  var url =Server.eSurveySearchCountUri+ "?companyCode=" + item2
      String url='';

      if (!passNumber.isEmpty) {
        url = url + "&passNumber=" + passNumber;
      }
      if (!policynumber.isEmpty) {
        url = url + "&policynumber=" + policynumber;
      }
      if (!plateNumber.isEmpty && !plateCharacter.isEmpty ) {
        url = url + "&plateNumber=" + plateNumber;
        url = url + "&plateCharacter=" + plateCharacter;
      }
      Response response = await get(
          Uri.parse(url), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });


      final extractedData = json.decode(response.body);
      // List companiesData = extractedData['companyBeanList'];
      for (var i in extractedData) {
       counter = i["counter"];
        //   companyId: i["companyId"],
        //   companyName: i['companyName'],

      }
      return counter;
    }catch(e ){
      throw Exception('$e');

    }

  }



}