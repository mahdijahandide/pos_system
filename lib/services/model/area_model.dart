class AreaModel {
  int? id;
  String?name;
  double?deliveryFee;

  AreaModel({data}) {
    id=data['id'];
    name=data['name'];
    deliveryFee=data['delivery_fee'];
  }
}
