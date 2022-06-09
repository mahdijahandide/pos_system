class OrderItemsModel {
  int? id;
  int? productId;
  String ?title;
  String ?titleAr;
  String ?imageUrl;
  double? unitPrice;
  int ?quantity;
  double ?subtotal;


  OrderItemsModel({data}) {
    id=data['id']??0;
    productId=data['product_id']??0;
    title=data['title']??'';
    titleAr=data['translate']['ar']??'';
    imageUrl=data['imageUrl']??'';
    unitPrice=double.tryParse(data['unitprice'].toString())??0.0;
    quantity=data['quantity']??0;
    subtotal=double.tryParse(data['subtotal'].toString())??0.0;
  }
}
