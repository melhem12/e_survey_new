import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/MissionsModel.dart';
class AccidentInfo extends StatefulWidget {
  const AccidentInfo({Key? key}) : super(key: key);

  @override
  _AccidentInfoState createState() => _AccidentInfoState();
}

class _AccidentInfoState extends State<AccidentInfo> {
  late  Mission m  ;
  @override
  void initState() {
    m =  Get.arguments as Mission ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
        appBar: AppBar(title: const Text("ملاحظات"),),

    body:
    SingleChildScrollView( child :Center(
    child:
    Card(
    elevation: 5,
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
    ),
    child: Padding(
    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
    child: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
Row(children:   [
const   Text("insurer : ",  style: TextStyle(fontWeight: FontWeight.bold),),
  Text(m.accidentInsurerName),

],),
      Row(children:   [
        const   Text("Insured Name : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentCallerName),

      ],),
      Row(children:   [
        const   Text("Insured Number : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentContactNumber),

      ],),
      Row(children:   [
        const   Text("Policy Number : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentPolicyNumber),

      ],),
      Row(children:   [
        const   Text("Product Code : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentPolicyType),

      ],),
      Row(children:   [
        const   Text("Car : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentPolicyType),

      ],),
      Row(children:   [
        const   Text("Chassis Number : ",  style: TextStyle(fontWeight: FontWeight.bold),),
        Text(m.accidentChassis),

      ],),
      const SizedBox(height: 40,),
      Row(children:   const [
        Text("Policy Details : ",  style: TextStyle(fontWeight: FontWeight.bold),),

      ],),
      Row(children:   [
        Text("Inception: "+m.accidentPolicyInceptDate +" Expiry: "+m.accidentPolicyExpiryDate+" ...."),

      ],),
      Row(children:   [
        Text(m.accidentDetails),

      ],),
    ]
    ),

    ),
    )
    )
    )

    );
  }
}
