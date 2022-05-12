class ProductModel {
  int?id;
  String?title;
  String?extraTitle;
  String?image;
  String?rolloverImage;
  int?isAttribute;
  String?categoryId;
  String?category;
  int?isStock;
  String?captionTitle;
  String?captionColor;
  String?skuNumber;
  String?quantity;
  String?itemCode;
  double?retailPrice;
  double?oldPrice;

  ProductModel({data}) {
    id=data['id'];
    title=data['title'];
    extraTitle=data['extra_title'];
    image=data['image'];
    rolloverImage=data['rolloverImage'];
    isAttribute=data['is_attribute'];
    categoryId=data['category_id'];
    category=data['category'];
    isStock=data['is_stock'];
    captionTitle=data['caption_title'];
    captionColor=data['caption_color'];
    skuNumber=data['sku_no'];
    quantity=data['quantity'];
    itemCode=data['item_code'];
    retailPrice=double.parse(data['retail_price'].toString());
    oldPrice=double.parse(data['old_price'].toString());
  }
}
