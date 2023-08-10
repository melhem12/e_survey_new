import 'package:e_survey/utility/widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
class Bridge extends StatefulWidget {
  const Bridge({Key? key}) : super(key: key);
  @override
  _BridgeState createState() => _BridgeState();
}


class _BridgeState extends State<Bridge> {
  final box = GetStorage();

  @override
  void initState() {
     FirebaseMessaging.instance
        .subscribeToTopic(box.read("userId").toString());

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:
      Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),

          child:Column(

            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(

                flex: 1, child:   Text("Select App",
                  // style: GoogleFonts.pacifico(
                  //     fontWeight: FontWeight.bold, fontSize: 40, color: Colors.blue)

              ),
              ),
              Expanded(
                flex:6,
                child: GridView.count(
                  crossAxisCount: 2,

                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[

                    // Text(""),
                    makeDashboardItem("Esurvey", Icons.car_repair,"/home",context),
                    makeDashboardItem("Tema", Icons.drive_eta,"/missions",context),
                    //makeDashboardItem("", Icons.task,"/",context),

                  ],
                ),
              ),

            ]

            ,)


      ),



    );
  }
}
