import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MissionsViewModel extends GetxController {
  int currentPage = 0;
  final int pageSize = 15;
  bool isLoading = false;
  bool hasMoreData = true;

  MissionsViewModel();

  RxList<Mission> missions = <Mission>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshData(); // Initial data load
    // Set up automatic refresh every 60 seconds
    // Timer.periodic(Duration(seconds: 10), (Timer t) => refreshData());
  }

  Future<void> getData({int page = 0}) async {

    final token1 = await FlutterSecureStorage().read(key: "token");
    if (isLoading || !hasMoreData) return;

    isLoading = true;
    final url = Uri.parse("${AppUrl.missions}?page=$page&pageSize=$pageSize");
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token1'
    });

    if (response.statusCode == 200) {
      try {
        var newMissions =
            MissonsModel.fromJson(jsonDecode(response.body)).missions;
        if (newMissions.length < pageSize) {
          hasMoreData = false; // No more data to load
        }
        if (page == 0) {
          missions.clear(); // Clear existing data for refresh
        }
        missions.addAll(newMissions);
      } catch (e) {
        Get.snackbar('Error', e.toString());
      }
    } else {
      Get.snackbar('Error', 'Cannot get data');
    }

    isLoading = false;
  }

  void refreshData() async {
    missions.clear();

    currentPage = 0; // Reset to the first page
    hasMoreData = true; // Reset hasMoreData flag
    await getData( page: currentPage);
  }

  void searchMission(String query) {
    if (query.isEmpty) {
      // If the search query is empty, reset to show all missions

      refreshData();

      return;
    }

    final List<Mission> suggestions = missions
        .where((mission) =>
        mission.accidentCustomerName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (suggestions.isNotEmpty) {
      log("Search results count: ${suggestions.length}");
      // Update missions with search results
      missions.assignAll(suggestions);
    } else {
      // If no matching missions found, clear the list
      missions.clear();
    }
  }

}
