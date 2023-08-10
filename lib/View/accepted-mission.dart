import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Models/MissionsModel.dart';
import 'arrivation.dart';
class AcceptedMission extends StatefulWidget {
  const AcceptedMission({Key? key}) : super(key: key);

  @override
  State<AcceptedMission> createState() => _AcceptedMissionState();
}

class _AcceptedMissionState extends State<AcceptedMission> {
  final box = GetStorage();

  late  Mission m  ;
  @override
  void initState() {
    m =  Get.arguments as Mission ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(title: Text("الحوادث المتوفرة")),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: <Widget>
              [
                Card(

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                                          "فتح",style: TextStyle(color: Colors.white
                                            ,fontSize: 17),
                                        ),
                                        onPressed: () async {

                                          Get.to(ArrivationVerification(),arguments: m);
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

                )

              ]
          )

      )
      ,
    );
  }
}
