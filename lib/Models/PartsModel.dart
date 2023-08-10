class PartsModel {
late String surveyDamagedDescription;

late String surveyDamagedPartsId;

late int surveyDamagedPartCode;

late String surveyDamagedReview;

late int surveyDamagedSeverity;

late String surveyDamagedSurveyId;

late String surveyDamagedPartDescription;

late String surveyDamagedPartArabicDescription;

late String metParentPart;

PartsModel({
  required    this.surveyDamagedDescription,
  required   this.surveyDamagedPartsId,
  required    this.surveyDamagedPartCode,
  required     this.surveyDamagedReview,
  required     this.surveyDamagedSeverity,
  required     this.surveyDamagedSurveyId,
  required     this.surveyDamagedPartDescription,
  required     this.surveyDamagedPartArabicDescription,
  required   this.metParentPart});
}