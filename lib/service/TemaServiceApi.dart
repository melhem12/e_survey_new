import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:e_survey/Models/AppBodly.dart';
import 'package:e_survey/Models/AppDamagesParts.dart';
import 'package:e_survey/Models/AppPictures.dart';
import 'package:e_survey/Models/Doubts.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';
import '../Models/AccidentConditionModel.dart';
import '../Models/AppDamage.dart';
import '../Models/AppNotes.dart';
import '../Models/LoginResponse.dart';
import '../Models/Responsability.dart';
import '../View/expert_missions.dart';
import '../View/expert_missions2.dart';
import '../pages/signin.dart';

class TemaServiceApi {
  List<AppDamage> appDamages = [];
  late AccidentConditionModel accidentConditionModel;
  AppPictures appPictures = AppPictures(
      appPicturesId: '',
      carsAppAccidentId: '',
      appPicturesGeneral: false,
      appPicturesCarDamage: false,
      appPicturesTpPolicy: false,
      appPicturesDLvr1: false,
      appPicturesDLvr2: false,
      appPicturesOptional1: false,
      appPicturesOptional2: false,
      appPicturesOptional3: false);

  AppNotes appNotes = AppNotes(
      notesId: '', carsAppAccidentId: '', notesRemark: '', voiceNote: '');
  AppBodly appBodly = AppBodly(
      bodlyId: '',
      carsAppAccidentId: '0',
      bodlyInsCountLightInj: 0,
      bodlyInsCountSeverInj: 0,
      bodlyInsCountDeath: 0,
      bodlyTpCountLightInj: 0,
      bodlyTpCountSeverInj: 0,
      bodlyTpCountDeath: 0);
  List<Responsability> responsabilities = [];

  List<AppDamagePartResponse> damageList = <AppDamagePartResponse>[];
  List<Doubts> doubtsList = [];

  // Future<void>

  Future<void> updateAccidentStatus(BuildContext context, String status,
      String accidentId, String token) async {
    try {
      var response = await http.post(
        Uri.parse(AppUrl.updateAccidentStatus),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            <String, String>{'accidentId': accidentId, 'status': status}),
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to update Accident Status');
      }
    } catch (e) {
      await _showDialog(context, e.toString());
    }
  }

  Future<void> _showDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context, // You need to pass context from your widget
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> updateArrivedStatus(bool arrived, String accidentId,
      String token, String longitude, String latitude) async {
    print("mmmmmmmmmm");
    log(token);
    log(accidentId);
    bool success = false;

    var response = await http.post(
      Uri.parse(AppUrl.updateArrivedStatus),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, Object>{
        'accidentID': accidentId,
        'arrived': arrived,
        'longitude': longitude,
        'latitude': latitude
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      log("kkkkkkkkkkkkkk");
      log(response.body);
      final data = json.decode(response.body)["data"];
      success = data["verficationSuccess"];

      return success;
    } else {
      throw Exception('Failed to  get insert updateArrivedStatus ');
    }
  }

  Future<List<AppDamage>> get_AppDamage(String token) async {
    try {
      Response response =
          await get(Uri.parse(AppUrl.damageCap), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      appDamages = [];
      final extractedData = json.decode(utf8.decode(response.bodyBytes));
      if (extractedData != null) {
        List data = extractedData['data'];
        for (var i in data) {
          appDamages.add(AppDamage(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);
      }
    } catch (e) {
      print('error=$e');
      throw Exception(e.toString());
    }

    return appDamages;
  }

  Future<List<Responsability>> get_responsability(String token) async {
    try {
      Response response = await get(Uri.parse(AppUrl.responsabilities),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });

      responsabilities = [];
      final extractedData = json.decode((utf8.decode(response.bodyBytes)));
      if (extractedData != null) {
        List data = extractedData['data'];
        for (var i in data) {
          responsabilities.add(Responsability(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);
      }
    } catch (e) {
      print('error=$e');
      throw Exception(e.toString());
    }

    return responsabilities;
  }

  Future<List<Doubts>> get_doubts(String token) async {
    try {
      Response response =
          await get(Uri.parse(AppUrl.doubts), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      doubtsList = [];
      final extractedData = json.decode((utf8.decode(response.bodyBytes)));
      if (extractedData != null) {
        List data = extractedData['data'];
        for (var i in data) {
          doubtsList.add(Doubts(
            code: i["code"],
            description: i['description'],
          ));
        }
        //    print(companies);
      }
    } catch (e) {
      print('error=$e');
      throw Exception(e.toString());
    }

    return doubtsList;
  }

  Future<void> insertAccidentConditions(
      String accidentId,
      String token,
      String accidentConditionsTPFDamage,
      String accidentConditionsResponsib,
      String accidentConditionsDoubts,
      num accidentConditiosTPCount) async {
    var response = await http.post(
      Uri.parse(AppUrl.insertAccidentConditions),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'carsAppAccidentId': accidentId,
        'accidentConditionsTPFDamage': accidentConditionsTPFDamage,
        'accidentConditionsResponsib': accidentConditionsResponsib,
        'accidentConditionsDoubts': accidentConditionsDoubts,
        'accidentConditiosTPCount': accidentConditiosTPCount,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to  get insert loass car');
    }
  }

  Future<AccidentConditionModel> getAccidentCondition(
      String token, String accidentId) async {
    final url =
        Uri.parse(AppUrl.accidentConditions + "?accidentId=" + accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        log("done");
        log(AccidentConditionModel.fromJson(jsonDecode(response.body)["data"])
            .accidentConditionsDoubts);
        accidentConditionModel =
            AccidentConditionModel.fromJson(jsonDecode(response.body)["data"]);
      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }
    }
    return accidentConditionModel;
  }

  Future<AppPictures> getAccPictures(String token, String accidentId) async {
    final url = Uri.parse(AppUrl.getAccPictures + "?accidentId=" + accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appPictures = AppPictures.fromJson(jsonDecode(response.body)['data']);
      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }
    }
    return appPictures;
  }

  Future<AppNotes> getNotes(String token, String accidentId) async {
    final url = Uri.parse(AppUrl.getNotes + "?accidentId=" + accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appNotes = AppNotes.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes))['data']);
      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }
    }
    return appNotes;
  }

  Future<http.Response> uploadImageWithProgress(
    String filePath,
    String name,
    String token,
    String accidentId,
    void Function(int sent, int total)? onProgress,
  ) async {
    final uri = Uri.parse(AppUrl.uploadAccidentPicturesToDatabase +
        "?accidentId=" +
        accidentId +
        "&name=" +
        name);
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['name'] = name
      ..fields['accidentId'] = accidentId
      ..files.add(http.MultipartFile(
        'file',
        File(filePath).readAsBytes().asStream(),
        File(filePath).lengthSync(),
        filename: name, // You can customize the filename here
      ));

    final responseStream = await request.send();
    final response = await http.Response.fromStream(responseStream);

    return response;
  }

  Future uploadImage(
      String filename, String name, String token, String accidentId,BuildContext context) async {
    refreshToken(context);

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppUrl.uploadAccidentPicturesToDatabase +
            "?accidentId=" +
            accidentId +
            "&name=" +
            name));
    request.files.add(await http.MultipartFile.fromPath(
      'file',
      filename,
    ));
    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    var res = await request.send();
  }

  Future<AppBodly> getCarsAppBodly(String token, String accidentId,BuildContext context) async {
    refreshToken(context);
    final url = Uri.parse(AppUrl.getCarsAppBodly + "?accidentId=" + accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        appBodly = AppBodly.fromJson(jsonDecode(response.body)['data']);
      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }
    }
    return appBodly;
  }

  Future<List<AppDamagePartResponse>> getCarsAppDamageParts(
      String token, String accidentId,BuildContext context) async {
    refreshToken(context);

    final url =
        Uri.parse(AppUrl.getCarsAppDamageParts + "?accidentId=" + accidentId);
    http.Response response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 200) {
      try {
        damageList.addAll(AppDamagesParts.fromJson(jsonDecode(response.body))
            .appDamagePartResponses);
      } catch (e) {
        log(e.toString());
        //   Get.snackbar('can not get data', e.toString());
      }
    }
    return damageList;
  }

  Future<void> updateCarsAppBodly(
      String accidentId, String token, AppBodly myAppBodly,BuildContext context) async {
    refreshToken(context);

    var response = await http.post(
      Uri.parse(AppUrl.updateCarsAppBodly),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'carsAppAccidentId': accidentId,
        'bodlyInsCountDeath': myAppBodly.bodlyInsCountDeath,
        'bodlyInsCountLightInj': myAppBodly.bodlyInsCountLightInj,
        'bodlyInsCountSeverInj': myAppBodly.bodlyInsCountSeverInj,
        'bodlyTPCountLightInj': myAppBodly.bodlyTpCountLightInj,
        'bodlyTPCountSeverInj': myAppBodly.bodlyTpCountSeverInj,
        'bodlyTPCountDeath': myAppBodly.bodlyTpCountDeath,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to  get insert loass car');
    }
  }

  Future uploadNotes(String? filename, String notesRemark, String token,
      String carsAppAccidentId,BuildContext context) async {
    refreshToken(context);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(AppUrl.uploadNotes +
          "?carsAppAccidentId=$carsAppAccidentId&notesRemark=$notesRemark"),
    );

    if (filename != null) {
      var file = File(filename);
      if (await file.exists()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            filename,
          ),
        );
      } else {
        print('File does not exist.');
      }
    }

    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });

    var res = await request.send();
  }

  Future<void> updateGeoLocation(
      String latitude, String longitude, String token) async {
    print("lllllllllllllllllllllllll location");
    var response = await http.post(
      Uri.parse(AppUrl.updateGeoLocation),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
          <String, String>{'longitude': longitude, 'latitude': latitude}),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to  get insert location ');
    }
  }

  void updateGeoStatus(String status, String token) async {
    var response = await http.post(
      Uri.parse(AppUrl.updateGeoStatus),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'status': status,
      }),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
    } else {
      throw Exception('Failed to  get insert location ');
    }
  }

  Future<void> refreshToken(BuildContext context) async {
    final url = Uri.parse(AppUrl.refresh_token_app);
    final box = FlutterSecureStorage();

    try {
      final refreshTokenOld = await box.read(key: "refresh_token");
      log("Old Refresh Token: $refreshTokenOld");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'refreshToken': refreshTokenOld,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String token = responseData['token'];
        await box.write(key: 'token', value: token);
        print('New Token: $token');

        String refreshToken = responseData['refreshToken'];
        await box.write(
            key: 'refresh_token',
            value: refreshToken); // Use consistent key name
      } else {



        // Handle different status codes or add a general error log
        log('Request failed with status: ${response.statusCode}.');
        logout( context);
      }
    } catch (error) {
      log('An error occurred: $error');
      logout( context);
    }
  }


  Future<void> logout(BuildContext context) async {
    final storage = FlutterSecureStorage();

    await storage.delete(key: "token");
    await storage.delete(key: "refresh_token");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Signin()));
  }


  Future<LoginResponse> login(
      String username, String password, BuildContext context) async {
    final url = Uri.parse(AppUrl.login);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return LoginResponse(
          token: responseData['data']['token'],
          refreshToken: responseData['data']['refreshToken'],
        );
      } else {
        _showDialog(context, "failed to login ");
        print('Login failed with status code: ${response.statusCode}');
        return LoginResponse(token: '', refreshToken: '');
      }
    } catch (error) {
      print('Error occurred: $error');
      return LoginResponse(token: '', refreshToken: '');
    }
  }

  Future<bool> updateCarsAppDamageParts(
      List<AppDamagePartResponse> damagedParts,
      String token,
      String accidentId,BuildContext context) async {
    refreshToken(context);

    // log(damagedParts[0].surveyDamagedSeverity.toString());

    Map<String, dynamic> req_body = <String, dynamic>{};
    req_body['accidentId'] = accidentId;

    req_body['carsAppDamagePartsRequest'] =
        damagedParts.map((i) => i.toJson()).toList();
    log(req_body.toString());
    final response = await post(Uri.parse(AppUrl.updateCarsAppDamageParts),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(req_body));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateCarsAppDamagePartsPic(
      String token, String accidentId, Uint8List capturedImage,BuildContext context) async {
    refreshToken(context);
    try {
      // Add the image as a MultipartFile
      http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
        'file',
        capturedImage,
        filename: 'image.png',
      );
      Map<String, dynamic> req_body = <String, dynamic>{};

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            AppUrl.updateCarsAppDamagePartsPic + "?accidentId=" + accidentId),
      );

      request.files.add(multipartFile);
      // Add headers to the request
      request.headers.addAll({
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Send the request and get the response
      var streamedResponse = await request.send();

      // Read the response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
