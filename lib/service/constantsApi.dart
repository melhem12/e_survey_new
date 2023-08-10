import 'dart:developer';

import 'package:e_survey/Models/InsuranceCompany.dart';
import 'package:e_survey/Models/PolicyType.dart';
import 'package:e_survey/Models/body_type.dart';
import 'package:e_survey/Models/brand.dart';
import 'package:e_survey/Models/car_trade_mark.dart';
import 'package:e_survey/Models/description.dart';
import 'package:e_survey/Models/direction.dart';
import 'package:e_survey/Models/doors.dart';
import 'package:e_survey/Models/gender.dart';
import 'package:e_survey/Models/partGroup.dart';
import 'package:e_survey/Models/vehicle_size.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart';
import 'dart:convert';
List<Gender> genders=[];
List<Doors> doors=[];
List<BodyType> body_types=[];
List<VehicleSize> vehicleSizes=[];
List<Brands> brands=[];
List<PartGroup> partGroups=[];
List<Direction> directions=[];
List<Description> descriptions=[];
List<CarTradeMark> carTradeMarks=[];
List<PolicyType> policyTypes=[];
List<InsuranceCompany> insuranceCompanies=[];

class ConstantsApi{
  // Future<List<Gender>> get_genders(String token) async {
  //   log(token);
  //   try {
  //     Response response = await get(
  //         Uri.parse(AppUrl.gendersList),  headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //
  //     genders = [];
  //     final extractedData = json.decode(response.body);
  //     if(extractedData != null) {
  //       List companiesData = extractedData['genderBeanList'];
  //       for (var i in companiesData) {
  //         genders.add(Gender(
  //           genderId: i["genderId"],
  //           genderDescription: i['genderDescription'],
  //         ));
  //       }
  //       //    print(companies);
  //
  //     }
  //
  //   }catch( e ){
  //     print('error=$e');
  //     throw Exception(e.toString());
  //   }
  //
  //   return genders;
  // }
  Future<List<Doors>> get_doors(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.doors) ,  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      doors = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List doorsData = extractedData['doorsBeanList'];
        for (var i in doorsData) {
          doors.add(Doors(
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

    return doors;
  }




  Future<List<BodyType>> get_body_types(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.bodyType) , headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      doors = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List bodyTypeData = extractedData['bodyTypeBeanList'];
        for (var i in bodyTypeData) {
          body_types.add(BodyType(
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

    return body_types;
  }



  Future<List<VehicleSize>> get_vehicle_size(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.vehicleSize),  headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      vehicleSizes = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['vehicleSizeBeanList'];
        for (var i in data) {
          vehicleSizes.add(VehicleSize(
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

    return vehicleSizes;
  }



  Future<List<Brands>> get_brand(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.carBrand),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      });

      vehicleSizes = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['carBrandBeanList'];
        for (var i in data) {
          brands.add(Brands(
            carBrandId: i["carBrandId"],
            carBrandDescription: i['carBrandDescription'],
          ));
        }
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return brands;
  }


  Future<List<Direction>> getDirection(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.directions),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      directions = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['directionsListResponse'];
        for (var i in data) {
          directions.add(Direction(
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

    return directions;
  }



  Future<List<PolicyType>> getPolicyType(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.policyTypes),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      policyTypes = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['policyTypeResponseList'];
        for (var i in data) {
          policyTypes.add(PolicyType(
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

    return policyTypes;
  }







  Future<List<InsuranceCompany>> getCarInsuranceCompanies(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.insuranceCompanies),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      insuranceCompanies = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['insuranceCompanyResponseList'];
        for (var i in data) {
          insuranceCompanies.add(InsuranceCompany(
            supplierId: i["supplierId"],
            supplierName: i['supplierName'],
          ));
        }
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return insuranceCompanies;
  }














  Future<List<Description>> getDescription(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.description),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      });

      descriptions = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List bodyTypeData = extractedData['litigationDamageLovBeanList'];
        for (var i in bodyTypeData) {
          descriptions.add(Description(
            code: i["code"],
            description: i['description'],
          ));
        }
        log(descriptions[0].description);
        //    print(companies);

      }

    }catch( e ){
      print('error=$e');
      throw Exception(e.toString());
    }

    return descriptions;
  }



  Future<List<PartGroup>> get_part_group(String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.partGroup),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      });

      partGroups = [];
      final extractedData = json.decode(response.body);
      if(extractedData != null) {
        List data = extractedData['partGroupBeanList'];
        for (var i in data) {
          partGroups.add(PartGroup(
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

    return partGroups;
  }

  Future<List<CarTradeMark>> getCarTradeMarkList(String carBrandId,String token) async {
    try {
      Response response = await get(
          Uri.parse(AppUrl.carTrademarkList+"?carBrandId="+carBrandId),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      });
      carTradeMarks=[];
      final extractedData = json.decode(response.body);
      List data = extractedData['carTrademarkBeanList'];
      for (var i in data) {
        carTradeMarks.add(CarTradeMark(
          carTrademarkId: i["carTrademarkId"],
          carTrademarkDescription: i['carTrademarkDescription'],
        ));
      }
    }catch(e ){
      print('error=$e');
      throw Exception(e.toString());
    }
    return carTradeMarks;
  }


}