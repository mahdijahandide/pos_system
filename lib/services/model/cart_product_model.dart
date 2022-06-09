class CartProductModel {
  int? id;
  String?productId;
  String? price;
  String? quantity;
  String? title;
  String? titleAr;
  String? tempUniqueId;
  bool isSelected=false;

  CartProductModel({required mId,required pId,required mPrice,required mQuantity,required mTitle,required mTitleAr,required mTempUniqueId}) {
     id=mId;
     productId=pId.toString();
     price=mPrice;
     quantity=mQuantity;
     title=mTitle;
     titleAr=mTitleAr;
     tempUniqueId=mTempUniqueId;
    }
}
