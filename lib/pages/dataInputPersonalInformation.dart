import 'dart:async';
import 'dart:developer';
import 'package:e_survey/Models/CarDetailsModel.dart';
import 'package:e_survey/Models/gender.dart';
import 'package:e_survey/pages/dataInputCarInformation.dart';
import 'package:e_survey/service/carDetailsApi.dart';
import 'package:e_survey/service/constantsApi.dart';
import 'package:e_survey/service/updatingInformationService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DataInputPersonalInformation extends StatefulWidget {
  final String companyCode;
  final String carId;
  final String vehicleNumber;
  final String notification;
  final String notificationId;
  // const DataInputPersonalInformation({Key? key}) : super(key: key);
  const DataInputPersonalInformation(
      {Key? key,
      required this.companyCode,
      required this.carId,
      required this.vehicleNumber,
        required this.notification,

        required this.notificationId})
      : super(key: key);
  static const routeName = '/DataInputPersonalInformation';

  @override
  _DataInputPersonalInformationState createState() =>
      _DataInputPersonalInformationState();
}

double height = 15;
class _DataInputPersonalInformationState extends State<DataInputPersonalInformation> {
  late Future<List<Gender>> futureGender;

  late Future myFuture= Future(() => null);

  CarDetailsModel carDetailsModel = CarDetailsModel();

  DateTime? _selectedLicenseDate = DateTime.now();
  TextEditingController _textEditingLicenseDateController =
      TextEditingController();
  SharedPreferences? _prefs;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedLicenseExpiryDate = DateTime.now();
  TextEditingController _textEditingLicenseExpiryDateController =
      TextEditingController();

  DateTime? dob = DateTime.now();
  TextEditingController _textEditingdobController = TextEditingController();
  final firstNameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final licenseNumber = TextEditingController();
  late Gender _gender = Gender(genderId: '', genderDescription: '');
  static const String userIDPrefKey = 'userId_pref';
  String savedUid = "";
  static const String tokenPrefKey = 'token_pref';
  String token ="";
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadUserId();
      log(token);
      myFuture = carDetailsApi().getCarDetails(widget.carId, widget.companyCode,token);

    }
    );

    log("////////////////????????????????");
   // futureGender = ConstantsApi().get_genders(token);
    super.initState();
  }
  // getGenderObject() async {
  //   CarDetailsModel carDetailsModel= await myFuture;
  //   List<Gender> gen = await futureGender as List<Gender>;
  //   for (var i in gen) {
  //     if ( carDetailsModel.== i.genderId) {
  //       setState(() {
  //         _gender = i;
  //         log("/////zzzzzzz///");
  //       });
  //       break;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // temp = yourFuture;
    log(widget.vehicleNumber);
    log(_gender.genderDescription);
    // return MaterialApp(
    //
    //
    //     title: 'Personal Information',
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       primarySwatch: Colors.blue,
    //     ),

       // home:
   return  WillPopScope (
        onWillPop: (

            ) async {
          bool updated = await update(widget.carId,firstNameController.text,
              lastNameController.text,fatherNameController.text,
              _textEditingLicenseDateController.text,
              _textEditingLicenseExpiryDateController.text,phoneNumberController.text,
              licenseNumber.text, savedUid,_gender.genderId);

          if(updated) {
            ScaffoldMessenger.of(
                context)
                .showSnackBar(
              SnackBar(
                backgroundColor:
                Colors.blue,
                content: Text("updated personaal info"),

                //action: SnackBarAction(label: 'OK', onPressed: () {}),
              ),
            );
            return true;
          }
          else {
            ScaffoldMessenger.of(
                context)
                .showSnackBar(
              SnackBar(
                backgroundColor:
                Colors.red,
                content: Text("updated failed"),

              ),
            );
          }
          return false;
        },

    child:
     Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(title: Text("Personal info")),
          body: SingleChildScrollView(
              child: FutureBuilder(
                  future: myFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                              key: _formKey,
                              child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:
                                      new EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text("Personal Information",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextFormField(




                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter First Name';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),

                                  controller: firstNameController
                                    ..text = snapshot.data.carOwnerFirstName ==
                                                "null" ||
                                            snapshot
                                                .data.carOwnerFirstName.isEmpty
                                        ? ''
                                        : snapshot.data.carOwnerFirstName,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,




                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red)),

                                    hintText: "Enter First Name",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.grey[300],
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),




                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter father name';
                                    }
                                    return null;
                                  },
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  controller: fatherNameController
                                    ..text = snapshot.data.carOwnerFatherName ==
                                                "null" ||
                                            snapshot
                                                .data.carOwnerFatherName.isEmpty
                                        ? ''
                                        : snapshot.data.carOwnerFatherName,
                                  decoration: InputDecoration(
                                    labelText: 'Father Name',
                                    isDense: true,
                                    border: InputBorder.none,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter Father Name",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),

                                    //  border: InputBorder.none,
                                    fillColor: Colors.grey[300],
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red)),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Last name';
                                    }
                                    return null;
                                  },
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  controller: lastNameController
                                    ..text = snapshot.data.carOwnerFamilyName ==
                                                "null" ||
                                            snapshot
                                                .data.carOwnerFamilyName.isEmpty
                                        ? ''
                                        : snapshot.data.carOwnerFamilyName,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter Last Name",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red)),
                                    fillColor: Colors.grey[300],
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextField(
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  controller: phoneNumberController
                                    ..text = snapshot.data.phoneNumber ==
                                                "null" ||
                                            snapshot.data.phoneNumber.isEmpty
                                        ? ''
                                        : snapshot.data.phoneNumber,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter Phone Number",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.grey[300],
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),



                                
                                // SizedBox(
                                //   height: height,
                                // ),
                                // Container(
                                //   child: Column(
                                //     children: <Widget>[
                                //       Text("Gender ",
                                //           style: TextStyle(
                                //             fontSize: 14,
                                //             color: Colors.grey,
                                //           )),
                                //
                                //
                                //
                                //
                                //       StatefulBuilder(builder:
                                //           (BuildContext context,
                                //               StateSetter setState) {
                                //         return FutureBuilder<List<Gender>>(
                                //             future: futureGender,
                                //             builder: (BuildContext context,
                                //                 AsyncSnapshot<List<Gender>>
                                //                     snapshot) {
                                //               if (!snapshot.hasData)
                                //                 return Center(
                                //                   child: CircularProgressIndicator()
                                //                   ,
                                //                 );;
                                //               return DropdownButton<Gender>(
                                //
                                //                 items: snapshot.data!
                                //                     .map((gender) =>
                                //                         DropdownMenuItem<
                                //                             Gender>(
                                //                           enabled: widget.vehicleNumber == "0"
                                //                               ? false
                                //                               : true,
                                //                           child: Text(gender
                                //                               .genderDescription),
                                //                           value: gender,
                                //                         ))
                                //                     .toList(),
                                //                 onChanged: (Gender? value) {
                                //                   log(value!.genderDescription);
                                //
                                //                   setState(
                                //                       () => _gender = value);
                                //                 },
                                //                 isExpanded: true,
                                //                 value: _gender.genderId.isEmpty
                                //                     ? null
                                //                     : snapshot.data![
                                //                 snapshot.data!.indexOf(_gender)],
                                //                 hint: new Text("Select gender"),
                                //               );
                                //             });
                                //       }
                                //       ),
                                //
                                //
                                //
                                //
                                //     ],
                                //   ),
                                // ),



                                // SizedBox(
                                //   height: height,
                                // ),
                                // TextField(
                                //   enabled: widget.vehicleNumber == "0"
                                //       ? false
                                //       : true,
                                //   style: TextStyle(
                                //     color: Colors.blue,
                                //   ),
                                //   focusNode: AlwaysDisabledFocusNode(),
                                //   controller: _textEditingdobController,
                                //   onTap: () {
                                //     _selectDate(context,
                                //         _textEditingdobController, dob!);
                                //   },
                                //   decoration: InputDecoration(
                                //     labelText: 'Date of Birth',
                                //     isDense: true,
                                //     labelStyle: TextStyle(
                                //       color: Colors.blue,
                                //     ),
                                //     hintText: "Enter Date of Birth",
                                //     hintStyle: TextStyle(
                                //       color: Colors.blue,
                                //     ),
                                //     suffixIcon:
                                //         Icon(Icons.calendar_today_outlined),
                                //     fillColor: Colors.grey[300],
                                //     border: InputBorder.none,
                                //     focusedBorder: UnderlineInputBorder(
                                //       borderSide: BorderSide(
                                //           color:
                                //               Colors.blue),
                                //     ),
                                //     filled: true,
                                //   ),
                                // ),

                                SizedBox(
                                  height: height,
                                ),
                                Container(
                                  margin:
                                      new EdgeInsets.symmetric(vertical: 10.0),
                                  child: Text("License Information",
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.black,
                                      )),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextField(
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  controller: licenseNumber
                                    ..text = snapshot.data.licenseNumber ==
                                                "null" ||
                                            snapshot.data.licenseNumber.isEmpty
                                        ? ''
                                        : snapshot.data.licenseNumber,
                                  decoration: InputDecoration(
                                    labelText: 'License Number',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter License Number",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.grey[300],
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextField(
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller: _textEditingLicenseDateController
                                    ..text = snapshot.data.licenseDate ==
                                                "null" ||
                                            snapshot.data.licenseDate.isEmpty
                                        ? ''
                                        : snapshot.data.licenseDate,
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  onTap: () {
                                    print("asdasdasd");
                                    _selectDate(
                                        context,
                                        _textEditingLicenseDateController,
                                        _selectedLicenseDate!);
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.calendar_today_outlined),
                                    labelText: 'License Date',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter License Date",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    fillColor: Colors.grey[300],
                                    border: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),
                                SizedBox(
                                  height: height,
                                ),
                                TextField(
                                  enabled: widget.vehicleNumber == "0"
                                      ? false
                                      : true,
                                  focusNode: AlwaysDisabledFocusNode(),
                                  controller:
                                      _textEditingLicenseExpiryDateController
                                        ..text = snapshot.data
                                                        .licenseExpiryDate ==
                                                    "null" ||
                                                snapshot.data.licenseExpiryDate
                                                    .isEmpty
                                            ? ''
                                            : snapshot.data.licenseExpiryDate,
                                  onTap: () {
                                    _selectDate(
                                        context,
                                        _textEditingLicenseExpiryDateController,
                                        _selectedLicenseExpiryDate!);
                                  },

                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.calendar_today_outlined),
                                    labelText: 'License Expiry Date',
                                    isDense: true,
                                    labelStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    hintText: "Enter License Expiry Date",
                                    hintStyle: TextStyle(
                                      color: Colors.blue,
                                    ),
                                    border: InputBorder.none,
                                    fillColor: Colors.grey[300],
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Colors.blue),
                                    ),
                                    filled: true,
                                  ),
                                ),





                                SizedBox(
                                  height: height,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () async {

    bool updated = await update(widget.carId,firstNameController.text,
    lastNameController.text,fatherNameController.text,
    _textEditingLicenseDateController.text,
    _textEditingLicenseExpiryDateController.text,phoneNumberController.text,
    licenseNumber.text, savedUid,_gender.genderId);

    if(updated) {
    ScaffoldMessenger.of(
    context)
        .showSnackBar(
    SnackBar(
    backgroundColor:
    Colors.blue,
    content: Text("updated personaal info"),

    //action: SnackBarAction(label: 'OK', onPressed: () {}),
    ),
    );
    Navigator.pop(context);
    }
    else {
      ScaffoldMessenger.of(
          context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
          Colors.red,
          content: Text("updated failed"),

        ),
      );
    }

                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                textStyle: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      height: height,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: ElevatedButton(
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () async {
                                              if (_formKey.currentState!.validate()) {
                                                bool updated = await update(widget.carId,firstNameController.text,
                                                    lastNameController.text,fatherNameController.text,
                                                    _textEditingLicenseDateController.text,
                                                    _textEditingLicenseExpiryDateController.text,phoneNumberController.text,
                                                    licenseNumber.text, savedUid,_gender.genderId);

                                                if(updated)  {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                      Colors.blue,
                                                      content: Text("updated personaal info"),

                                                      //action: SnackBarAction(label: 'OK', onPressed: () {}),
                                                    ),
                                                  );
                                                  Navigator.of(context).push(MaterialPageRoute(
                                                      builder: (context) => DataInputCarInformation( snapshot.data
                                                          .carTrademarkId,
                                                          snapshot.data.doors,
                                                          snapshot.data.bodyType,
                                                          snapshot
                                                              .data.vehicleSize,
                                                          snapshot.data.carId,
                                                          snapshot.data
                                                              .notificationId,
                                                          snapshot.data
                                                              .vehicleOwnerName,
                                                          snapshot.data
                                                              .carOwnerMaidenName,
                                                          snapshot.data
                                                              .accidentLocation,
                                                          snapshot.data.shapeID,
                                                          snapshot.data
                                                              .brandTradeMark,
                                                          snapshot.data.pasNumber,
                                                          snapshot
                                                              .data.reportedDate,
                                                          snapshot.data.modelYear,
                                                          snapshot.data.brandId,
                                                          snapshot
                                                              .data.claimStatus,
                                                          snapshot
                                                              .data.claimNumber,
                                                          snapshot
                                                              .data.chasisNumber,
                                                          snapshot
                                                              .data.insurerCode,
                                                          snapshot
                                                              .data.plateNumber,
                                                          snapshot
                                                              .data.vehicleNumber,
                                                          snapshot.data
                                                              .policyNumber,firstNameController.text,fatherNameController.text,lastNameController.text,widget.companyCode.toString(),widget.notification.toString(),snapshot.data.insuranceCompanyId,snapshot.data.policyType)
                                                  ));


                                                }
                                                else{
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      backgroundColor:
                                                      Colors.red,
                                                      content: Text("updated failed"),

                                                    ),
                                                  );
                                                }

                                              } else {
                                                print("not ok");
                                              }








                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                textStyle: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ))

                                  ],
                                ),
                              ]),
                        ),),
                      );
                    } else if (snapshot.hasError) {
                      return Icon(Icons.error_outline);
                    } else {
                      return Center(

                        child: CircularProgressIndicator()
                        ,
                      );
                    }
                  }
              )
          )
    ),
        );
  }



  _selectDate(
      BuildContext context,
      TextEditingController _textEditingController,
      DateTime _selectedDate) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue,
                onPrimary: Colors.blue,
                surface: Colors.blueGrey,
                onSurface: Colors.blue,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
            // child: ?child,
          );
        }
        );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      final DateFormat format = DateFormat('dd/MM/yyyy');
      log(_selectedDate.toString());
      _textEditingController
        ..text = format.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _textEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  void _loadUserId() {
    setState(() {
      this.savedUid = this._prefs?.getString(userIDPrefKey) ?? "";
      this.token=this._prefs?.getString(tokenPrefKey)??"";

    });
  }

  Future<bool> update(String carId,String carOwnerFirstName,String carOwnerFamilyName,String carOwnerFatherName,String licenseDate,String licenseExpiryDate,String phoneNumber,String licenseNumber,String userId,String gender ) async {
    bool updated  = await updatingInformationService().update( carId, carOwnerFirstName, carOwnerFamilyName, carOwnerFatherName, licenseDate, licenseExpiryDate, phoneNumber, licenseNumber, userId, gender,token);
    return updated;
  }
}
// bool checkLicenseDate(){
//
//   return true;
// }



class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

