import 'package:e_survey/View/tema_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Models/MissionsModel.dart';
import '../service/TemaServiceApi.dart';

class ArrivationVerification extends StatefulWidget {
  const ArrivationVerification({Key? key}) : super(key: key);

  @override
  _ArrivationVerificationState createState() => _ArrivationVerificationState();
}

class _ArrivationVerificationState extends State<ArrivationVerification> {
  late  Mission m  ;
  final box = GetStorage();
  bool progress =false;
  @override
  void initState() {
    m =  Get.arguments as Mission ;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text("Arrive"),
        ),
        body:
        progress?Center(child: CircularProgressIndicator(),):
        SingleChildScrollView(
          child:
        Padding(
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("عليك ادخال الرمز", style: TextStyle(color: Colors.blue ,fontSize: 18),),
                  Text("المرسل الى الرقم "+m.accidentCustomerPhone , style: TextStyle(color: Colors.blue ,fontSize: 18),),
SizedBox(height: 60,),
                  OtpTextField(
                    numberOfFields: 4,
                    borderColor: Color(0xFF512DA8),
                    //set to true to show as box or false to show as dash
                    showFieldAsBox: true,
                    //runs when a code is typed in
                    onCodeChanged: (String code) {
                      //handle validation or checks here
                    },
                    //runs when every textfield is filled
                    onSubmit: (String verificationCode) async {
progress=true ;
setState(()  {



});
                      bool success= await TemaServiceApi().updateArrivedStatus(verificationCode, m.accidentId, box.read('token'));
progress=false ;
setState(()  {



});
                      if (success) {
                        showDialog(
                            context: context,
                            builder: (context){
                              return const AlertDialog(
                                title: Text("Verification Success"),
                                content: Text("Success"),
                              );
                            }
                        );
                        Get.offAll( TemaMenu(),arguments: m);
                      }
                      else{
                        showDialog(
                            context: context,
                            builder: (context){
                              return const AlertDialog(
                                title: Text("Verification Failed"),
                                content: Text("Please  Enter A valid pin"),
                              );
                            }
                        );
                      }


                    }, // end onSubmit
                  ),
                  const SizedBox(height: 60,),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              child: ElevatedButton(
                                child: Text(
                                  "رقم السائق",style: TextStyle(color: Colors.white ,fontSize: 17),
                                ),
                                onPressed: () async {

                                  callNumber(m.accidentCustomerPhone);
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
                                  "مركز الاتصال",style: TextStyle(color: Colors.white
                                    ,fontSize: 17),
                                ),
                                onPressed: () async {
                                  callNumber("70832070");

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
        )

    );
  }
  callNumber(String number) async{

    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}


  // void nav(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => VerificationScreen1(),
  //     ),
  //   );
  // }
