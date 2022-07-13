class CartProductModel {
  int? id;
  String? productId;
  String? itemCode;
  String? price;
  String? quantity;
  String? title;
  String? titleAr;
  String? tempUniqueId;
  String? sizeId;
  String? colorId;
  bool isSelected = false;

  CartProductModel(
      {required mId,
      required pId,
      required iCode,
      required mPrice,
      required mQuantity,
      required mTitle,
      required mTitleAr,
      dynamic mSizeId,
      dynamic mColorId,
      required mTempUniqueId}) {
    id = mId;
    productId = pId.toString();
    price = mPrice;
    itemCode = iCode;
    quantity = mQuantity;
    title = mTitle;
    titleAr = mTitleAr;
    tempUniqueId = mTempUniqueId;
    sizeId = mSizeId ?? '';
    colorId = mColorId ?? '';
  }
}
