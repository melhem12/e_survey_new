import 'package:e_survey/Models/company.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class CompanyService {
  List<Company> companies = [];



  Future<List<Company>> get_data(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.companiesList),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      }
      );

      companies = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List companiesData = extractedData['companyBeanList'];
        for (var i in companiesData) {
          companies.add(Company(
            companyId: i["companyId"],
            companyName: i['companyName'],
          ));
        }
    //    print(companies);

      }

    }catch( e ){
print('error=$e');
throw Exception(e.toString());
    }

    return companies;
  }
}
