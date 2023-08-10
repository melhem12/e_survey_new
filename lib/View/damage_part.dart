import 'package:custom_check_box/custom_check_box.dart';
import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/accidentImages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Models/AppDamagesParts.dart';
import '../service/TemaServiceApi.dart';

class DamagePart extends StatefulWidget {
  const DamagePart({Key? key}) : super(key: key);

  @override
  _DamagePartState createState() => _DamagePartState();
}

class _DamagePartState extends State<DamagePart> {
bool circularProgress=false;
  bool checkRightFrontDoor = false;
  bool checkRightBackDoor = false;
  bool checkLeftFrontDoor = false;
  bool checkLeftBackDoor = false;
  bool checkTop = false;
  bool checkBumper = false;
  bool checkRearBumper = false;
  bool checkRearRightFender = false;
  bool checkFrontRightFender = false;
  bool checkFrontLeftFender = false;
  bool checkRearLeftFender = false;
  bool checkBonnet = false;
  bool checkTailGate = false;
List<AppDamagePartResponse> damageList =<AppDamagePartResponse> [];
  late Mission m ;
  @override
  void initState() {
    super.initState();

   m= Get.arguments;
    getDamagedParts();
  }
  @override
  Widget build(BuildContext context) {


    var height = MediaQuery.of(context).size.height;
    return WillPopScope (
        onWillPop: (

    )  async {
          await update();
          return true;
    },
    child :Scaffold(
        appBar: AppBar(title: const Text("الأجزاء المتضررة"),),

        body:  SafeArea(

        child: Padding(


        padding: const EdgeInsets.all(5.0),

    child:

             Column(

    children: [


      Container(
        height: height/2,
        width: double.infinity,
        margin: const EdgeInsets.only(top: 5),



          child: circularProgress==true?const Center(child: CircularProgressIndicator()): SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(

              children: [
                Image.asset('assets/car-line.jpg',height: double.infinity,width: double.infinity,),
                Column(

                  children: [
                    Expanded(


                      flex: 1,
                      child:  Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomCheckBox(
                          value: checkFrontRightFender,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkFrontRightFender = val;
                              print("value of checkFrontRightFender"+checkFrontRightFender.toString());
                            });
                          },
                        ),

                        CustomCheckBox(
                          value: checkRightFrontDoor,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkRightFrontDoor = val;
                            });
                          },
                        ),
                        CustomCheckBox(
                          value: checkRightBackDoor,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkRightBackDoor = val;

                              //shouldCheck = val;
                            });
                          },
                        ),
                        CustomCheckBox(
                          value: checkRearRightFender,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkRearRightFender=val;
                            });
                          },
                        ),
                      ],

                    ),),

                  Expanded(flex: 1,
                  child:

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      Expanded(
                        flex:1,
                        child: CustomCheckBox(
                          value: checkBumper,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkBumper = val;
                            });
                          },
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: CustomCheckBox(
                          value:checkBonnet ,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkBonnet = val;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomCheckBox(
                          value: checkTop,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkTop = val;
                            });
                          },
                        ),
                      ),

                      Expanded(
                        flex: 1,
                        child: CustomCheckBox(
                          value: checkTailGate,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkTailGate = val;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomCheckBox(
                          value: checkRearBumper,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkRearBumper = val;
                            });
                          },
                        ),
                      ),

                    ],

                  ),
                  ),

                    Expanded(
                      flex: 1,
                      child:

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomCheckBox(
                          value: checkFrontLeftFender,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkFrontLeftFender = val;
                            });
                          },
                        ),
                        CustomCheckBox(
                          value: checkLeftFrontDoor,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkLeftFrontDoor = val;
                            });
                          },
                        ),
                        CustomCheckBox(
                          value: checkLeftBackDoor,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkLeftBackDoor = val;
                            });
                          },
                        ),
                        CustomCheckBox(
                          value: checkRearLeftFender,
                          shouldShowBorder: true,
                          borderColor: Colors.red,
                          checkedFillColor: Colors.red,
                          borderRadius: 8,
                          borderWidth: 1,
                          checkBoxSize: 22,
                          onChanged: (val) {
                            //do your stuff here
                            setState(() {
                              checkRearLeftFender = val;
                            });
                          },
                        ),
                      ],

                    ),
                    ),


                  ],
                )


              ],
            ),
          ),
        ),



      SizedBox(height: height/6),

SizedBox(
  height: height/15,
  child:
      Row(
          mainAxisSize: MainAxisSize.max,

          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  height: height,
                  child: ElevatedButton(
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Icon(Icons.arrow_back_ios)),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "العودة", textAlign:TextAlign.center,style: TextStyle(color: Colors.white
                            ,fontSize: 12,),
                          ),
                        ),

                      ],
                    ),
                    onPressed: () async {
                      await update();
                      Get.back();
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
              width: 20,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                flex: 1,

                child: Container(
                  height: height,
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Icon(Icons.photo)),
                        Expanded(
                          flex: 5,
                          child: Text(
                            "الصور", textAlign:TextAlign.center,style: TextStyle(color: Colors.white
                            ,fontSize: 12,),
                          ),
                        ),

                      ],
                    ),


                    onPressed: () async {
                      update();
                    Get.to(const AccidentImages(),arguments: m);

                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight:
                            FontWeight.bold)),
                  ),
                ))
          ]
      ),),

    ],
    )
    )
    )

    )
    );
  }
Future<void> update() async {

    List<AppDamagePartResponse> parts=[];
    parts.clear();


    if(checkFrontRightFender){
print("checkFrontRightFender  checked");
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"742");
      parts.add(appDamagePartResponse);
    }
    if(checkRightFrontDoor){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"1482");
      parts.add(appDamagePartResponse);
    }
    if(checkRightBackDoor){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"1782");
      parts.add(appDamagePartResponse);
    }

    if(checkRearRightFender){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"3482");
      parts.add(appDamagePartResponse);
    }



    if(checkBumper){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"281");
      parts.add(appDamagePartResponse);
    }


    if(checkBonnet){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"471");
      parts.add(appDamagePartResponse);
    }
    if(checkTop){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"0");
      parts.add(appDamagePartResponse);
    }

    if(checkTailGate){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"2933");
      parts.add(appDamagePartResponse);
    }
    if(checkRearBumper){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"2581");
      parts.add(appDamagePartResponse);
    }


    if(checkFrontLeftFender){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"741");
      parts.add(appDamagePartResponse);
    }
    if(checkLeftFrontDoor){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"1481");
      parts.add(appDamagePartResponse);
    }
    if(checkLeftBackDoor){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"1781");
      parts.add(appDamagePartResponse);
    }
    if(checkRearLeftFender){
      AppDamagePartResponse appDamagePartResponse =AppDamagePartResponse(damagedPartsId: '', carsAppAccidentId: m.accidentId, damagesPartsPartId:"3481");
      parts.add(appDamagePartResponse);
    }
    setState(() {
      circularProgress = true;
    });
 await TemaServiceApi().updateCarsAppDamageParts(parts,GetStorage().read('token'),m.accidentId);
    setState(() {
      circularProgress = false;
    });

  }

  Future<void> getDamagedParts() async {
    circularProgress=true;

  damageList= await  TemaServiceApi().getCarsAppDamageParts(GetStorage().read('token'),m.accidentId);
    checkRightFrontDoor=damageList.where((element) => element.damagesPartsPartId=="1482").isNotEmpty;
    checkFrontRightFender=damageList.where((element) => element.damagesPartsPartId=="742").isNotEmpty;
    checkRightBackDoor=damageList.where((element) => element.damagesPartsPartId=="1782").isNotEmpty;
    checkRearRightFender=damageList.where((element) => element.damagesPartsPartId=="3482").isNotEmpty;


    checkBumper=damageList.where((element) => element.damagesPartsPartId=="281").isNotEmpty;
    checkBonnet=damageList.where((element) => element.damagesPartsPartId=="471").isNotEmpty;
    checkTop=damageList.where((element) => element.damagesPartsPartId=="0").isNotEmpty;
    checkTailGate=damageList.where((element) => element.damagesPartsPartId=="2933").isNotEmpty;
    checkRearBumper=damageList.where((element) => element.damagesPartsPartId=="2581").isNotEmpty;



    checkFrontLeftFender=damageList.where((element) => element.damagesPartsPartId=="741").isNotEmpty;
    checkLeftFrontDoor=damageList.where((element) => element.damagesPartsPartId=="1481").isNotEmpty;
    checkLeftBackDoor=damageList.where((element) => element.damagesPartsPartId=="1781").isNotEmpty;
    checkRearLeftFender=damageList.where((element) => element.damagesPartsPartId=="3481").isNotEmpty;


  setState(() {
      circularProgress = false;
    });


  }

       }
