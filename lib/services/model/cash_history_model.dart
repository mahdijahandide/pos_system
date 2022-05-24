import 'package:pos_system/services/model/area_model.dart';
import 'package:intl/intl.dart';

// {
// "id": 32,
// "pos_id": 1,
// "shift_id": 15,
// "amount": 10,
// "type": "in",
// "description": "Start Cash for 2022-05-22 11:17:36",
// "refrence_id": 15,
// "refrence_type": "App\\WorkTime",
// "beforeCash": 0,
// "afterCash": 10,
// "created_at": "2022-05-22 11:17:36",
// "updated_at": "2022-05-22 11:17:36",
// "pos": {
// "id": 1,
// "slug": null,
// "title_en": null,
// "title_ar": null,
// "details_en": null,
// "details_ar": null,
// "friendly_url": null,
// "header_image": null,
// "userType": "admin",
// "name": "admin",
// "mobile": "00000000",
// "image": "admin-90e1d72a2b0b83f167ba5d17d97c77ff.png",
// "username": "admin",
// "email": "info@kash5astore.com",
// "is_active": 1,
// "password_token": "1a45ddf1-5b55-427c-a093-3c2fe81b0616",
// "display_order": 0,
// "is_home": 0,
// "created_by": null,
// "created_at": "2020-02-03 16:05:44",
// "updated_at": "2020-10-21 08:32:35"
// }
// }

class CashHistoryModel {
  int? id;
  double?amount;
  String?type;
  String?created_at;
  String?description;
  String?by;

  CashHistoryModel({data}) {
      id=data['id'];
      amount=data['amount'];
      type=data['type'];
      created_at= DateFormat('yyyy-MM-dd').format(DateTime.parse(data['created_at'].toString()));
      description=data['description'];
      by=data['pos']['username'];
  }
}
