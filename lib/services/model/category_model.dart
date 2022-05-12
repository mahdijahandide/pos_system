class CategoryModel {
  int? id;
  String? title;
  String? image;
  List<CategoryModel> subCategory=[];

  CategoryModel({data}) {
    id=data['id'];
    title=data['name'];
    image=data['image'];
    var sub=data['child']??[];
    if(sub!=null&&sub!=[]){
      sub.forEach((element){
        subCategory.add(CategoryModel(data: element));
      });
    }
  }
}
