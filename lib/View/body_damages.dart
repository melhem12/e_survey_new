import 'dart:developer';

import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/notes.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:group_button/group_button.dart';

import '../Models/AppBodly.dart';
class BodyDamageView extends StatefulWidget {
  const BodyDamageView({Key? key}) : super(key: key);

  @override
  _BodyDamageViewState createState() => _BodyDamageViewState();
}


class _BodyDamageViewState extends State<BodyDamageView> {

  AppBodly appBodly=AppBodly(bodlyId: '', carsAppAccidentId: '0', bodlyInsCountLightInj: 0, bodlyInsCountSeverInj: 0, bodlyInsCountDeath: 0, bodlyTpCountLightInj: 0, bodlyTpCountSeverInj: 0, bodlyTpCountDeath: 0);

  List<String> choices=  ["0","1","2","3","4","5",">5"];
  final box  = GetStorage();
  late Mission m ;
  bool progress=false;

  @override
  void initState() {
    m=Get.arguments;
    progress= true;

    getBodlyDamage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
         return

           WillPopScope (
        onWillPop: (

    )  async {
          progress=true;
          setState(() {

          });
      await TemaServiceApi().updateCarsAppBodly(m.accidentId, box.read('token'), appBodly);
      progress=false;
          setState(() {

          });
      return true;
    },
    child :

           Scaffold(

        appBar: AppBar(title: const Text("الأضرار الجسدية"),),
        body:  SafeArea(
        child: SingleChildScrollView(
        child: Padding(
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
    child:   Padding(

    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisSize: MainAxisSize.max,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(width: double.infinity,),
      Text("المؤمن عليه",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end),

      Container( padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight,child:
      Text("عدد الإصابات الخفيفة",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),
    GroupButton(
  //  controller: GroupButtonController(selectedIndex: listappDamages.indexWhere((element) => element.code == damageCode)),
      controller: GroupButtonController(selectedIndex:appBodly.bodlyInsCountLightInj),

      options: GroupButtonOptions(
      selectedShadow: const [],
      selectedTextStyle: TextStyle(
        fontSize: 20,
        color: Colors.pink[900],
      ),selectedColor: Colors.pink[100],
    unselectedShadow: const [],
    unselectedColor: Colors.white,
    unselectedTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.blue,
    ),
    selectedBorderColor: Colors.pink[900],
    unselectedBorderColor: Colors.blue,
    borderRadius: BorderRadius.circular(100),
    spacing: 10,
    runSpacing: 10,

    groupingType: GroupingType.wrap,
    direction: Axis.horizontal,
    buttonHeight: 40,
    buttonWidth: 40,
    mainGroupAlignment: MainGroupAlignment.start,
    crossGroupAlignment: CrossGroupAlignment.start,
    groupRunAlignment: GroupRunAlignment.start,
    textAlign: TextAlign.center,
    textPadding: EdgeInsets.zero,
    alignment: Alignment.center,
    elevation: 0,
  ),
    isRadio: true,

    onSelected: (index, isSelected) { print('$index button is selected ');
    appBodly.bodlyInsCountLightInj=index;

    },

    buttons: choices,

    ),
      Container(padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight ,child: Text("عدد الإصابات الخطيرة",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),
      GroupButton(
        controller: GroupButtonController(selectedIndex:appBodly.bodlyInsCountSeverInj),

        options: GroupButtonOptions(
          selectedShadow: const [],
          selectedTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.pink[900],
          ),selectedColor: Colors.pink[100],
          unselectedShadow: const [],
          unselectedColor: Colors.white,
          unselectedTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
          selectedBorderColor: Colors.pink[900],
          unselectedBorderColor: Colors.blue,
          borderRadius: BorderRadius.circular(100),
          spacing: 10,
          runSpacing: 10,
          groupingType: GroupingType.wrap,
          direction: Axis.horizontal,
          buttonHeight: 40,
          buttonWidth: 40,
          mainGroupAlignment: MainGroupAlignment.start,
          crossGroupAlignment: CrossGroupAlignment.start,
          groupRunAlignment: GroupRunAlignment.start,
          textAlign: TextAlign.center,
          textPadding: EdgeInsets.zero,
          alignment: Alignment.center,
          elevation: 0,
        ),
        isRadio: true,

        onSelected: (index, isSelected) { print('$index button is selected ');
appBodly.bodlyInsCountSeverInj=index;
        },

        buttons: choices,

      ),
      Container(padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight , child: Text("عدد الضحايا",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),

      GroupButton(
         controller: GroupButtonController(selectedIndex:appBodly.bodlyInsCountDeath),
        options: GroupButtonOptions(
          selectedShadow: const [],
          selectedTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.pink[900],
          ),selectedColor: Colors.pink[100],
          unselectedShadow: const [],
          unselectedColor: Colors.white,
          unselectedTextStyle: TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
          selectedBorderColor: Colors.pink[900],
          unselectedBorderColor: Colors.blue,
          borderRadius: BorderRadius.circular(100),
          spacing: 10,
          runSpacing: 10,
          groupingType: GroupingType.wrap,
          direction: Axis.horizontal,
          buttonHeight: 40,
          buttonWidth: 40,
          mainGroupAlignment: MainGroupAlignment.start,
          crossGroupAlignment: CrossGroupAlignment.start,
          groupRunAlignment: GroupRunAlignment.start,
          textAlign: TextAlign.center,
          textPadding: EdgeInsets.zero,
          alignment: Alignment.center,
          elevation: 0,
        ),
        isRadio: true,

        onSelected: (index, isSelected) { print('$index button is selected ');
        appBodly.bodlyInsCountDeath=index;

        },

        buttons: choices,

      ),
    ],
    ),
    ),
    ),
      Card(

        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),

        ),
        child:   Padding(

          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity,),
              Text("الطرف الثالث",style: TextStyle(color: Colors.blue),textAlign: TextAlign.center),
          Container(padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight ,
              child: Text("عدد الإصابات الخفيفة",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),

          GroupButton(
            controller: GroupButtonController(selectedIndex:appBodly.bodlyTpCountLightInj),
                options: GroupButtonOptions(
                  selectedShadow: const [],
                  selectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.pink[900],
                  ),selectedColor: Colors.pink[100],
                  unselectedShadow: const [],
                  unselectedColor: Colors.white,
                  unselectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                  selectedBorderColor: Colors.pink[900],
                  unselectedBorderColor: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                  spacing: 10,
                  runSpacing: 10,
                  groupingType: GroupingType.wrap,
                  direction: Axis.horizontal,
                  buttonHeight: 40,
                  buttonWidth: 40,
                  mainGroupAlignment: MainGroupAlignment.start,
                  crossGroupAlignment: CrossGroupAlignment.start,
                  groupRunAlignment: GroupRunAlignment.start,
                  textAlign: TextAlign.center,
                  textPadding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  elevation: 0,
                ),
                isRadio: true,

                onSelected: (index, isSelected) { print('$index button is selected ');
                appBodly.bodlyTpCountLightInj=index;

                },

                buttons: choices,

              ),
              Container(
                  padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight ,
                  child: Text("عدد الإصابات الخطيرة",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),

              GroupButton(
                controller: GroupButtonController(selectedIndex:appBodly.bodlyTpCountSeverInj),

                //  controller: GroupButtonController(selectedIndex: listappDamages.indexWhere((element) => element.code == damageCode)),
                options: GroupButtonOptions(
                  selectedShadow: const [],
                  selectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.pink[900],
                  ),selectedColor: Colors.pink[100],
                  unselectedShadow: const [],
                  unselectedColor: Colors.white,
                  unselectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                  selectedBorderColor: Colors.pink[900],
                  unselectedBorderColor: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                  spacing: 10,
                  runSpacing: 10,
                  groupingType: GroupingType.wrap,
                  direction: Axis.horizontal,
                  buttonHeight: 40,
                  buttonWidth: 40,
                  mainGroupAlignment: MainGroupAlignment.start,
                  crossGroupAlignment: CrossGroupAlignment.start,
                  groupRunAlignment: GroupRunAlignment.start,
                  textAlign: TextAlign.center,
                  textPadding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  elevation: 0,
                ),
                isRadio: true,

                onSelected: (index, isSelected) { print('$index button is selected ');
                appBodly.bodlyTpCountSeverInj=index;

                },

                buttons: choices,

              ),
              Container(padding: EdgeInsets.only(right: 25,bottom: 10, top: 5), alignment: Alignment.topRight , child: Text("عدد الضحايا",style: TextStyle(color: Colors.blue),textAlign: TextAlign.end)),

              GroupButton(
                controller: GroupButtonController(selectedIndex:appBodly.bodlyTpCountDeath),

                options: GroupButtonOptions(
                  selectedShadow: const [],
                  selectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.pink[900],
                  ),selectedColor: Colors.pink[100],
                  unselectedShadow: const [],
                  unselectedColor: Colors.white,
                  unselectedTextStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                  selectedBorderColor: Colors.pink[900],
                  unselectedBorderColor: Colors.blue,
                  borderRadius: BorderRadius.circular(100),
                  spacing: 10,
                  runSpacing: 10,
                  groupingType: GroupingType.wrap,
                  direction: Axis.horizontal,
                  buttonHeight: 40,
                  buttonWidth: 40,
                  mainGroupAlignment: MainGroupAlignment.start,
                  crossGroupAlignment: CrossGroupAlignment.start,
                  groupRunAlignment: GroupRunAlignment.start,
                  textAlign: TextAlign.center,
                  textPadding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  elevation: 0,
                ),
                isRadio: true,

                onSelected: (index, isSelected) { print('$index button is selected ');
                appBodly.bodlyTpCountDeath=index;

                },

                buttons: choices,

              ),
            ],
          ),
        ),
      ),
      Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Container(
                  child: ElevatedButton(
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Icon(Icons.arrow_back)),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "العودة", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                            ,fontSize: 12,),
                          ),
                        ),

                      ],
                    ),
                    onPressed: () async {
                      progress=true;
                      setState(() {

                      });
                      await TemaServiceApi().updateCarsAppBodly(m.accidentId, box.read('token'), appBodly);
                      progress=false;
                      setState(() {

                      });
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Icon(Icons.wysiwyg)),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "ملاحظات", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                            ,fontSize: 12,),
                          ),
                        ),

                      ],
                    ),


                    onPressed: () async {
                      log("yyyyyyyyyyyyyyyyy"+appBodly.bodlyInsCountDeath.toString());
                      log("*************");
                      log(appBodly.bodlyTpCountSeverInj.toString());
                      log(appBodly.bodlyTpCountDeath.toString());
                      log(appBodly.bodlyTpCountLightInj.toString());

                      log("*************");

                      await TemaServiceApi().updateCarsAppBodly(m.accidentId, box.read('token'), appBodly);

                      Get.to( Notesview(),arguments: m);

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
    ]
    ),


    ),
    ),)
           )
           );
  }

  void getBodlyDamage()  async{
 appBodly= await  TemaServiceApi().getCarsAppBodly(box.read('token'), m.accidentId);
 progress=false;
setState(() {

});
  }



}
