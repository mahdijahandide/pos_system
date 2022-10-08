class OrderModel {
  int? id;
  double? totalAmount;
  String?orderId,orderStatus,deliveryDate,name,mobile,payment_type;


  OrderModel({data}) {
    id=data['id']??0;
    totalAmount=double.tryParse(data['total_amount'].toString())??0.0;
    orderId=data['order_id']??'';
    orderStatus=data['order_status']??'';
    deliveryDate=data['delivery_date']??'';
    name=data['name']??'';
    payment_type=data['pay_mode']??'';
    mobile=data['mobile'].toString();
  }
}
