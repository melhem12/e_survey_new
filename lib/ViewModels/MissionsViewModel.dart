import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MissionsViewModel extends GetxController {
  final String initialToken;

  MissionsViewModel({required this.initialToken});

  @override
  void onInit() {
    super.onInit();
    getData(initialToken);

  }


  RxList<Mission> missions = <Mission>[].obs;


  Future<void> getData(String token) async {
    missions.clear();
    final url = Uri.parse(AppUrl.missions);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        missions
            .addAll(MissonsModel.fromJson(jsonDecode(response.body)).missions);
      } catch (e) {
        Get.snackbar('can not get data', e.toString());
      }
    }
  }
  void searchMission(String query){
    final suggestions = missions.where((element)  {
      final accidentId = element.accidentId.toLowerCase();
      final input= query.toLowerCase();
      return accidentId.contains(input);
    }).toList();
    if(suggestions!=null){
      log(".......................");
log(suggestions.length.toString());
missions.clear();
missions=suggestions.obs;
      //missions=suggestions.obs as RxList<Mission>;

    }


  }
}
