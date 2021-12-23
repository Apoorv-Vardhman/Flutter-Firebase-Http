import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mvvm_angela/common/connection/connection_manager.dart';
import 'package:mvvm_angela/common/utils/codes.dart';
import 'package:mvvm_angela/data/api/api_manager.dart';
import 'package:mvvm_angela/data/model/app_model.dart';

abstract class PatientRepo
{
  Future<AppModel> getData();
}

class PatientRepoImp extends PatientRepo
{
  @override
  Future<AppModel> getData() async{
    if(ConnectivityManager.getInstance().hasConnection)
      {
        var response = await ApiManager.getRequest("397de112-7326-4214-b3ea-16f5d7074e01");
        if (response.apiResponseCode == StatusCodes.API_SUCCESS)
        {
          return AppModel.fromJson(json.decode(response.apiResponse.toString()));
        }
        else
        {
          throw Exception('Failed to load album');
        }
      }else{
       var jsonText = await rootBundle.loadString('assets/patient.json');
       final data = json.decode(jsonText) as Map<String, dynamic>;
      return AppModel.fromJson(data);
    }
  }

}