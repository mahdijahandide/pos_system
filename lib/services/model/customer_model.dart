import 'package:get/state_manager.dart';

import 'customer_address_model.dart';

class CustomerModel {
  int? id;
  String? name, mobile, email;
  RxList<CustomerAddressModel> addressList = RxList([]);
  RxBool hasAddress = false.obs;

  CustomerModel({data}) {
    id = data['id'] ?? '';
    name = data['name'] ?? '';
    mobile = data['mobile'] ?? '';
    email = data['email'] ?? '';
  }
}
