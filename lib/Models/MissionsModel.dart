// To parse this JSON data, do
//
//     final missonsModel = missonsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

MissonsModel missonsModelFromJson(String str) => MissonsModel.fromJson(json.decode(str));

String missonsModelToJson(MissonsModel data) => json.encode(data.toJson());

class MissonsModel {
  MissonsModel({
    required this.missions,
  });

  List<Mission> missions;

  factory MissonsModel.fromJson(Map<String, dynamic> json) => MissonsModel(
    missions: List<Mission>.from(json["missions"].map((x) => Mission.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "missions": List<dynamic>.from(missions.map((x) => x.toJson())),
  };
}

class Mission {
  Mission({
    required this.accidentId,
    required this.accidentNotificationId,
    required this.accidentNotification,
    required this.accidentlocation,
    required this.accidentDetails,
    required this.accidentExpertUserId,
    required this.accidentExpertName,
    required this.accidentBrand,
    required this.accidentTradeMark,
    required this.accidentUsage,
    required this.accidentChassis,
    required this.accidentPlate,
    required this.accidentCustomerName,
    required this.accidentCustomerPhone,
    required this.accidentPolicyNumber,
    required this.accidentPolicyInceptDate,
    required this.accidentPolicyExpiryDate,
    required this.accidentPolicyType,
    required this.accidentPolicyDetails,
    required this.accidentInsurerName,
    required this.accidentCallCenterMobile,
    required this.accidentCallerName,

    required this.accidentContactNumber,
    required this.accidentStatus,
    required this.accdentArrivedStatus,
    required this.time,
    required this.date,
    required this.accidentMake,
  });

  String accidentId;
  String accidentNotificationId;
  String accidentNotification;
  String accidentlocation;
  String accidentDetails;
  String accidentExpertUserId;
  String accidentExpertName;
  String accidentBrand;
  String accidentTradeMark;
  String accidentUsage;
  String accidentChassis;
  String accidentPlate;
  String accidentCustomerName;
  String accidentCustomerPhone;
  String accidentPolicyNumber;
  String accidentPolicyInceptDate;
  String accidentPolicyExpiryDate;
  String accidentPolicyType;
  String accidentPolicyDetails;
  String accidentInsurerName;
  String accidentCallCenterMobile;
  String accidentCallerName;
  String accidentContactNumber;
  String accidentStatus;
  bool accdentArrivedStatus;
  String time;
  String date;
  String accidentMake ;
  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    accidentId: json["accidentId"],
    accidentNotificationId: json["accidentNotificationId"],
    accidentNotification: json["accidentNotification"],
    accidentlocation: json["accidentlocation"] == null ? null : json["accidentlocation"],
    accidentDetails: json["accidentDetails"],
    accidentExpertUserId: json["accidentExpertUserId"],
    accidentExpertName: json["accidentExpertName"],
    accidentBrand: json["accidentBrand"],
    accidentTradeMark: json["accidentTradeMark"],
    accidentUsage: json["accidentUsage"],
    accidentChassis: json["accidentChassis"],
    accidentPlate: json["accidentPlate"],
    accidentCustomerName: json["accidentCustomerName"],
    accidentCustomerPhone: json["accidentCustomerPhone"],
    accidentPolicyNumber: json["accidentPolicyNumber"],
    accidentPolicyInceptDate: json["accidentPolicyInceptDate"],
    accidentPolicyExpiryDate: json["accidentPolicyExpiryDate"] ,
    accidentPolicyType: json["accidentPolicyType"],
    accidentPolicyDetails: json["accidentPolicyDetails"],
    accidentInsurerName: json["accidentInsurerName"] == null ? null : json["accidentInsurerName"],
    accidentCallCenterMobile: json["accidentCallCenterMobile"],
    accidentCallerName: json["accidentCallerName"],
    accidentContactNumber: json["accidentContactNumber"],
    accidentStatus: json["accidentStatus"],
    accdentArrivedStatus: json["accdentArrivedStatus"],
    time: json["time"],
    date: json["date"],
   accidentMake :json["accidentMake"],
  );

  Map<String, dynamic> toJson() => {
    "accidentId": accidentId,
    "accidentNotificationId": accidentNotificationId,
    "accidentNotification": accidentNotification,
    "accidentlocation": accidentlocation == null ? null : accidentlocation,
    "accidentDetails": accidentDetails,
    "accidentExpertUserId": accidentExpertUserId,
    "accidentExpertName": accidentExpertName,
    "accidentBrand": accidentBrand,
    "accidentTradeMark": accidentTradeMark,
    "accidentUsage": accidentUsage,
    "accidentChassis": accidentChassis,
    "accidentPlate": accidentPlate,
    "accidentCustomerName": accidentCustomerName,
    "accidentCustomerPhone": accidentCustomerPhone,
    "accidentPolicyNumber": accidentPolicyNumber,
    "accidentPolicyInceptDate": accidentPolicyInceptDate,
    "accidentPolicyExpiryDate": accidentPolicyExpiryDate ,
    "accidentPolicyType": accidentPolicyType,
    "accidentPolicyDetails": accidentPolicyDetails,
    "accidentInsurerName": accidentInsurerName == null ? null : accidentInsurerName,
    "accidentCallCenterMobile": accidentCallCenterMobile,
    "accidentCallerName": accidentCallerName,
    "accidentContactNumber": accidentContactNumber,
    "accidentStatus": accidentStatus,
    "accdentArrivedStatus": accdentArrivedStatus,
    "time": time,
    "date": date,
    "accidentMake":accidentMake,
  };
}
