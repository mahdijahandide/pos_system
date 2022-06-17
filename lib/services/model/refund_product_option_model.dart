class RefundProductOptionsModel {
  //     {
  //         "id": 1,
  //         "type": "size",
  //         "name": "L"
  //     },
  int? id;
  String? type;
  String? name;

  RefundProductOptionsModel({data}) {
    id = data['id'];
    type = data['type'];
    name = data['name'];
  }
}
