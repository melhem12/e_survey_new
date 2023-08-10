// To parse this JSON data, do
//
//     final appNotes = appNotesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

AppNotes appNotesFromJson(String str) => AppNotes.fromJson(json.decode(str));

String appNotesToJson(AppNotes data) => json.encode(data.toJson());

class AppNotes {
  AppNotes({
    required this.notesId,
    required this.carsAppAccidentId,
    required this.notesRemark,
    required this.voiceNote,
  });

  String notesId;
  String carsAppAccidentId;
  String notesRemark;
  String voiceNote;

  factory AppNotes.fromJson(Map<String, dynamic> json) => AppNotes(
    notesId: json["notesId"] == null ? null : json["notesId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? null : json["carsAppAccidentId"],
    notesRemark: json["notesRemark"] == null ? null : json["notesRemark"],
    voiceNote: json["voiceNote"] == null ? null : json["voiceNote"],
  );

  Map<String, dynamic> toJson() => {
    "notesId": notesId == null ? null : notesId,
    "carsAppAccidentId": carsAppAccidentId == null ? null : carsAppAccidentId,
    "notesRemark": notesRemark == null ? null : notesRemark,
    "voiceNote": voiceNote == null ? null : voiceNote,
  };
}
