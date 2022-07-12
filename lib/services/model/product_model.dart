import 'package:get/get.dart';
import 'package:pos_system/services/controller/cart_controller.dart';
import 'package:pos_system/services/model/refund_product_option_model.dart';

class ProductModel {
  int? id;
  String? title;
  String? titleAr;
  String? extraTitle;
  String? image;
  String? rolloverImage;
  int? isAttribute;
  String? categoryId;
  String? category;
  int? isStock;
  String? captionTitle;
  String? captionColor;
  String? skuNumber;
  String? quantity;
  String? itemCode;
  double? retailPrice;
  double? oldPrice;

  //other items for refund
  int? productId;
  double? unitPrice;
  String? uniqueSid;
  double? subTotal;
  var productAttributes;
  List<RefundProductOptionsModel> itemOptionsList = [];

  // {
  // "id": 8558,
  // "product_id": 2080,
  // "title": "SONIFER Electric Grill 750W",
  // "translate": {
  //     "en": "SONIFER Electric Grill 750W",
  //     "ar": "سونيفر شواية كهربائية بقوة 750 واط"
  // },
  // "imageUrl": "https://www.kash5a2.gulfweb.ir/uploads/product/thumb/p-6efbde1cb289530d88405546355fe946.jpg",
  // "productAttributes": [
  //     {
  //         "id": 1,
  //         "type": "size",
  //         "name": "L"
  //     },
  //     {
  //         "id": 4,
  //         "type": "color",
  //         "name": "Black"
  //     }
  // ],
  // "unitprice": 5,
  // "quantity": 1,
  // "unique_sid": null,
  // "subtotal": 5
  // },

  ProductModel({data}) {
    if (Get.find<CartController>().isRefund.isFalse) {
      id = data['id'];
      productId = data['id'];
      title = data['title'];
      titleAr = data['translate']['ar'];
      extraTitle = data['extra_title'];
      image = data['image'];
      rolloverImage = data['rolloverImage'];
      isAttribute = data['is_attribute'];
      categoryId = data['category_id'];
      category = data['category'];
      isStock = data['is_stock'];
      captionTitle = data['caption_title'];
      captionColor = data['caption_color'];
      skuNumber = data['sku_no'];
      quantity = data['quantity'];
      itemCode = data['item_code'];
      retailPrice = double.parse(data['retail_price'].toString());
      oldPrice = double.parse(data['old_price'].toString());
    } else {
      id = data['id'] ?? 0;
      productId = data['product_id'] ?? 0;
      title = data['translate']['en'] ?? '';
      titleAr = data['translate']['ar'] ?? '';
      image = data['imageUrl'] ?? '';
      itemCode = data['item_code'];
      productAttributes = data['productAttributes'] ?? [];
      unitPrice = data['unitprice'] != null
          ? double.parse(data['unitprice'].toString())
          : 0.0;
      quantity = data['quantity'].toString();
      uniqueSid = data['unique_sid'] ?? '';
      subTotal = data['subtotal'] != null
          ? double.parse(data['subtotal'].toString())
          : 0.0;
      if (productAttributes.length > 0) {
        productAttributes.forEach((element) {
          itemOptionsList.add(RefundProductOptionsModel(data: element));
        });
      }
    }
  }
}
