import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MissionsViewModel extends GetxController {
  final String initialToken;
  int currentPage = 0;
  final int pageSize = 10;
  bool isLoading = false;
  bool hasMoreData = true;

  MissionsViewModel({required this.initialToken});

  RxList<Mission> missions = <Mission>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshData(); // Initial data load
    // Set up automatic refresh every 60 seconds
    Timer.periodic(Duration(seconds: 200), (Timer t) => refreshData());
  }

  Future<void> getData(String token, {int page = 0}) async {

    if (isLoading || !hasMoreData) return;

    isLoading = true;
    final url = Uri.parse("${AppUrl.missions}?page=$page&pageSize=$pageSize");
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      try {
        var newMissions = MissonsModel.fromJson(jsonDecode(response.body)).missions;
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
    currentPage = 0; // Reset to the first page
    hasMoreData = true; // Reset hasMoreData flag
    await getData(initialToken, page: currentPage);
  }

  void searchMission(String query) {
    final suggestions = missions.where((element) {
      final accidentCustomerName = element.accidentCustomerName.toLowerCase();
      final input = query.toLowerCase();
      return accidentCustomerName.contains(input);
    }).toList();

    if (suggestions != null) {
      log("Search results count: ${suggestions.length}");
      missions.clear();
      missions.addAll(suggestions);
    }
  }
}
