import 'package:pos_system/services/model/city_model.dart';

class ProvinceModel {
  int? id;
  String?name;
  List<CityModel>provinceList=[];

  ProvinceModel({data}) {
    id=data['id'];
    name=data['name'];
    var areas=data['state'];
    areas.forEach((element){
      provinceList.add(CityModel(data: element));
    });
  }
}
