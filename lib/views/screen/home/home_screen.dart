import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_angela/common/connection/connection_manager.dart';
import 'package:mvvm_angela/common/utils/codes.dart';
import 'package:mvvm_angela/data/api/api_manager.dart';
import 'package:mvvm_angela/data/model/app_model.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AssociatedDrug> medicineData= [];

  Future<void> fetchData()
  async {
    if(ConnectivityManager.getInstance().hasConnection)
    {
      var response = await ApiManager.getRequest("397de112-7326-4214-b3ea-16f5d7074e01");
      if (response.apiResponseCode == StatusCodes.API_SUCCESS)
      {
        List<MedicationsClass> data = AppModel.fromJson(json.decode(response.apiResponse.toString())).problems[0].diabetes[0].medications[0].medicationsClasses;
        medicineData.add(AssociatedDrug(name: data[0].className[0].associatedDrug[0].name, dose: data[0].className[0].associatedDrug[0].dose, strength: data[0].className[0].associatedDrug[0].strength));
        medicineData.add(AssociatedDrug(name: data[0].className[0].associatedDrug2[0].name, dose: data[0].className[0].associatedDrug2[0].dose, strength: data[0].className[0].associatedDrug2[0].strength));

        setState(() {
          medicineData;
        });
      }
      else
      {
        throw Exception('Failed to load album');
      }
    }else{
      var jsonText = await rootBundle.loadString('assets/patient.json');
      final data = json.decode(jsonText) as Map<String, dynamic>;
      setState(() {
        medicineData = AppModel.fromJson(data).problems[0].diabetes[0].medications[0].medicationsClasses[0].className[0].associatedDrug;
      });
    }
  }


  @override
  void initState() {
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("Patient Data", style: TextStyle( fontSize: 30, color: Colors.white),),
        backgroundColor: Color(0xFF2BB64C),
        elevation: 1.0,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(12.0),
        separatorBuilder: (context,index)=> Divider(),
        itemCount: medicineData.length,
        itemBuilder: (BuildContext context,int index){
          var name = medicineData[index].name;
          var dose = medicineData[index].dose;
          var strength = medicineData[index].strength;
          var length = medicineData.length;
          return Container(
            child: Column(
              children: [
                Text('Name $name',textAlign: TextAlign.left,),
                Text('Dose $dose',textAlign: TextAlign.left,),
                Text('Strength $strength $length',textAlign: TextAlign.left,)
              ],
            ),
          );
        },
      )
    );
  }

}

