class AppPictures {
  AppPictures({
    required this.appPicturesId,
    required this.carsAppAccidentId,
    required this.appPicturesGeneral,
    required this.appPicturesCarDamage,
    required this.appPicturesTpPolicy,
    required this.appPicturesDLvr1,
    required this.appPicturesDLvr2,
    required this.appPicturesOptional1,
    required this.appPicturesOptional2,
    required this.appPicturesOptional3,
  });

  String appPicturesId;
  String carsAppAccidentId;
  bool appPicturesGeneral; // Change the type to bool
  bool appPicturesCarDamage; // Change the type to bool
  bool appPicturesTpPolicy; // Change the type to bool
  bool appPicturesDLvr1; // Change the type to bool
  bool appPicturesDLvr2; // Change the type to bool
  bool appPicturesOptional1; // Change the type to bool
  bool appPicturesOptional2; // Change the type to bool
  bool appPicturesOptional3; // Change the type to bool

  factory AppPictures.fromJson(Map<String, dynamic> json) => AppPictures(
    appPicturesId: json["appPicturesId"] == null ? '' : json["appPicturesId"],
    carsAppAccidentId: json["carsAppAccidentId"] == null ? '' : json["carsAppAccidentId"],
    appPicturesGeneral: json["appPicturesGeneral"] == null ? false : json["appPicturesGeneral"],
    appPicturesCarDamage: json["appPicturesCarDamage"] == null ? false : json["appPicturesCarDamage"],
    appPicturesTpPolicy: json["appPicturesTPPolicy"] == null ? false : json["appPicturesTPPolicy"],
    appPicturesDLvr1: json["appPicturesDLvr1"] == null ? false : json["appPicturesDLvr1"],
    appPicturesDLvr2: json["appPicturesDLvr2"] == null ? false : json["appPicturesDLvr2"],
    appPicturesOptional1: json["appPicturesOptional1"] == null ? false : json["appPicturesOptional1"],
    appPicturesOptional2: json["appPicturesOptional2"] == null ? false : json["appPicturesOptional2"],
    appPicturesOptional3: json["appPicturesOptional3"] == null ? false : json["appPicturesOptional3"],
  );

  Map<String, dynamic> toJson() => {
    "appPicturesId": appPicturesId == null ? null : appPicturesId,
    "carsAppAccidentId": carsAppAccidentId == null ? null : carsAppAccidentId,
    "appPicturesGeneral": appPicturesGeneral,
    "appPicturesCarDamage": appPicturesCarDamage,
    "appPicturesTPPolicy": appPicturesTpPolicy,
    "appPicturesDLvr1": appPicturesDLvr1,
    "appPicturesDLvr2": appPicturesDLvr2,
    "appPicturesOptional1": appPicturesOptional1,
    "appPicturesOptional2": appPicturesOptional2,
    "appPicturesOptional3": appPicturesOptional3,
  };
}
