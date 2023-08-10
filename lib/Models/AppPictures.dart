// To parse this JSON data, do
//
//     final appPictures = appPicturesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AppPictures appPicturesFromJson(String str) => AppPictures.fromJson(json.decode(str));

String appPicturesToJson(AppPictures data) => json.encode(data.toJson());

class AppPictures {
  AppPictures({
    required this.appPicturesId,
    required this.carsAppAccidentId,
    required this.appPicturesGeneral,
    required this.appPicturesCarDamage,
    required this.appPicturesTpPolicy,
    required this.appPicturesDLvr1,
    required this.appPicturesDLvr2,
    required this.appPicturesOptional1,
    required this.appPicturesOptional2,
    required this.appPicturesOptional3,
  });

  String appPicturesId;
  String carsAppAccidentId;
  String appPicturesGeneral;
  String appPicturesCarDamage;
  String appPicturesTpPolicy;
  String appPicturesDLvr1;
  String appPicturesDLvr2;
  String appPicturesOptional1;
  String appPicturesOptional2;
  String appPicturesOptional3;

  factory AppPictures.fromJson(Map<String, dynamic> json) => AppPictures(
    appPicturesId: json["appPicturesId"] == null ? '' : json["appPicturesId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? '' : json["carsAppAccidentId"],
    appPicturesGeneral: json["appPicturesGeneral"] == null ? '' : json["appPicturesGeneral"],
    appPicturesCarDamage: json["appPicturesCarDamage"] == null ? '' : json["appPicturesCarDamage"],
    appPicturesTpPolicy: json["appPicturesTPPolicy"] == null ? '' : json["appPicturesTPPolicy"],
    appPicturesDLvr1: json["appPicturesDLvr1"] == null ? '' : json["appPicturesDLvr1"],
    appPicturesDLvr2: json["appPicturesDLvr2"] == null ? '' : json["appPicturesDLvr2"],
    appPicturesOptional1: json["appPicturesOptional1"] == null ? '' : json["appPicturesOptional1"],
    appPicturesOptional2: json["appPicturesOptional2"] == null ? '' : json["appPicturesOptional2"],
    appPicturesOptional3: json["appPicturesOptional3"] == null ? '' : json["appPicturesOptional3"],
  );

  Map<String, dynamic> toJson() => {
    "appPicturesId": appPicturesId == null ? null : appPicturesId,
    "carsAppAccidentId": carsAppAccidentId == null ? null : carsAppAccidentId,
    "appPicturesGeneral": appPicturesGeneral == null ? null : appPicturesGeneral,
    "appPicturesCarDamage": appPicturesCarDamage == null ? null : appPicturesCarDamage,
    "appPicturesTPPolicy": appPicturesTpPolicy == null ? null : appPicturesTpPolicy,
    "appPicturesDLvr1": appPicturesDLvr1 == null ? null : appPicturesDLvr1,
    "appPicturesDLvr2": appPicturesDLvr2 == null ? null : appPicturesDLvr2,
    "appPicturesOptional1": appPicturesOptional1 == null ? null : appPicturesOptional1,
    "appPicturesOptional2": appPicturesOptional2 == null ? null : appPicturesOptional2,
    "appPicturesOptional3": appPicturesOptional3 == null ? null : appPicturesOptional3,
  };
}
