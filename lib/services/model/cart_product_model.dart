class CartProductModel {
  int? id;
  String?productId;
  String? price;
  String? quantity;
  String? title;
  String? tempUniqueId;
  bool isSelected=false;

  CartProductModel({required mId,required pId,required mPrice,required mQuantity,required mTitle,required mTempUniqueId}) {
     id=mId;
     productId=pId.toString();
     price=mPrice;
     quantity=mQuantity;
     title=mTitle;
     tempUniqueId=mTempUniqueId;
    }
}
