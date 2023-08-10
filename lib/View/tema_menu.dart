import 'package:e_survey/View/AccidentInfo.dart';
import 'package:e_survey/View/accidentConditions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Models/MissionsModel.dart';
class TemaMenu extends StatefulWidget {
  const TemaMenu({Key? key}) : super(key: key);

  @override
  _TemaMenuState createState() => _TemaMenuState();
}

class _TemaMenuState extends State<TemaMenu> {
  late  Mission m  ;
  final box = GetStorage();
  @override
  void initState() {
    m =  Get.arguments as Mission ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return    Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text("Arrive"),
        ),
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    child: Text(m.accidentCustomerName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueGrey,
                        )),
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 5.0),

                    child: Text(m.accidentId,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        )),
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 5.0),

                    child: Text(m.accidentCustomerPhone,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        )),
                  ),
                  Container(
                    margin: new EdgeInsets.symmetric(vertical: 5.0),

                    child: Text(m.accidentMake,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                        )),
                  ),

                  SizedBox(
                    height: 40,
                    width: double.infinity,
                  ),
                  Row(

                    mainAxisSize: MainAxisSize.max,
                    children:<Widget> [
                      Container(                              margin: new EdgeInsets.symmetric(vertical: 5.0),

                          child: Icon(Icons.where_to_vote,color: Colors.blue,)),
                      Text(
                        m.accidentlocation ,style: TextStyle(color: Colors.blue,  fontSize: 15,),)
                    ],),

                  const SizedBox(height: 60,),

                  Row(

                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              height: Get.height/18,
                              child: ElevatedButton(

                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(Icons.add_chart)),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "تقرير الحادث", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                                        ,fontSize: 12,),
                                      ),
                                    ),

                                  ],
                                ),
                                onPressed: () async {
                                 Get.to(AccidentCondition(),arguments: m);
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
                              height: Get.height/18,

                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Icon(Icons.view_list_rounded)),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        "عرض تفاصيل البوليصة", textAlign:TextAlign.end,style: TextStyle(color: Colors.white
                                          ,fontSize: 12,),
                                      ),
                                    ),

                                  ],
                                ),


                                onPressed: () async {
                                  Get.to(const AccidentInfo(),arguments: m);

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
        )


    );
  }
}
