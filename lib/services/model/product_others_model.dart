class ProductOthersModel {
  int? id;
  String? title;
  int? quantity;
  double? retail_price;
  double? old_price;

  ProductOthersModel({data}) {
    id=data['id'];
    title=data['title'];
    quantity=data['quantity'];
    retail_price=data['retail_price'];
    old_price=data['old_price'];
  }
}
