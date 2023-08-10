// To parse this JSON data, do
//
//     final appDamagesParts = appDamagesPartsFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AppDamagesParts appDamagesPartsFromJson(String str) => AppDamagesParts.fromJson(json.decode(str));

String appDamagesPartsToJson(AppDamagesParts data) => json.encode(data.toJson());

class AppDamagesParts {
  AppDamagesParts({
    required this.appDamagePartResponses,
  });

  List<AppDamagePartResponse> appDamagePartResponses;

  factory AppDamagesParts.fromJson(Map<String, dynamic> json) => AppDamagesParts(
    appDamagePartResponses: List<AppDamagePartResponse>.from(json["appDamagePartResponses"].map((x) => AppDamagePartResponse.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "appDamagePartResponses": appDamagePartResponses == null ? null : List<dynamic>.from(appDamagePartResponses.map((x) => x.toJson())),
  };
}

class AppDamagePartResponse {
  AppDamagePartResponse({
    required this.damagedPartsId,
    required this.carsAppAccidentId,
    required this.damagesPartsPartId,
  });

  String damagedPartsId;
  String carsAppAccidentId;
  String damagesPartsPartId;

  factory AppDamagePartResponse.fromJson(Map<String, dynamic> json) => AppDamagePartResponse(
    damagedPartsId: json["damagedPartsId"] == null ? null : json["damagedPartsId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? null : json["carsAppAccidentId"],
    damagesPartsPartId: json["damagesPartsPartId"] == null ? null : json["damagesPartsPartId"],
  );

  Map<String, dynamic> toJson() => {
    "damagedPartsId": damagedPartsId == null ? null : damagedPartsId,
    "carsAppAccidentId": carsAppAccidentId == null ? null : carsAppAccidentId,
    "damagesPartsPartId": damagesPartsPartId == null ? null : damagesPartsPartId,
  };
}
