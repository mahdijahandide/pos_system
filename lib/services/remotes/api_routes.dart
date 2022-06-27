//BASE URL
// const String DOMAIN = 'http://localhost:59085';
// const String DOMAIN = 'https://possystem.gulfweb.ir';
// const String BASE_URL = 'https://kash5a2.gulfweb.ir/api/posv1/';
// const String BASE_URL_IMAGES = 'https://kash5a2.gulfweb.ir/uploads/logo/';
const String DOMAIN = 'https://pos.mrk-q8.com';
const String BASE_URL = 'https://mrk-q8.com/api/posv1/';
const String BASE_URL_IMAGES = 'https://mrk-q8.com/uploads/logo/';

//routes
const String GET_SETTING_DETAILS_ROUTE = BASE_URL + 'getSetting';
const String LOGIN_ROUTE = BASE_URL + 'login';
const String LOGOUT_ROUTE = BASE_URL + 'logout';
const String PRODUCT_DETAILS_ROUTE = BASE_URL + 'getProductDetails';
const String GET_ALL_CATEGORIES_ROUTE = BASE_URL + 'category';
const String PRODUCTS_BY_CATEGORIES_ROUTE = BASE_URL + 'productsByCategory';
const String ADD_TO_CART = BASE_URL + 'addtocart';
const String EDIT_CART_QTY = BASE_URL + 'addremovequantity';
const String REMOVE_FROM_CART = BASE_URL + 'removeTempOrder';
const String GET_TEMP_ORDERS = BASE_URL + 'getTempOrders';
const String REMOVE_ALL_FROM_CART = BASE_URL + 'removeAllTempOrder';
const String UPDATE_PROFILE = BASE_URL + 'editProfile';
const String GET_AREAS = BASE_URL + 'getAreas';
const String GET_Customers = BASE_URL + 'getCustomers';
const String CHECKOUT_CART = BASE_URL + 'checkoutConfirm';
const String ADD_NEW_CUSTOMER = BASE_URL + 'AddNewCustomer';
const String GET_ORDERS = BASE_URL + 'getOrders';
const String GET_ORDER_ITEMS = BASE_URL + 'getOrderItems';
const String CASH_IN_OUT = BASE_URL + 'cash/change';
const String CASH_HISTORY = BASE_URL + 'cash/history';
const String SHIFT_DETAILS = BASE_URL + 'shift/details';
const String SHIFT_START = BASE_URL + 'shift/start';
const String SHIFT_END = BASE_URL + 'shift/end';

String getRefundCartRoute(String id) {
  return BASE_URL + 'order/$id/refund';
}

String getRefundCartItemRoute(String id) {
  return BASE_URL + 'order/$id/refund/item';
}
