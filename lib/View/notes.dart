import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data'; // Import this
import 'package:path_provider/path_provider.dart';

import 'package:e_survey/Models/AppNotes.dart';
import 'package:e_survey/Models/MissionsModel.dart';
import 'package:e_survey/View/expert_missions.dart';
import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
class Notesview extends StatefulWidget {
  const Notesview({Key? key}) : super(key: key);

  @override
  State<Notesview> createState() => _NotesviewState();
}

class _NotesviewState extends State<Notesview> {
  final _controller = TextEditingController();
  var   audioFile;
  final recorder = FlutterSoundRecorder();
  bool isRecorderReady =false;
  final audioPlayer= ap.AudioPlayer();

  bool isPlaying= false;
  bool progress=false;
  AppNotes appNotes = AppNotes(notesId: '', carsAppAccidentId: '', notesRemark: '', voiceNote: '');
  Duration duration = Duration.zero;
  Duration position =Duration.zero;

  Duration d =Duration.zero;
  late Mission m;
  @override
  void dispose(){
    recorder.closeRecorder();
    audioPlayer.dispose();
    super.dispose();
  }
  @override
  void initState() {
    m =  Get.arguments as Mission ;
    progress =true;
    getNotes();
    initRecorder();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState((){
        isPlaying=state== ap.PlayerState.stopped ;
      });


    });


    audioPlayer.onDurationChanged.listen((newDuration) {
      setState((){
        duration=newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState((){
        position=newPosition;
      });
    });
    super.initState();
  }
  Future initRecorder() async{
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Show an error message to the user
      print('Microphone permission not granted');
      return;
    }
    await recorder.openRecorder();
    isRecorderReady=true;
    recorder.setSubscriptionDuration(
      const Duration(milliseconds:500),
    );
  }
  Future record() async{
    if(!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }
  Future stop() async{
    if(!isRecorderReady) return;
    final path =await recorder.stopRecorder();
    audioFile= File(path!);
    print('Record audio : $audioFile');
  }

  @override
  Widget build(BuildContext context) {
    return

      WillPopScope (
          onWillPop: (

              )  async {
            progress=true;
            setState(() {

            });
            if (audioFile!=null){
              await TemaServiceApi().uploadNotes(audioFile!.path, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

            }else{
              await TemaServiceApi().uploadNotes(null, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

            }
            progress=false;
            setState(() {

            });
            return true;
          },
          child :

          Scaffold(
              appBar: AppBar(title: const Text("ملاحظات"),),

              body:
              progress?Center(child: CircularProgressIndicator(),):

              SingleChildScrollView( child :
              Center(
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
                        _buildMultilineTextField(),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StreamBuilder<RecordingDisposition>(
                                stream: recorder.onProgress,
                                builder: (context, snapshot) {
                                  final duration = snapshot.hasData?snapshot.data!.duration:Duration.zero;
                                  String twoDigits(int n)=>n.toString().padLeft(2,'0');
                                  final  twoDigitsMinutes=twoDigits(duration.inMinutes.remainder(60));
                                  final  twoDigitsSeconds=twoDigits(duration.inSeconds.remainder(60));

                                  return  Text('$twoDigitsMinutes:$twoDigitsSeconds' ,style: const TextStyle(
                                    fontSize: 20,

                                    fontWeight: FontWeight.bold,
                                  ));
                                }),
                            //      SizedBox( width: 20,),

                            ElevatedButton(
                              onPressed: () async {
                                if(recorder.isRecording)   {
                                  await stop();

                                }
                                else{
                                  await record();
                                }
                                setState((){});
                              },
                              child:Icon(recorder.isRecording?Icons.stop:Icons.mic) ,
                            ),
                            IconButton(onPressed: (){
                              duration=Duration.zero;
                              position =Duration.zero;
                              recorder.stopRecorder();
//recorder.deleteRecord(fileName: audioFile);

                              audioFile=null ;
                              audioPlayer.stop();

                              setState((){});

                            }, icon:  Icon(Icons.delete,color: Colors.blue,))   ,
                          ],
                        ),
                        Slider(min: 0 ,max: duration.inSeconds.toDouble(),value: position.inSeconds.toDouble(), onChanged: (value) async{

                          final position= Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                          //optional :play audio if was paused
                          await audioPlayer.resume();
                        },)
                        ,Padding(padding: const EdgeInsets.symmetric(horizontal: 16)
                          ,child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(formatTime(position)),
                              Text(formatTime(duration-position)),

                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          child: IconButton(
                            icon:Icon(
                              isPlaying?Icons.pause:Icons.play_arrow,

                            ) , iconSize: 30,
                            onPressed: () async {
                              if(isPlaying){
                                await audioPlayer.pause();

                              }else{
                                // await audioPlayer.resume();
                                try {
                                  if (audioFile != null) {
                                    print(audioFile);
                                    await audioPlayer.play(ap.UrlSource(audioFile.path));
                                  }
                                } catch (e) {
                                  print('Error playing audio: $e');
                                }
                              }

                            },
                          ),
                        )
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
                                        "عودة",style: TextStyle(color: Colors.white ,fontSize: 17),
                                      ),
                                      onPressed: () async {

                                        // TemaServiceApi tema = new TemaServiceApi();
                                        //await tema.updateAccidentStatus("rejected", m.accidentId, box.read("token").toString());

                                        progress=true;
                                        setState((){
                                        });
                                        if (audioFile!=null){
                                          await TemaServiceApi().uploadNotes(audioFile!.path, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

                                        }else{
                                          await TemaServiceApi().uploadNotes(null, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

                                        }
                                        progress=false;
                                        setState((){
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
                                      child: Text(
                                        "حفظ",style: TextStyle(color: Colors.white
                                          ,fontSize: 17),
                                      ),
                                      onPressed: () async {
                                        progress=true;
                                        setState((){
                                        });
                                        if (audioFile!=null){
                                          await TemaServiceApi().uploadNotes(audioFile!.path, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

                                        }else{
                                          await TemaServiceApi().uploadNotes(null, _controller.text.toString(), GetStorage().read('token'), m.accidentId);

                                        }

                                        progress=false;
                                        setState((){
                                        });
//   tema.updateAccidentStatus("accepted", m.accidentId, box.read("token"));
                                        // Get.to(ArrivationVerification(),arguments: m);
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
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[

                              Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: ElevatedButton(
                                      child: Text(
                                        "حفظ وإنهاء",style: TextStyle(color: Colors.white
                                          ,fontSize: 17),
                                      ),
                                      onPressed: () async {
                                        progress = true;
                                        setState((){

                                        });

                                        if (audioFile!=null){
                                          await TemaServiceApi().uploadNotes(audioFile!.path, _controller.text.toString(), GetStorage().read('token'), m.accidentId);
                                          await TemaServiceApi().updateAccidentStatus("completed", m.accidentId, GetStorage().read('token'));

                                        }
                                        else{
                                          await TemaServiceApi().uploadNotes(null, _controller.text.toString(), GetStorage().read('token'), m.accidentId);
                                          await TemaServiceApi().updateAccidentStatus("completed", m.accidentId, GetStorage().read('token'));

                                        }
                                        progress = false;
                                        setState((){

                                        });
                                        Get.offAll(()=>ExpertMissions());
                                        //   tema.updateAccidentStatus("accepted", m.accidentId, box.read("token"));
                                        // Get.to(ArrivationVerification(),arguments: m);
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
              )));
  }
  String formatTime(Duration duration){
    String twoDigits(int n)=>n.toString().padLeft(2,'0');
    final hours = twoDigits(duration.inHours);
    final minutes=twoDigits(duration.inMinutes.remainder(60));
    final seconds=twoDigits(duration.inSeconds.remainder(60));
    return[if(duration.inHours>0)hours,
      minutes,
      seconds,
    ].join(':');
  }
  Future setAudio() async{
    //repeat audio when completed
    // audioPlayer.setReleaseMode(ap.ReleaseMode.LOOP);

    if(audioFile!=null){
      audioPlayer.setSourceDeviceFile(audioFile.path);
    }
  }
  Widget _buildMultilineTextField() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:
        TextField(
          textAlign: TextAlign.right,

          controller: this._controller,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          autofocus: true,
          decoration: InputDecoration(
            counterText: '${_countWords(text: this._controller.text)} words',
            labelText: 'ملاحظة خطية',
            alignLabelWithHint: true,
            hintText: 'أكتب ملاحظتك هنا',
            border: const OutlineInputBorder(),
          ),
          onChanged: (text) => setState(() {}),
        ));
  }
  int _countWords({required String text}) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return 0;
    } else {
      return trimmedText.split(RegExp("\\s+")).length;
    }
  }

  void getNotes() async {
    appNotes=  await TemaServiceApi().getNotes(GetStorage().read('token'), m.accidentId);
    progress =false;
    _controller.text=appNotes.notesRemark;
//audioPlayer.playBytes(base64Decode(appNotes.voiceNote));
//File f= File.fromRawPath(base64Decode(appNotes.voiceNote));
    log(appNotes.voiceNote);
    log("pppppppppppppppppppppppp///////////");
//print(f.path);
    log("pppppppppppppppppppppppp///////////");
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String audioFilePath = '${documentDirectory.path}/audio.mp3';

    audioFile = File(audioFilePath) ;

    if(appNotes.voiceNote!=""||appNotes.voiceNote.isNotEmpty){
      log("kkkkkkkkkkkkkkkkknnnnnnnnnnnn");
      // File f=  await File('audio').writeAsBytes(base64Decode(appNotes.voiceNote)) as File;

      audioFile.writeAsBytes(base64Decode(appNotes.voiceNote));       // Not Working Bug!!
      //  file.writeAsBytesCompat(base64Decode(appNotes.voiceNote));
      log(audioFile.path);
      log("nfffffff");
    }
    // if(audioFile!=null){
    //   print(audioFile);
    //   await   audioPlayer.play(audioFile!.path, isLocal: true);
    //
    // }
    progress=false;

    setState((){});
  }


// ...










// ...

  // void getNotes() async {
  //   appNotes = await TemaServiceApi().getNotes(GetStorage().read('token'), m.accidentId);
  //   progress = false;
  //   _controller.text = appNotes.notesRemark;
  //   print("//////////////////////nnnnnn");
  //
  //   if (appNotes.voiceNote != null && appNotes.voiceNote.isNotEmpty) {
  //     try {
  //       print("//////////////////////uuuuuuuuuuuu");
  //
  //       Uint8List audioBytes = appNotes.voiceNote as Uint8List;
  //
  //       // Get the document directory to save the audio file
  //       Directory documentDirectory = await getApplicationDocumentsDirectory();
  //       String audioFilePath = '${documentDirectory.path}/audio.mp3';
  //
  //       // Write the audio bytes to the file
  //       File audioFile2 = File(audioFilePath);
  //       await audioFile2.writeAsBytes(audioBytes);
  //       // Save the audio file path for later use
  //       print("sucess");
  //
  //       audioFile = audioFile2; // Define savedAudioFilePath at the class level
  //
  //     } catch (e) {
  //       print("Error saving audio: $e");
  //     }
  //   }

  //   progress = false;
  //   setState(() {});
  // }



}
