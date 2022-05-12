import 'package:pos_system/services/model/product_color_model.dart';
import 'package:pos_system/services/model/product_model.dart';

class ProductSizeColorModel {
  int? sizeId;
  String? sizeName;
  int? quantity;
  int? retailPrice;
  int? oldPrice;
  List<ProductColorModel>colorList=[];

  ProductSizeColorModel({data}) {
    sizeId=data['size_id'];
    sizeName=data['size_name'];
    quantity=data['quantity'];
    retailPrice=data['retail_price'];
    oldPrice=data['old_price'];
    var colorsArray=data['colors'];
    colorsArray.forEach((element){
      colorList.add(ProductColorModel(data: element));
    });
  }
}
