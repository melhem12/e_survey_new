import 'dart:developer';
import 'dart:ffi';

import 'package:e_survey/Models/AccidentConditionModel.dart';
import 'package:e_survey/Models/AppDamage.dart';
import 'package:e_survey/View/accidentImages.dart';
import 'package:e_survey/View/damage_part.dart';
import 'package:e_survey/ViewModels/AccidentConditionViewModel.dart';
import 'package:e_survey/ViewModels/MissionsViewModel.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter_number_picker/flutter_number_picker.dart';

import '../Models/Doubts.dart';
import '../Models/MissionsModel.dart';
import '../Models/Responsability.dart';
class AccidentCondition extends StatefulWidget {
  const AccidentCondition({Key? key}) : super(key: key);

  @override
  _AccidentConditionState createState() => _AccidentConditionState();
}
class _AccidentConditionState extends State<AccidentCondition> {
  List<AppDamage> listappDamages =[];
  List<Responsability> responsabilities=[];
  List<Doubts> doubtsList=[];
bool progress=false;
String damageCode="";
String doubtCode="";
String responsibilityCode="";
int tpNumber=0;
 AccidentConditionModel accidentConditionModel =AccidentConditionModel(accidentConditionsId: '', accidentConditionsResponsib: '', accidentConditiosTpCount: 0, carsAppAccidentId: '', accidentConditionsTpfDamage: '', accidentConditionsDoubts: '');
final box = GetStorage();
  late  Mission  m;

  @override
  void initState() {
    progress= true;
    getAppDamages();
    getDoubts();
    getResponsability();
      m =  Get.arguments as Mission ;
      print(m.accidentId);
    getAccidentCondition();



    // controller =
    //     Get.put(AccidentConditionViewModel(initialToken: GetStorage().read("token"),accidentId:m.accidentId ));
    // if(controller.accidentConditionsDoubts!=null){
    //   print("++++++++++++"+controller.accidentConditionsDoubts.value);
    //   doubtCode=controller.accidentConditionsDoubts.toString();
    // }
    super.initState();
  }


  @override
  Widget build(BuildContext context){

    return WillPopScope (
        onWillPop: (

            )  async {
progress= true;
setState(() {

});
          await  TemaServiceApi().insertAccidentConditions( m.accidentId, box.read('token'), damageCode, responsibilityCode, doubtCode, tpNumber);
progress= false;
setState(() {

});

          //   Get.to(DamagePart(),arguments: m);
          return true;
    },
    child :Scaffold(

      appBar: AppBar(title: const Text("ظروف الحادث"),),
    body:  SafeArea(
      child: progress?
      Center(

        child: CircularProgressIndicator(),)
          : SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.all(5.0),
          child:
          Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
Card(

elevation: 5,
  shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),

  ),
  child:    Padding(

        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(width: double.infinity,),

            const Text("أضرار الحادث",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end),
            GroupButton(
              controller: GroupButtonController(selectedIndex: listappDamages.indexWhere((element) => element.code == damageCode)),

                    elevation: 5,
                          isRadio: true,

                          onSelected: (index, isSelected) { print('$index button is selected '+listappDamages[index].code);
                          damageCode=listappDamages[index].code;

                           },

                          buttons: listappDamages.map((app) => app.description).toList(),

                        ),
          ],
        ),
  ),
),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        Text("المسؤلية",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end),
                        SizedBox(width: double.infinity,),

                        GroupButton(
                          controller: GroupButtonController(selectedIndex: responsabilities.indexWhere((element) => element.code == responsibilityCode)),

                          elevation: 5,
                          isRadio: true,
                          onSelected: (index, isSelected) { print('$index button is selected '+responsabilities[index].code);
                          responsibilityCode=responsabilities[index].code;
},
                          buttons: responsabilities.map((app) => app.description).toList(),

                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),

                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        SizedBox(width: double.infinity,),
                        Text("شكوك",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end),

                        GroupButton(


                    controller: GroupButtonController(selectedIndex: doubtsList.indexWhere((element) => element.code == accidentConditionModel.accidentConditionsDoubts)),
                          elevation: 10,

                          isRadio: true,
                          onSelected: (index, isSelected) {print('$index button is selected '+doubtsList[index].code);
                          doubtCode=doubtsList[index].code;
                          },

                          buttons: doubtsList.map((app) => app.description).toList(),

                        ),
                      ],
                    ),
                  ),
                ),
              Text("عدد الطرف الثالث",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end),
              CustomNumberPicker(
                  shape:        RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      side: BorderSide(width: 1.0, color: Colors.blue)),
                  initialValue: accidentConditionModel.accidentConditiosTpCount,

                  valueTextStyle:TextStyle(color: Colors.blue ,fontSize: 30),
                  maxValue: 1000000,
                  minValue: 0,
                  step: 1,
                  onValue: (value) {
                    print(value.toString());
                    tpNumber=int.parse(value.toString());
                  },
                )

// ,Obx(() {
//   return Text(controller.accidentConditionsDoubts.toString());
//
//     }),



,
              SizedBox(
                height: 20,
                width: double.infinity,
              ),

              Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Container(
                          child: ElevatedButton(
                            child: Text(
                              "العودة",style: TextStyle(color: Colors.white ,fontSize: 17),
                            ),
                            onPressed: () async {
                           //   await tema.insertAccidentConditions("rejected", m.accidentId, box.read("token").toString());
                              progress= true;
                              setState(() {

                              });
                              await  TemaServiceApi().insertAccidentConditions( m.accidentId, box.read('token'), damageCode, responsibilityCode, doubtCode, tpNumber);
                              progress= false;

                              Get.back(result: 'hello');
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
                          child: ElevatedButton(
                            child: Text(
                              "الأجزاءالمتضررة",style: TextStyle(color: Colors.white
                                ,fontSize: 17),
                            ),
                            onPressed: () async {

                            await  TemaServiceApi().insertAccidentConditions( m.accidentId, box.read('token'), damageCode, responsibilityCode, doubtCode, tpNumber);
                           //   Get.to(DamagePart(),arguments: m);
                            Get.to(DamagePart(),arguments: m);

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
              ),

              ],
            ),

        ),
      ),
    ),

    ));
  }
void   getAppDamages   () async {

    listappDamages= await  TemaServiceApi().get_AppDamage(box.read("token")) ;

    setState(() {

    });
}
  void   getDoubts  () async {

    doubtsList= await  TemaServiceApi().get_doubts(box.read("token")) ;
progress= false;
    setState(() {

    });
  }
  void   getResponsability   () async {

    responsabilities= await  TemaServiceApi().get_responsability(box.read("token")) ;

    setState(() {

    });
  }

  void   getAccidentCondition   () async {
    accidentConditionModel= await  TemaServiceApi().getAccidentCondition(box.read("token"),m.accidentId) ;
    log("nf"+accidentConditionModel.accidentConditionsId);
log("nf"+accidentConditionModel.accidentConditionsDoubts);
log("nf"+accidentConditionModel.accidentConditionsTpfDamage);

    log("tpcount"+accidentConditionModel.accidentConditiosTpCount.toString());

doubtCode=accidentConditionModel.accidentConditionsDoubts;
damageCode=accidentConditionModel.accidentConditionsTpfDamage;
responsibilityCode=accidentConditionModel.accidentConditionsResponsib;
    tpNumber=accidentConditionModel.accidentConditiosTpCount;

    log("tpcount"+tpNumber.toString());
setState(() {

});

  }



}
