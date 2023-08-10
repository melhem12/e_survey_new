class CarsSurveyDamagedPartsBean{
 late  int surveyDamagedCheckCompany;
late  String surveyDamagedDescription;
late  int  surveyDamagedPartCode;
 late String surveyDamagedReview;
 late int  surveyDamagedSeverity;
 late String metParentPart;
late  String userId;

 CarsSurveyDamagedPartsBean(
      this.surveyDamagedCheckCompany,
      this.surveyDamagedDescription,
      this.surveyDamagedPartCode,
      this.surveyDamagedReview,
      this.surveyDamagedSeverity,
      this.metParentPart,
      this.userId);

 Map<String, dynamic> toJson(){
  return {
   "surveyDamagedCheckCompany": this.surveyDamagedCheckCompany,
   "surveyDamagedDescription": this.surveyDamagedDescription,
   "surveyDamagedPartCode": this.surveyDamagedPartCode,
   "surveyDamagedReview": this.surveyDamagedReview,
   "surveyDamagedSeverity": this.surveyDamagedSeverity,
   "metParentPart": this.metParentPart,
   "userId": this.userId,
  };
 }
}