import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_survey/Models/InsuranceCompany.dart';
import 'package:e_survey/Models/PolicyType.dart';
import 'package:e_survey/Models/body_type.dart';
// import 'package:flutter_mobile_vision_2/flutter_mobile_vision_2.dart';
import 'package:e_survey/Models/brand.dart';
import 'package:e_survey/Models/car_trade_mark.dart';
import 'package:e_survey/Models/company.dart';
import 'package:e_survey/Models/doors.dart';
import 'package:e_survey/Models/vehicle_size.dart';
import 'package:e_survey/args/BigArgs.dart';
import 'package:e_survey/args/CarImputArgs.dart';
import 'package:e_survey/args/claimsListArgs.dart';
import 'package:e_survey/args/personalInfoArgs.dart';
import 'package:e_survey/pages/requiredDocuments.dart';
import 'package:e_survey/service/constantsApi.dart';
import 'package:e_survey/service/updatingInformationService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class DataInputCarInformation extends StatefulWidget {
  String? carTrademarkId;
  String? doors;
  String? bodyType;
  String? vehicleSize;
  String? carId;
  String? notificationId;
  String? vehicleOwnerName;
  String? carOwnerMaidenName;
  String? accidentLocation;
  String? shapeID;
  String? brandTradeMark;
  String? pasNumber;
  String? reportedDate;
  String? modelYear;
  String? brandId;
  String? claimStatus;
  String? claimNumber;
  String? chasisNumber;
  String? insurerCode;
  String? plateNumber;
  String? vehicleNumber;
  String? policyNumber;
  String? fName;
  String? fatherName;
  String? lastName;
  String? companyCode;
  String? notification;
   String ? insuranceCompanyId;
   String ? policyType;
  static const routeName = '/DataInputCarInformation';

  DataInputCarInformation(
      this.carTrademarkId,
      this.doors,
      this.bodyType,
      this.vehicleSize,
      this.carId,
      this.notificationId,
      this.vehicleOwnerName,
      this.carOwnerMaidenName,
      this.accidentLocation,
      this.shapeID,
      this.brandTradeMark,
      this.pasNumber,
      this.reportedDate,
      this.modelYear,
      this.brandId,
      this.claimStatus,
      this.claimNumber,
      this.chasisNumber,
      this.insurerCode,
      this.plateNumber,
      this.vehicleNumber,
      this.policyNumber,
      this.fName,
      this.fatherName,
      this.lastName,
     this.companyCode,
      this.notification,
      this.insuranceCompanyId,
      this.policyType,

      );

  DataInputCarInformation.n();

  @override
  _DataInputCarInformationState createState() =>

      _DataInputCarInformationState();
}

class _DataInputCarInformationState extends State<DataInputCarInformation> {
  late Future<List<Brands>> futureBrand=Future.value([]);
  late Future<List<CarTradeMark>> futureTrademark=Future.value([]);
  late Future<List<Doors>> futureDoors=Future.value([]);
  late Future<List<VehicleSize>> futureVSize=Future.value([]);
  late Future<List<BodyType>> futureBodyType=Future.value([]);
  late Future<List<InsuranceCompany>> futureInsuranceCompanies=Future.value([]);
  late Future<List<PolicyType>> futurePolicyType=Future.value([]);

  final _picker = ImagePicker();
  File? _imageFile;
  String text='';
  static const String userIDPrefKey = 'userId_pref';
  String savedUid = "";
  String hintDoors="Select doors";
  bool isInitilized = false;
  String hintBrand="Select brand";
  String hinttradeMark="Select tadeMark";
  String hintSize="Select vehicle size";
  String hintBodyType="Select body Type ";
  late BodyType _bodyType = BodyType(code: '', description: '');
  late VehicleSize _vehicleSize = VehicleSize(code: '', description: '');
  late Doors _doors = Doors(code: '', description: '');
  late Brands _brands = Brands(carBrandId: '', carBrandDescription: '');
  late CarTradeMark _carTradeMark =
  CarTradeMark(carTrademarkId: '', carTrademarkDescription: '');
late PolicyType _policyType =PolicyType(code: '', description: '');

  late InsuranceCompany _insuranceCompany =
  InsuranceCompany(supplierId: '',supplierName: '');






  // int? _cameraOcr = FlutterMobileVision.CAMERA_BACK;
  bool _autoFocusOcr = true;
  bool _torchOcr = false;
  bool _multipleOcr = false;
  bool _waitTapOcr = false;
  bool _showTextOcr = true;
  Size? _previewOcr;
  // List<OcrText> _textsOcr = [];











  double height = 15;
  final yearController = TextEditingController();
  final policyNumController = TextEditingController();
  final plateController = TextEditingController();
  final chasisController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SharedPreferences? _prefs;
  String parsedText= '';
  static const String tokenPrefKey = 'token_pref';
  String token ="";
  @override
  void initState() {
    // FlutterMobileVision.start().then((previewSizes) => setState(() {
    //   // if (previewSizes[_cameraBarcode] == null) {
    //   //   return;
    //   // }
    //  // _previewBarcode = previewSizes[_cameraBarcode]!.first;
    //   _previewOcr = previewSizes[_cameraOcr]!.first;
    // //  _previewFace = previewSizes[_cameraFace]!.first;
    // }));
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
      _loadUserId();
      futureBrand = ConstantsApi().get_brand(token);
      futureBodyType = ConstantsApi().get_body_types(token);
      futureDoors = ConstantsApi().get_doors(token);
      futureVSize = ConstantsApi().get_vehicle_size(token);
      futureInsuranceCompanies = ConstantsApi().getCarInsuranceCompanies(token);
      futurePolicyType=ConstantsApi().getPolicyType(token);
    yearController
      ..text = widget.modelYear.toString() ==
          "null" ||
          widget.modelYear
              .toString()
              .isEmpty
          ? ''
          : widget.modelYear.toString();
    policyNumController
      ..text = widget.policyNumber.toString() ==
          "null" ||
          widget.policyNumber
              .toString()
              .isEmpty
          ? ''
          : widget.policyNumber.toString();
    plateController
      ..text = widget.plateNumber.toString() ==
          "null" ||
          widget.pasNumber
              .toString()
              .isEmpty
          ? ''
          : widget.plateNumber.toString();
    chasisController
      ..text = widget.chasisNumber.toString()==
          "null" ||
          widget.chasisNumber.toString().isEmpty
          ? ''
          : widget.chasisNumber.toString();
    if (widget.brandId!.isNotEmpty || widget.brandId != "null") {
      getBrandObject();
      futureTrademark =
          ConstantsApi().getCarTradeMarkList(widget.brandId.toString(),token);

      if (widget.carTrademarkId!.isNotEmpty ||
          widget.carTrademarkId != "null") {
        getTradeMarkObject();
      }
    }
    if (widget.bodyType!.isNotEmpty ||
        widget.bodyType != "null") {
      getBodyObject();
    }

      if (widget.insurerCode!.isNotEmpty ||
          widget.insurerCode != "null") {
        getCarSupplier();
      }


    if (widget.vehicleSize!.isNotEmpty ||
        widget.vehicleSize != "null") {
      getVehSizeObject();
    }
    if (widget.doors!.isNotEmpty ||
        widget.doors != "null") {
      getDoorsObject();
    }
      if (widget.policyType!.isNotEmpty ||
          widget.policyType != "null") {
        getPolicyType();
      }

    }
    );
    super.initState();
  }

  getBrandObject() async {
    List<Brands> brand = await futureBrand as List<Brands>;
    for (var i in brand) {
      if (widget.brandId == i.carBrandId) {
        setState(() {
          _brands = i;
          log("/////zzzzzzz///");
        });
        break;
      }
    }
  }

  Future<Null> _read() async {
    // List<OcrText> texts = [];
    // Size _scanpreviewOcr = _previewOcr ?? FlutterMobileVision.PREVIEW;
    try {
      // texts = await FlutterMobileVision.read(
      //   flash: _torchOcr,
      //   autoFocus: _autoFocusOcr,
      //   multiple: _multipleOcr,
      //   waitTap: true,
      //   //OPTIONAL: close camera after tap, even if there are no detection.
      //   //Camera would usually stay on, until there is a valid detection
      //   forceCloseCameraOnTap: true,
      //   //OPTIONAL: path to save image to. leave empty if you do not want to save the image
      //   imagePath: '',
      //   showText: _showTextOcr,
      //   // preview: _previewOcr ?? FlutterMobileVision.PREVIEW,
      //   scanArea: Size(_scanpreviewOcr.width - 20, _scanpreviewOcr.height - 20),
      //   // camera: _cameraOcr ?? FlutterMobileVision.CAMERA_BACK,
      //   fps: 2.0,
      //
      // );

    } on Exception {
      // texts.add(OcrText('Failed to recognize text.'));
    }
// log(texts.toString());
    log("vvvvvvvvvvvv");
    if (!mounted) return;
    setState(() {
      // _textsOcr = texts;
      // chasisController.text = _textsOcr.first.value;
    }  );

    // setState(() { _textsOcr = texts;
    // chasisController.text=_textsOcr.first.value;
    // }
    // );

  }

  getDoorsObject() async {
    List<Doors> doors = await futureDoors as List<Doors>;
    for (var i in doors) {
      if (widget.doors == i.code) {
        setState(() {
          _doors = i;
          log("/////zzzzzzz///");
        });
        break;
      }
    }
  }

  getBodyObject() async {
    List<BodyType> bodyList = await futureBodyType as List<BodyType>;
    for (var i in bodyList) {
      if (widget.bodyType == i.code) {
        setState(() {
          _bodyType = i;
          log("/////zzzzzzz///");
        });
        break;
      }
    }


  }

  getCarSupplier() async {
    List<InsuranceCompany> clist = await futureInsuranceCompanies as List<InsuranceCompany>;
    for (var i in clist) {
      if (widget.insuranceCompanyId == i.supplierId) {
        setState(() {
          _insuranceCompany = i;
          log("/////zzzzzzz///");
        });
        break;
      }
    }
  }

  getVehSizeObject() async {
    List<VehicleSize> sizeList = await futureVSize as List<VehicleSize>;
    for (var i in sizeList) {
      if (widget.vehicleSize == i.code) {
        setState(() {
          _vehicleSize = i;
          log("/////zzzzzzz///");
        });
        break;
      }
    }
  }


  getTradeMarkObject() async {
    List<CarTradeMark> cartrades = await futureTrademark as List<CarTradeMark>;
    for (var i in cartrades) {
      if (widget.carTrademarkId == i.carTrademarkId) {
        setState(() {
          _carTradeMark = i;
          log("/////wwww///");
        });
        break;
      }
    }
  }
  getPolicyType() async {
    List<PolicyType> policyTypes = await futurePolicyType as List<PolicyType>;
    for (var i in policyTypes) {
      if (widget.policyType == i.code) {
        setState(() {
          _policyType = i;
          log("/////wwww///");
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //   final args = ModalRoute.of(context)!.settings.arguments as personalInfoArgs;


    return
      WillPopScope (
          onWillPop: (

              ) async {
            bool updated = await update(
                widget.carId.toString(),
                _brands.carBrandId,
                _carTradeMark.carTrademarkId,
                _vehicleSize.code,
                _bodyType.code,
                _doors.code,
                yearController.text,
                chasisController.text,
                plateController.text,
                policyNumController.text,
                savedUid,_insuranceCompany.supplierId,_policyType.code
            );

            if (updated) {
              ScaffoldMessenger.of(
                  context)
                  .showSnackBar(
                SnackBar(
                  backgroundColor:
                  Colors.blue,
                  content: Text("updated car info"),

                  //action: SnackBarAction(label: 'OK', onPressed: () {}),
                ),
              );
              return true;

            } else {
              ScaffoldMessenger.of(
                  context)
                  .showSnackBar(
                SnackBar(
                  backgroundColor:
                  Colors.red,
                  content: Text("updated failed"),

                ),
              );
              return false;
            }

          },
      child: Scaffold(
        appBar: AppBar(title: Text('Car Info')),
        backgroundColor: Colors.white,
        // appBar: AppBar(title: Text("asdsadasdas")),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Card(
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
                      margin: new EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("Vehicle Information",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          )),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          // Text("Make Name ",
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       color: Colors.grey,
                          //     )
                          // ),



                          // StatefulBuilder(builder:
                          //     (BuildContext context, StateSetter setState) {
                          //   return FutureBuilder<List<Brands>>(
                          //       future: futureBrand,
                          //       builder: (BuildContext context,
                          //           AsyncSnapshot<List<Brands>> snapshot) {
                          //         if (!snapshot.hasData)
                          //           return CircularProgressIndicator();
                          //         return DropdownButton<Brands>(
                          //           items: snapshot.data!
                          //               .map((brand) =>
                          //               DropdownMenuItem<Brands>(
                          //                 enabled: widget.vehicleNumber == "0"
                          //                     ? false
                          //                     : true,
                          //                 child: Text(
                          //                     brand.carBrandDescription),
                          //                 value: brand,
                          //               ))
                          //               .toList(),
                          //           onChanged: (Brands? value) {
                          //             log(value!.carBrandDescription);
                          //             this.setState(() {
                          //               futureTrademark = ConstantsApi()
                          //                   .getCarTradeMarkList(
                          //                   value.carBrandId);
                          //             });
                          //             setState(() => _brands = value);
                          //             _carTradeMark = CarTradeMark(
                          //                 carTrademarkId: '',
                          //                 carTrademarkDescription: '');
                          //           },
                          //           isExpanded: true,
                          //           //   value: _brands==null?Brands(carBrandId: "carBrandId", carBrandDescription: "carBrandDescription"):_brands,
                          //           value: _brands.carBrandId.isEmpty
                          //               ? null
                          //               : snapshot.data![
                          //           snapshot.data!.indexOf(_brands)],
                          //           hint: new Text(hintBrand.isEmpty?"empty brand":hintBrand ,style: TextStyle(color: hintBrand.isEmpty?Colors.red:Colors.black54),),
                          //           // hint: Text(_gender.genderDescription.isEmpty?"select gender":_gender.genderDescription
                          //           // ),
                          //         );
                          //       });
                          // }),


                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {


                            return FutureBuilder<List<Brands>>(
                                future: futureBrand,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Brands>> snapshot) {
                                  if (!snapshot.hasData)
                                    return CircularProgressIndicator();


                                return  DropdownSearch<Brands>(
                                    mode: Mode.MENU,
                                    // showSelectedItems: true,
                                    items:  snapshot.data!,
                                  itemAsString: ( var u) => u!.carBrandDescription,
                                    showSearchBox: true,
                                  onChanged: (Brands? value) {
                                    log(value!.carBrandDescription);
                                    this.setState(() {
                                      futureTrademark = ConstantsApi()
                                          .getCarTradeMarkList(
                                          value.carBrandId,token);
                                    });
                                    setState(() => _brands = value);
                                    _carTradeMark = CarTradeMark(
                                        carTrademarkId: '',
                                        carTrademarkDescription: '');
                                  },
                                  enabled:widget.vehicleNumber == "0"
                                      ? false
                                      : true ,
                                  // validator: (Brands  ? item) {
                                  //   if (_brands.carBrandDescription.isEmpty)
                                  //     return "Required field";
                                  //   else
                                  //     return null;
                                  // },
                                  validator: (value) {
                                    if (_brands.carBrandDescription.isEmpty) {
                                      return 'Enter First Name';
                                    }
                                    return null;
                                  },
                                  label: "Make Name",
                                  hint: hintBrand,
                                  selectedItem: _brands,
                                  );


                                });
                          }),



                        ],
                      ),
                    ),






                    SizedBox(
                      height: height,
                    ),
                    // Container(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Text("Model Name ",
                    //           style: TextStyle(
                    //             fontSize: 14,
                    //             color: Colors.grey,
                    //           )),
                    //     ],
                    //   ),
                    // ),
                    // StatefulBuilder(
                    //     builder: (BuildContext context, StateSetter setState) {
                    //       return FutureBuilder<List<CarTradeMark>>(
                    //           future: futureTrademark,
                    //
                    //           builder: (BuildContext context,
                    //               AsyncSnapshot<List<CarTradeMark>> snapshot) {
                    //             if (!snapshot.hasData)
                    //               return CircularProgressIndicator();
                    //             return DropdownButton<CarTradeMark>(
                    //
                    //               items: snapshot.data!
                    //                   .map((mark) =>
                    //                   DropdownMenuItem<CarTradeMark>(
                    //                     enabled: widget.vehicleNumber == "0"
                    //                         ? false
                    //                         : true,
                    //
                    //                     child:
                    //                     Text(mark.carTrademarkDescription),
                    //                     value: mark,
                    //                   ))
                    //                   .toList(),
                    //               onChanged: (CarTradeMark? value) {
                    //                 setState(() => _carTradeMark = value!);
                    //               },
                    //               isExpanded: true,
                    //               //   value: _brands==null?Brands(carBrandId: "carBrandId", carBrandDescription: "carBrandDescription"):_brands,
                    //               value: _carTradeMark.carTrademarkId.isEmpty ||
                    //                   _carTradeMark == null
                    //                   ? null
                    //                   : snapshot.data![
                    //               snapshot.data!.indexOf(_carTradeMark)],
                    //               hint: new Text(hinttradeMark.isEmpty?"empty tardeMark":hinttradeMark ,style: TextStyle(color: hinttradeMark.isEmpty?Colors.red:Colors.black54),),
                    //             );
                    //           });
                    //     }
                    //     ),
                    StatefulBuilder(builder:
                        (BuildContext context, StateSetter setState) {


                      return FutureBuilder<List<CarTradeMark>>(
                          future: futureTrademark,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<CarTradeMark>> snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();


                            return  DropdownSearch<CarTradeMark>(
                              mode: Mode.MENU,
                              // showSelectedItems: true,
                              items:  snapshot.data!,
                              itemAsString: ( var u) => u!.carTrademarkDescription,
                              showSearchBox: true,
                              onChanged: (CarTradeMark? value) {
                                                setState(() => _carTradeMark = value!);

                              },
                              enabled:widget.vehicleNumber == "0"
                                  ? false
                                  : true ,
                              validator: (CarTradeMark  ? item) {
                                if (item==null)
                                  return "Required field";
                                else
                                  return null;
                              },
                              label: "Model Name",
                              selectedItem: _carTradeMark,
                            );

                          });
                    }),
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
                      keyboardType: TextInputType.number,
                      controller: yearController,


                      decoration: InputDecoration(
                        labelText: 'Year',
                        isDense: true,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        hintText: "Enter Year",
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
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
                      controller: chasisController,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      onTap: () {
    if (Theme.of(context).platform == TargetPlatform.android) {
//_startScan();
    _read();
    }
                      //  _pickImageFromCamera();
                      },
                      decoration: InputDecoration(
                        labelText: 'Chasis Number',
                        isDense: true,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        hintText: "Enter Chasis Number",
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
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
                      controller: plateController,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Plate Number',
                        isDense: true,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        hintText: "Enter Plate Number",
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
                        ),
                        filled: true,
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text("Vehicle Size ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )),

                          StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return FutureBuilder<List<VehicleSize>>(
                                    future: futureVSize,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                            List<VehicleSize>> snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      return DropdownButton<VehicleSize>(
                                        items: snapshot.data!
                                            .map((size) =>
                                            DropdownMenuItem<VehicleSize>(
                                              child:
                                              Text(size.description),
                                              value: size,
                                            ))
                                            .toList(),
                                        onChanged: (VehicleSize? value) {
                                          setState(() => _vehicleSize = value!);
                                        },
                                        isExpanded: true,
                                        value: _vehicleSize.code.isEmpty
                                            ? null
                                            : snapshot.data![
                                        snapshot.data!.indexOf(_vehicleSize)],
                                          hint: new Text(hintSize.isEmpty?"empty vehicle size":hintSize ,style: TextStyle(color: hintSize.isEmpty?Colors.red:Colors.black54),),
                                        );
                                    });
                              }),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text("Body Type ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )),

                          StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return FutureBuilder<List<BodyType>>(
                                    future: futureBodyType,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<
                                            List<BodyType>> snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      return DropdownButton<BodyType>(
                                        items: snapshot.data!
                                            .map((type) =>
                                            DropdownMenuItem<BodyType>(
                                              child:
                                              Text(type.description),
                                              value: type,
                                            ))
                                            .toList(),
                                        onChanged: (BodyType? value) {
                                          setState(() => _bodyType = value!);
                                        },
                                        isExpanded: true,
                                        //   value: _brands==null?Brands(carBrandId: "carBrandId", carBrandDescription: "carBrandDescription"):_brands,
                                        value: _bodyType.code.isEmpty
                                            ? null
                                            : snapshot.data![
                                        snapshot.data!.indexOf(_bodyType)],
                                        hint: new Text(hintBodyType.isEmpty?"empty body type":hintBodyType ,style: TextStyle(color: hintBodyType.isEmpty?Colors.red:Colors.black54),),
                                      );
                                    });
                              }),


                        ],
                      ),
                    ),
                    SizedBox(
                      height: height,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text("Doors ",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              )),

                          StatefulBuilder(
                              builder: (BuildContext context,
                                  StateSetter setState) {
                                return FutureBuilder<List<Doors>>(
                                    future: futureDoors,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<Doors>> snapshot) {
                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      return DropdownButton<Doors>(

                                        items: snapshot.data!
                                            .map((door) =>
                                            DropdownMenuItem<Doors>(
                                              child:
                                              Text(door.description),
                                              value: door,
                                            ))
                                            .toList(),
                                        onChanged: (Doors? value) {
                                          setState(() => _doors = value!);
                                        },
                                        isExpanded: true,
                                        value: _doors.code.isEmpty
                                            ? null
                                            : snapshot.data![
                                        snapshot.data!.indexOf(_doors)],
                                        hint: new Text(hintDoors.isEmpty?"empty doors":hintDoors ,style: TextStyle(color: hintDoors.isEmpty?Colors.red:Colors.black54),),

                                      );
                                    });
                              }),


                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.symmetric(vertical: 10.0),
                      child: Text("Insurance Information",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                          )),
                    ),
                    widget.vehicleNumber == "0"
                        ?  TextField(
                      enabled: widget.vehicleNumber == "0"
                          ? false
                          : true,
                      controller: policyNumController,
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Policy Number',
                        isDense: true,
                        labelStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        hintText: "Policy Number",
                        hintStyle: TextStyle(
                          color: Colors.blue,
                        ),
                        fillColor: Colors.grey[300],
                        border: InputBorder.none,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.blue),
                        ),
                        filled: true,
                      ),
                    ):Column(
                      children: [







                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {


                          return FutureBuilder<List<InsuranceCompany>>(
                              future: futureInsuranceCompanies,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<InsuranceCompany>> snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();


                                return  DropdownSearch<InsuranceCompany>(
                                  mode: Mode.BOTTOM_SHEET,
                                  // showSelectedItems: true,
                                  items:  snapshot.data!,
                                  itemAsString: ( var u) => u!.supplierName,
                                  showSearchBox: true,
                                  onChanged: (InsuranceCompany? value) {
                                    setState(() => _insuranceCompany = value!);

                                  },


                                  label: "Insurance company",
                                  selectedItem: _insuranceCompany,
                                );

                              });
                        }),
                        SizedBox(
                          height: height,
                        ),






                        Container(
                          child: Column(
                            children: <Widget>[
                              Text("Policy Types ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  )),

                              StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return FutureBuilder<List<PolicyType>>(
                                        future: futurePolicyType,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<PolicyType>> snapshot) {
                                          if (!snapshot.hasData)
                                            return CircularProgressIndicator();
                                          return DropdownButton<PolicyType>(

                                            items: snapshot.data!
                                                .map((door) =>
                                                DropdownMenuItem<PolicyType>(
                                                  child:
                                                  Text(door.description),
                                                  value: door,
                                                ))
                                                .toList(),
                                            onChanged: (PolicyType? value) {
                                              setState(() => _policyType = value!);
                                            },
                                            isExpanded: true,
                                            value: _policyType.code.isEmpty
                                                ? null
                                                : snapshot.data![
                                            snapshot.data!.indexOf(_policyType)],
                                            hint: new Text("Policy Type"),

                                          );
                                        });
                                  }),


                            ],
                          ),
                        ),








                      ],
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

  bool updated = await update(
      widget.carId.toString(),
      _brands.carBrandId,
      _carTradeMark.carTrademarkId,
      _vehicleSize.code,
      _bodyType.code,
      _doors.code,
      yearController.text,
      chasisController.text,
      plateController.text,
      policyNumController.text,
      savedUid,_insuranceCompany.supplierId,_policyType.code);

  if (updated) {
    ScaffoldMessenger.of(
        context)
        .showSnackBar(
      SnackBar(
        backgroundColor:
        Colors.blue,
        content: Text("updated car info"),

        //action: SnackBarAction(label: 'OK', onPressed: () {}),
      ),
    );

    Navigator.pop(context);
  } else {
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
                                        fontWeight: FontWeight.bold)),
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
    if(_doors.code.isEmpty){
    this.setState(() {
    hintDoors="";
    });

    }

    if(_carTradeMark.carTrademarkId.isEmpty){
      this.setState(() {
        hinttradeMark="";
      });

    }
    if(_brands.carBrandId.isEmpty){
      this.setState(() {
        hintBrand="";
      });

    }
    if(_bodyType.code.isEmpty){
      this.setState(() {
        hintBodyType="";
      });

    }
    if(_vehicleSize.code.isEmpty){
      this.setState(() {
        hintSize="";
      });

    }
    if(_doors.code.isNotEmpty&&_carTradeMark.carTrademarkId.isNotEmpty&&_brands.carBrandId.isNotEmpty&&_vehicleSize.code.isNotEmpty&&_bodyType.code.isNotEmpty) {
  bool updated = await update(widget.carId.toString(),_brands.carBrandId,_carTradeMark.carTrademarkId,_vehicleSize.code,_bodyType.code,_doors.code,yearController.text,chasisController.text,plateController.text,policyNumController.text,savedUid,_insuranceCompany.supplierId,_policyType.code);

    if(updated) {
      ScaffoldMessenger.of(
          context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
          Colors.blue,
          content: Text("updated car info"),

        ),
      );

    Navigator.push(context,
    MaterialPageRoute(builder: (context) => RequiredDocuments(),settings: RouteSettings(
      arguments:BigArgs (carId: widget.carId.toString(),bodyType: _bodyType.code,doors: _doors.code,fName: widget.fName.toString(),fatherName:widget.fatherName.toString(),lName: widget.lastName.toString(),brand: _brands.carBrandDescription,tradeMark: _carTradeMark.carTrademarkDescription,companyCode: widget.companyCode.toString(),notification: widget.notification.toString(),notificationId: widget.notificationId.toString())),),);

    }else{
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
    }

                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => this._imageFile = File(pickedFile.path));
      log(pickedFile.path);
     // _onRecogniseTap(pickedFile.path);
    }
  }
 //  Future<void> _onRecogniseTap( String path) async {
 //    //args support android / Web , i don't have a mac
 //    log("read from image");
 //
 //
 //    try {
 //      text = (await SimpleOcrPlugin.performOCR(path))!;
 // parsedText =jsonDecode(text)["text"];
 //    } catch(e) {
 //      print("exception on OCR operation: ${e.toString()}");
 //    }
 //    log(text);
 //  setState(() {
 //      chasisController.text = parsedText;
 //    });
 //  }

  void _loadUserId() {
    setState(() {
      this.savedUid = this._prefs?.getString(userIDPrefKey) ?? "";
      this.token=this._prefs?.getString(tokenPrefKey)??"";

    });
  }
  void _loadUser() async {
    SharedPreferences pr = await SharedPreferences.getInstance();
    setState(() {
      savedUid = pr.getString(userIDPrefKey)! ;
      token=pr.getString(tokenPrefKey)!;
    });
  }

Future<bool> update(String carId,String carBrandId,String carTradeMarkId,String carVehicleSize,String carBodyType,
    String carDoors,String carYear,String carChasisNumber,String carPlate,String carPolicyNumber,String userId,String carSupplierId ,String policyType ) async {
  bool updated  = await updatingInformationService().updateCarInfo(  carId, carBrandId, carTradeMarkId, carVehicleSize, carBodyType, carDoors, carYear, carChasisNumber, carPlate, carPolicyNumber, userId,token,carSupplierId,policyType);
  return updated;
}
}

