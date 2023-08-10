import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
//import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:advance_image_picker/advance_image_picker.dart';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:multi_image_picker2/multi_image_picker2.dart';
class DamagedPictures extends StatefulWidget {
  const DamagedPictures({Key? key}) : super(key: key);

  @override
  _DamagedPicturesState createState() => _DamagedPicturesState();
}

class _DamagedPicturesState extends State<DamagedPictures> {
  static const String pathsListPrefKey = 'pathsList_pref';
  List<ImageObject> _imgObjs = [];
  // List<Asset> images = <Asset>[];
  // List<Asset> temps = <Asset>[];
  //List<Media> mediaList = [];
  List<String> paths =[];
  String savedPics = "";
  SharedPreferences? _prefs;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() => this._prefs = prefs);
     // _loadpics();
        paths= _prefs!.getStringList(pathsListPrefKey)!;
         for(var a in paths){
         _imgObjs.add(ImageObject(originalPath: a,modifiedPath: a))  ;
         }
         ImageObject(originalPath: "",modifiedPath: "");
      // if(savedPics.isNotEmpty) {
      //   log("////////////lllllllllllooooooooooo");
      //   Map m = jsonDecode(savedPics);
      //   m.forEach((k, v) {
      //     mediaList.add(Media());
      //     log(v);
      //   }
      //   );
      //
      // }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.blue;
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
            {required BuildContext context,
              required File file,
              required String title,
              int maxWidth = 1080,
              int maxHeight = 1920,
              int compressQuality = 90,
              ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };

    // Example about custom stickers
    configs.customStickerOnly = true;
    configs.customStickers = [
      'assets/icon/cus1.png',
      'assets/icon/cus2.png',
      'assets/icon/cus3.png',
      'assets/icon/cus4.png',
      'assets/icon/cus5.png'
    ];

    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Image Picker'),
    //   ),
    //   body: previewList(),
    //   floatingActionButton: FloatingActionButton(
    //     child: const Icon(Icons.add),
    //     onPressed: () => openImagePicker(context),
    //   ),);
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Damaged Parts"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: <Widget>[
            GridView.builder(
                shrinkWrap: true,
                itemCount: _imgObjs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, mainAxisSpacing: 2, crossAxisSpacing: 2),
                itemBuilder: (BuildContext context, int index) {
                  final image = _imgObjs[index];
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.file(File(image.modifiedPath),
                        height: 80, fit: BoxFit.cover),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Get max 5 images
          final List<ImageObject>? objects = await Navigator.of(context)
              .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return const ImagePicker(maxCount: 100);
          }));

          if ((objects?.length ?? 0) > 0) {
            setState(() {
              _imgObjs = objects!;
              for(var a in _imgObjs ){
                print("paths............"+a.originalPath);
                paths.add(a.originalPath);
              }
              _prefs!.setStringList(pathsListPrefKey, paths);
            });
          }
        },
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );

// RaisedButton(
            //   child: Text("Pick images", style: TextStyle(color: Colors.white, fontSize: 20),),
            //   color: Colors.blue,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16.0)),
            //   onPressed:
            //   pickImages,
            //
            // ),
            // MaterialButton(
            //   color: Colors.red,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(16.0)),
            //   child: const Text(
            //     'Image picker',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   onPressed: () => openImagePicker(context),
            // ),
            // Expanded(
            //   flex: 15,
            //   child:
            //   GridView.count(
            //     crossAxisCount: 3,
            //     children: List.generate(images.length, (index) {
            //       Asset asset = images[index];
            //       return AssetThumb(
            //         asset: asset,
            //         width: 300,
            //         height: 300,
            //       );
            //     }),
            //   ),
            // ),
    //         Expanded(child:  previewList(),
    //         flex: 5,),
    //         // Expanded(
    //         //     flex: 1,
    //         //     child: Container(
    //         //       width: double.infinity,
    //         //       child: ElevatedButton(
    //         //
    //         //         child: Icon(
    //         //           Icons.arrow_back,
    //         //           color: Colors.white,
    //         //           size: 20,
    //         //         ),
    //         //         onPressed: () {
    //         //
    //         //           Navigator.pop(context);
    //         //         },
    //         //         style: ElevatedButton.styleFrom(
    //         //             primary: Colors.blue,
    //         //
    //         //             textStyle: TextStyle(
    //         //                 fontSize: 30,
    //         //                 fontWeight:
    //         //                 FontWeight.bold)),
    //         //       ),
    //         //     )),
    //       ],
    //     ),
    //
    // );
  }
  // Future<void> pickImages() async {
  //   List<Asset> resultList = <Asset>[];
  //
  //   try {
  //     resultList = await MultiImagePicker.pickImages(
  //       maxImages: 500,
  //       enableCamera: true,
  //       selectedAssets: images,
  //       materialOptions: MaterialOptions(
  //         actionBarTitle: "Damage Parts",
  //       ),
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  //   log("identifier..........."+resultList.last.identifier.toString());
  //   setState(() {
  //     images = resultList;
  //
  //   });

// for(var a in images ){
//   File f = await getImageFileFromAssets(a) as File;
//   print("paths............"+f.path);
//   paths.add(f.path);
// }
//     _prefs!.setStringList(pathsListPrefKey, paths);
//     var map1 = Map.fromIterable(images, key: (e) => e.name, value: (e) => e.identifier);
//     String smap=jsonEncode(map1);
//     _prefs!.setString("stringList", smap);
  }




  // Future<File> getImageFileFromAssets(Asset asset) async {
  //   final byteData = await asset.getByteData();
  //
  //   final tempFile =
  //   File("${(await getTemporaryDirectory()).path}/${asset.name}");
  //   final file = await tempFile.writeAsBytes(
  //     byteData.buffer
  //         .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  //   );
  //
  //   return file;
  // }
  Widget previewList() {
    return SizedBox(
      // height: 96,
      // child: ListView(
      //   scrollDirection: Axis.horizontal,
      //   shrinkWrap: true,
      //   children: List.generate(
      //       mediaList.length,
      //           (index) => Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: SizedBox(
      //           height: 80,
      //           width: 80,
      //           // child: Image.memory(
      //           //   mediaList[index],
      //           //   fit: BoxFit.cover,
      //           // )
      //           child: Image.memory(mediaList[index].thumbnail!,fit: BoxFit.cover,)
      //             ,
      //         ),
      //       )),
      // ),
    );
  }




  void openImagePicker(BuildContext context) {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    // showModalBottomSheet(
    //     context: context,
    //     builder: (context) {
    //       return MediaPicker(
    //         mediaList: mediaList,
    //         onPick: (selectedList) {
    //           setState(() => mediaList = selectedList);
    //           Navigator.pop(context);
    //           log("kkkkkkkkkk");
    //           log(mediaList[0].file!.path);
    //           for(var a in mediaList ){
    //             print("paths............"+a.file!.path);
    //             paths.add(a.file!.path);
    //           }
    //           _prefs!.setStringList(pathsListPrefKey, paths);
    //
    //           // var map1 = Map.fromIterable(images, key: (e) => e.name, value: (e) => e.identifier);
    //           // String smap=jsonEncode(map1);
    //           // _prefs!.setString("stringList", smap);
    //         },
    //         onCancel: () => Navigator.pop(context),
    //         mediaCount: MediaCount.multiple,
    //         mediaType: MediaType.image,
    //         decoration: PickerDecoration(
    //           actionBarPosition: ActionBarPosition.top,
    //           blurStrength: 2,
    //           completeText: 'Next',
    //         ),
    //       );
    //     });
  }


//}
