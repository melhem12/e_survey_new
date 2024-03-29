import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:e_survey/View/expert_missions.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:e_survey/service/TemaServiceApi.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/AppNotes.dart';
import '../Models/MissionsModel.dart';
import '../controllers/RefreshController.dart';
import 'expert_missions2.dart';

class NotessView extends StatefulWidget {
  const NotessView({Key? key}) : super(key: key);

  @override
  State<NotessView> createState() => _NotessViewState();
}

typedef _Fn = void Function();

/* This does not work. on Android we must have the Manifest.permission.CAPTURE_AUDIO_OUTPUT permission.
 * But this permission is _is reserved for use by system components and is not available to third-party applications._
 * Pleaser look to [this](https://developer.android.com/reference/android/media/MediaRecorder.AudioSource#VOICE_UPLINK)
 *
 * I think that the problem is because it is illegal to record a communication in many countries.
 * Probably this stands also on iOS.
 * Actually I am unable to record DOWNLINK on my Xiaomi Chinese phone.
 *
 */
//const theSource = AudioSource.voiceUpLink;
//const theSource = AudioSource.voiceDownlink;

const theSource = AudioSource.microphone;

class _NotessViewState extends State<NotessView> {
  AppNotes appNotes = AppNotes(
      notesId: '', carsAppAccidentId: '', notesRemark: '', voiceNote: '');

  final _controller = TextEditingController();
  bool progress = false;
  late Mission m;
  final box = FlutterSecureStorage();

  Codec _codec = Codec.aacMP4;
  String _mPath = '';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;

  @override
  void initState() {
    m = Get.arguments as Mission;
    // _mPath=_mPath+m.accidentId+".mp4";

    progress = true;
    getNotes();

    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });

    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });
    super.initState();
  }

  Future<void> saveAndFinish() async {
    final RefreshController refreshController = Get.find<RefreshController>();
    refreshController.needRefresh.value = true;

    progress = true;
    setState(() {}
    );

    Directory documentDirectory = await getApplicationCacheDirectory();
    String audioFilePath = '${documentDirectory.path}/${_mPath}';
    final token = await box.read(key: "token");

    await TemaServiceApi().uploadNotes(
        _mPath, _controller.text.toString(), token.toString(), m.accidentId,context);
    await TemaServiceApi().updateAccidentStatus(
        context, "completed", m.accidentId, token.toString());

    progress = false;
    setState(() {});
    Platform.isIOS
        ? Get.offAll(() => ExpertMissions2())
        : Get.offAll(() => ExpertMissions());
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;

    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    // Initialize _mPath with the appropriate directory path
    final appDocumentsDirectory =
        await path_provider.getApplicationDocumentsDirectory();
    _mPath = '${appDocumentsDirectory.path}/tau_file.mp4';
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInited = true;
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));

    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {
        //var url = value;
        _mplaybackReady = true;
      });
    });
  }

  void play() {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!.isStopped);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath,
            //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
            whenFinished: () {
              setState(() {});
            })
        .then((value) {
      setState(() {});
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {});
    });
  }

  int _countWords({required String text}) {
    final trimmedText = text.trim();
    if (trimmedText.isEmpty) {
      return 0;
    } else {
      return trimmedText.split(RegExp("\\s+")).length;
    }
  }

// ----------------------------- UI --------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  void getNotes() async {
    final token = await box.read(key: "token");
    appNotes = await TemaServiceApi().getNotes(token.toString(), m.accidentId);
    progress = false;
    _controller.text = appNotes.notesRemark;
//audioPlayer.playBytes(base64Decode(appNotes.voiceNote));
//File f= File.fromRawPath(base64Decode(appNotes.voiceNote));
    log(appNotes.voiceNote);
    log("pppppppppppppppppppppppp///////////");
//print(f.path);
    log("pppppppppppppppppppppppp///////////");
    // Directory documentDirectory = await getApplicationCacheDirectory();
    // String audioFilePath = '${documentDirectory.path}/${_mPath}';

    if (appNotes.voiceNote != "" || appNotes.voiceNote.isNotEmpty) {
      final appDocumentsDirectory =
          await path_provider.getApplicationDocumentsDirectory();
      _mPath = '${appDocumentsDirectory.path}/tau_file.mp4';

      log("kkkkkkkkkkkkkkkkknnnnnnnnnnnn");


      File f = await File(_mPath).writeAsBytes(base64Decode(appNotes.voiceNote))
          as File;
      _mRecorderIsInited = true;
      _mplaybackReady = true;
      //  file.writeAsBytesCompat(base64Decode(appNotes.voiceNote));
      log("nfffffff");
    }

    progress = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return progress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Center(
                  child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildMultilineTextField(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: getRecorderFn(),
                                      child: Icon(
                                        _mRecorder!.isRecording
                                            ? Icons.stop
                                            : Icons.mic,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: getPlaybackFn(),
                                      child: Icon(
                                        _mPlayer!.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                              "عودة",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () async {
                                              // TemaServiceApi tema = new TemaServiceApi();
                                              //await tema.updateAccidentStatus("rejected", m.accidentId, box.read("token").toString());

                                              progress = true;
                                              setState(() {});

                                              Directory documentDirectory =
                                                  await getApplicationCacheDirectory();
                                              String audioFilePath =
                                                  '${documentDirectory.path}/${_mPath}';

                                              final token =
                                                  await box.read(key: "token");
                                              await TemaServiceApi()
                                                  .uploadNotes(
                                                      _mPath,
                                                      _controller.text
                                                          .toString(),
                                                      token.toString(),
                                                      m.accidentId,context);

                                              progress = false;
                                              setState(() {});
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
                                              "حفظ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () async {
                                              progress = true;
                                              setState(() {});

                                              Directory documentDirectory =
                                                  await getApplicationCacheDirectory();
                                              String audioFilePath =
                                                  '${documentDirectory.path}/${_mPath}';
                                              final token =
                                                  await box.read(key: "token");

                                              await TemaServiceApi()
                                                  .uploadNotes(
                                                      _mPath,
                                                      _controller.text
                                                          .toString(),
                                                      token.toString(),
                                                      m.accidentId,context);

                                              progress = false;
                                              setState(() {});

                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                textStyle: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ))
                                  ]),
                              Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: ElevatedButton(
                                            child: Text(
                                              "حفظ وإنهاء",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17),
                                            ),
                                            onPressed: () async {
                                              saveAndFinish();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                textStyle: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ))
                                  ]),
                            ],
                          )))));
    }

    return WillPopScope(
        onWillPop: () async {
          progress = true;
          setState(() {});

          Directory documentDirectory = await getApplicationCacheDirectory();
          String audioFilePath = '${documentDirectory.path}/${_mPath}';
          final token = await box.read(key: "token");

          await TemaServiceApi().uploadNotes(_mPath,
              _controller.text.toString(), token.toString(), m.accidentId,context);

          progress = false;
          setState(() {});
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("ملاحظات"),
          ),
          body: makeBody(),
        ));
  }

  Widget _buildMultilineTextField() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
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
}
