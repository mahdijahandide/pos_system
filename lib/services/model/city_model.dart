import 'package:pos_system/services/model/area_model.dart';

class CityModel {
  int? id;
  String?name;
  List<AreaModel>areaList=[];

  CityModel({data}) {
    id=data['id'];
    name=data['name'];
    var areas=data['area'];
    areas.forEach((element){
      areaList.add(AreaModel(data: element));
    });
  }
}
