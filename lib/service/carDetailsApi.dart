import 'package:e_survey/Models/CarDetailsModel.dart';
import 'package:e_survey/utility/app_url.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class carDetailsApi{
  Future<CarDetailsModel> getCarDetails(String carId,String companyCode,String token) async{
    var response= await http.get(Uri.parse(AppUrl.getCarDetails+"carId="+carId+"&companyCode="+companyCode),
        headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
        }
        );
    final carDetailsData = json.decode(response.body)['claimListCarDetailBean'];
    CarDetailsModel carDetailsModel =   CarDetailsModel();


      carDetailsModel.carId=carDetailsData[0]["carId"].toString();
    carDetailsModel.plateNumber=carDetailsData[0]["plateNumber"].toString();
    carDetailsModel.lossDate=carDetailsData[0]["lossDate"].toString();
    carDetailsModel.policyNumber=carDetailsData[0]["policyNumber"].toString();
    carDetailsModel.licenseNumber=carDetailsData[0]["licenseNumber"].toString();
    carDetailsModel.chasisNumber=carDetailsData[0]["chasisNumber"].toString();
    carDetailsModel.carTrademarkId=carDetailsData[0]["carTrademarkId"].toString();
    carDetailsModel.carOwnerFamilyName=carDetailsData[0]["carOwnerFamilyName"].toString();
    carDetailsModel.carOwnerFirstName=carDetailsData[0]["carOwnerFirstName"].toString();
    carDetailsModel.carOwnerMaidenName=carDetailsData[0]["carOwnerMaidenName"].toString();
    carDetailsModel.accidentLocation=carDetailsData[0]["accidentLocation"];
    carDetailsModel.claimNumber=carDetailsData[0]["claimNumber"].toString();
    carDetailsModel.claimStatus=carDetailsData[0]["claimStatus"].toString();
    carDetailsModel.vehicleNumber=carDetailsData[0]["vehicleNumber"].toString();
    carDetailsModel.vehicleSize=carDetailsData[0]["vehicleSize"].toString();
    carDetailsModel.vehicleOwnerName=carDetailsData[0]["vehicleOwnerName"].toString();
    carDetailsModel.shapeID=carDetailsData[0]["shapeID"].toString();
    carDetailsModel.bodyType=carDetailsData[0]["bodyType"].toString();
    carDetailsModel.brandId=carDetailsData[0]["brandId"].toString();
    carDetailsModel.brandTradeMark=carDetailsData[0]["brandTradeMark"].toString();
    carDetailsModel.insurerCode=carDetailsData[0]["insurerCode"].toString();
    carDetailsModel.doors=carDetailsData[0]["doors"].toString();
    carDetailsModel.licenseDate=carDetailsData[0]["licenseDate"].toString();
    carDetailsModel.licenseExpiryDate=carDetailsData[0]["licenseExpiryDate"].toString();
    carDetailsModel.modelYear=carDetailsData[0]["modelYear"].toString();
    carDetailsModel.notificationId=carDetailsData[0]["notificationId"].toString();
    carDetailsModel.pasNumber=carDetailsData[0]["pasNumber"].toString();
    carDetailsModel.phoneNumber=carDetailsData[0]["phoneNumber"].toString();
    carDetailsModel.reportedDate=carDetailsData[0]["reportedDate"].toString();
    carDetailsModel.carOwnerFatherName=carDetailsData[0]["carOwnerFatherName"].toString();

    carDetailsModel.insuranceCompanyId=carDetailsData[0]["insuranceCompanyId"].toString();
    carDetailsModel.policyType=carDetailsData[0]["policyType"].toString();

    return carDetailsModel;
  }



}