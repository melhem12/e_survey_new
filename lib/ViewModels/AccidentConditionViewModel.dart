import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:e_survey/Models/AccidentConditionModel.dart';
import 'package:e_survey/View/accidentConditions.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AccidentConditionViewModel extends GetxController {
  final String initialToken;
  final String accidentId;

  AccidentConditionViewModel({required this.initialToken ,required this.accidentId});

  @override
  void onInit() {
    super.onInit();
    getData(initialToken,accidentId);
  }
  RxString  carsAppAccidentId =   "".obs ;
  RxString  accidentConditionsDoubts =   "".obs ;

  Future<void> getData(String token , String accidentId) async {
    final url = Uri.parse(AppUrl.accidentConditions+"?accidentId="+accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        log(AccidentConditionModel.fromJson(jsonDecode(response.body)).accidentConditionsDoubts);
        accidentConditionsDoubts=AccidentConditionModel.fromJson(jsonDecode(response.body)).accidentConditionsDoubts.obs;
        carsAppAccidentId =AccidentConditionModel.fromJson(jsonDecode(response.body)).carsAppAccidentId.obs ;
      } catch (e) {
        Get.snackbar('can not get data', e.toString());
      }
    }

}

}