// To parse this JSON data, do
//
//     final appBodly = appBodlyFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AppBodly appBodlyFromJson(String str) => AppBodly.fromJson(json.decode(str));

String appBodlyToJson(AppBodly data) => json.encode(data.toJson());

class AppBodly {
  AppBodly({
    required this.bodlyId,
    required this.carsAppAccidentId,
    required this.bodlyInsCountLightInj,
    required this.bodlyInsCountSeverInj,
    required this.bodlyInsCountDeath,
    required this.bodlyTpCountLightInj,
    required this.bodlyTpCountSeverInj,
    required this.bodlyTpCountDeath,
  });

  String bodlyId;
  String carsAppAccidentId;
  int bodlyInsCountLightInj;
  int bodlyInsCountSeverInj;
  int bodlyInsCountDeath;
  int bodlyTpCountLightInj;
  int bodlyTpCountSeverInj;
  int bodlyTpCountDeath;

  factory AppBodly.fromJson(Map<String, dynamic> json) => AppBodly(
    bodlyId: json["bodlyId"] == null ? "" : json["bodlyId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? "" : json["carsAppAccidentId"],
    bodlyInsCountLightInj: json["bodlyInsCountLightInj"] == null ? null : json["bodlyInsCountLightInj"],
    bodlyInsCountSeverInj: json["bodlyInsCountSeverInj"] == null ? null : json["bodlyInsCountSeverInj"],
    bodlyInsCountDeath: json["bodlyInsCountDeath"] == null ? null : json["bodlyInsCountDeath"],
    bodlyTpCountLightInj: json["bodlyTPCountLightInj"] == null ? null : json["bodlyTPCountLightInj"],
    bodlyTpCountSeverInj: json["bodlyTPCountSeverInj"] == null ? null : json["bodlyTPCountSeverInj"],
    bodlyTpCountDeath: json["bodlyTPCountDeath"] == null ? null : json["bodlyTPCountDeath"],
  );

  Map<String, dynamic> toJson() => {
    "bodlyId": bodlyId == null ? '' : bodlyId,
    "carsAppAccidentId": carsAppAccidentId == null ? '' : carsAppAccidentId,
    "bodlyInsCountLightInj": bodlyInsCountLightInj == null ? 0 : bodlyInsCountLightInj,
    "bodlyInsCountSeverInj": bodlyInsCountSeverInj == null ? 0 : bodlyInsCountSeverInj,
    "bodlyInsCountDeath": bodlyInsCountDeath == null ? 0 : bodlyInsCountDeath,
    "bodlyTPCountLightInj": bodlyTpCountLightInj == null ? 0 : bodlyTpCountLightInj,
    "bodlyTPCountSeverInj": bodlyTpCountSeverInj == null ? 0 : bodlyTpCountSeverInj,
    "bodlyTPCountDeath": bodlyTpCountDeath == null ? 0 : bodlyTpCountDeath,
  };
}
