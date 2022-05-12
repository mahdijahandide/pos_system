class ProductColorModel {
  int? id;
  int? colorId;
  String? colorName;
  String? colorImage;
  String? colorCode;
  String? productColorImage;
  int? quantity;
  int? retailPrice;
  int? oldPrice;

  ProductColorModel({data}) {
    id=data['id'];
    colorId=data['color_id'];
    colorName=data['color_name'];
    colorImage=data['color_image'];
    colorCode=data['color_code'];
    productColorImage=data['product_color_image'];
    quantity=data['quantity'];
    retailPrice=data['retail_price'];
    oldPrice=data['old_price'];
  }
}
