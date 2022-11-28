//BASE URL

//gulfweb
// const String DOMAIN = 'http://localhost:51275';
 String DOMAIN = 'https://${Uri.base.host}';
 String BASE_URL = 'https://${Uri.base.host}/api/posv1/';
 String BASE_URL_IMAGES = 'https://${Uri.base.host}/uploads/logo/';
 String MD5_PRINT_URL = 'https://${Uri.base.host}/en/order-print/';

//mrk
// const String DOMAIN = 'https://pos.mrk-q8.com';
// const String BASE_URL = 'https://mrk-q8.com/api/posv1/';
// const String BASE_URL_IMAGES = 'https://mrk-q8.com/uploads/logo/';
// const String MD5_PRINT_URL = 'https://kw.mrk-q8.com/en/order-print/';

//kash5astore
// const String DOMAIN = 'https://pos.kash5astore.com';
// const String BASE_URL = 'https://kash5astore.com/api/posv1/';
// const String BASE_URL_IMAGES = 'https://kash5astore.com/uploads/logo/';
// const String MD5_PRINT_URL = 'https://kw.kash5astore.com/en/order-print/';

//Sanam
// const String DOMAIN = 'https://pos.sanamstore.net';
// const String BASE_URL = 'https://sanamstore.net/api/posv1/';
// const String BASE_URL_IMAGES = 'https://sanamstore.net/uploads/logo/';
// const String MD5_PRINT_URL = 'https://sanamstore.net/en/order-print/';

//routes
 String GET_SETTING_DETAILS_ROUTE = BASE_URL + 'getSetting';
 String LOGIN_ROUTE = BASE_URL + 'login';
 String LOGOUT_ROUTE = BASE_URL + 'logout';
 String PRODUCT_DETAILS_ROUTE = BASE_URL + 'getProductDetails';
 String GET_ALL_CATEGORIES_ROUTE = BASE_URL + 'category';
 String PRODUCTS_BY_CATEGORIES_ROUTE = BASE_URL + 'productsByCategory';
 String ADD_TO_CART = BASE_URL + 'addtocart';
 String EDIT_CART_QTY = BASE_URL + 'addremovequantity';
 String REMOVE_FROM_CART = BASE_URL + 'removeTempOrder';
 String GET_TEMP_ORDERS = BASE_URL + 'getTempOrders';
 String REMOVE_ALL_FROM_CART = BASE_URL + 'removeAllTempOrder';
 String UPDATE_PROFILE = BASE_URL + 'editProfile';
 String GET_AREAS = BASE_URL + 'getAreas';
 String GET_Customers = BASE_URL + 'getCustomers';
 String CHECKOUT_CART = BASE_URL + 'checkoutConfirm';
 String ADD_NEW_CUSTOMER = BASE_URL + 'AddNewCustomer';
 String GET_ORDERS = BASE_URL + 'getOrders';
 String GET_ORDER_ITEMS = BASE_URL + 'getOrderItems';
 String CASH_IN_OUT = BASE_URL + 'cash/change';
 String CASH_HISTORY = BASE_URL + 'cash/history';
 String SHIFT_DETAILS = BASE_URL + 'shift/details';
 String SHIFT_START = BASE_URL + 'shift/start';
 String SHIFT_END = BASE_URL + 'shift/end';
 String CHECK_ADMIN_PASSWORD_ROUTE = BASE_URL + 'supervisor_password';

String getRefundCartRoute(String id) {
  return BASE_URL + 'order/$id/refund';
}

String getRefundCartItemRoute(String id) {
  return BASE_URL + 'order/$id/refund/item';
}

String getCustomerAddress(String customerId) {
  return BASE_URL + 'user/$customerId/address';
}

String createNewAddress(String customerId) {
  return BASE_URL + 'user/$customerId/address';
}

String updateCustomerAddress(String customerId, String addressId) {
  return BASE_URL + 'user/$customerId/address/$addressId';
}

String deleteCustomerAddress(String customerId, String addressId) {
  return BASE_URL + 'user/$customerId/address/$addressId';
}
