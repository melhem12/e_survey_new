// To parse this JSON data, do
//
//     final accidentConditionModel = accidentConditionModelFromJson(jsonString);

import 'dart:convert';

AccidentConditionModel accidentConditionModelFromJson(String str) => AccidentConditionModel.fromJson(json.decode(str));

String accidentConditionModelToJson(AccidentConditionModel data) => json.encode(data.toJson());

class AccidentConditionModel {
  AccidentConditionModel({
    required this.accidentConditionsTpfDamage,
    required this.accidentConditionsResponsib,
    required this.accidentConditionsDoubts,
    required this.accidentConditiosTpCount,
    required this.accidentConditionsId,
    required this.carsAppAccidentId,
  });

  String accidentConditionsTpfDamage;
  String accidentConditionsResponsib;
  String accidentConditionsDoubts;
  int accidentConditiosTpCount;
  String accidentConditionsId;
  String carsAppAccidentId;

  factory AccidentConditionModel.fromJson(Map<String, dynamic> json) => AccidentConditionModel(
    accidentConditionsTpfDamage: json["accidentConditionsTPFDamage"] == null ? '' : json["accidentConditionsTPFDamage"],
    accidentConditionsResponsib: json["accidentConditionsResponsib"] == null ? '' : json["accidentConditionsResponsib"],
    accidentConditionsDoubts: json["accidentConditionsDoubts"] == null ? '' : json["accidentConditionsDoubts"],
    accidentConditiosTpCount: json["accidentConditiosTPCount"] == 0 ? 0 : json["accidentConditiosTPCount"],
    accidentConditionsId: json["accidentConditionsId"] == null ? '' : json["accidentConditionsId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? '' : json["carsAppAccidentId"],
  );

  Map<String, dynamic> toJson() => {
    "accidentConditionsTPFDamage": accidentConditionsTpfDamage == null ? null : accidentConditionsTpfDamage,
    "accidentConditionsResponsib": accidentConditionsResponsib == null ? null : accidentConditionsResponsib,
    "accidentConditionsDoubts": accidentConditionsDoubts == null ? null : accidentConditionsDoubts,
    "accidentConditiosTPCount": accidentConditiosTpCount == null ? null : accidentConditiosTpCount,
    "accidentConditionsId": accidentConditionsId == null ? null : accidentConditionsId,
    "carsAppAccidentId": carsAppAccidentId == null ? null : carsAppAccidentId,
  };
}
