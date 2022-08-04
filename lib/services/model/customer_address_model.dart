class CustomerAddressModel {
  int? id, countryId, stateId, areaId;
  String? countryName,
      stateName,
      areaName,
      block,
      street,
      avenue,
      house,
      floor,
      title;

  // {
  //           "id": 309,
  //           "country_id": 2,
  //           "state_id": 4,
  //           "area_id": 6,
  //           "country_name": "Kuwait",
  //           "state_name": "Hawalli Governorate",
  //           "area_name": "Hawalli",
  //           "block": "1",
  //           "street": "1",
  //           "avenue": "1",
  //           "house": "13",
  //           "floor": "4",
  //           "title": "My Address",
  //           "is_default": 1,
  //           "landmark": "",
  //           "latitude": "",
  //           "longitude": ""
  //       }

  CustomerAddressModel({data}) {
    id = data['id'] ?? 0;
    countryId = data['country_id'] ?? 0;
    stateId = data['state_id'] ?? 0;
    areaId = data['area_id'] ?? 0;
    countryName = data['country_name'] ?? '';
    stateName = data['state_name'] ?? '';
    areaName = data['area_name'] ?? '';
    block = data['block'] ?? '';
    street = data['street'] ?? '';
    avenue = data['avenue'] ?? '';
    house = data['house'] ?? '';
    floor = data['floor'] ?? '';
    title = data['title'] ?? '';
  }
}
