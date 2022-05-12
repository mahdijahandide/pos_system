class ProductSizeModel {
  int? sizeId;
  String? sizeName;
  int? quantity;
  int? retailPrice;
  int? oldPrice;

  ProductSizeModel({data}) {
    sizeId=data['size_id'];
    sizeName=data['size_name'];
    quantity=data['quantity'];
    retailPrice=data['retail_price'];
    oldPrice=data['old_price'];
  }
}
