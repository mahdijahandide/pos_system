import 'package:get/get.dart';

class CustomerModel {
  int? id;
  String?name,mobile,email;


  CustomerModel({data}) {
    id=data['id']??'';
    name=data['name']??'';
    mobile=data['mobile']??'';
    email=data['email']??'';
  }
}
