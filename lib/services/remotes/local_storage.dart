import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:universal_html/html.dart';

import '../model/cart_product_model.dart';


class LocalStorageHelper{
  static Storage localStorage=window.localStorage;

  //To Save Data
  static void saveValue(String key,String value){
    localStorage[key]=value;
  }
  //To Save Data
  static void saveCartValue(String key,dynamic value){
    localStorage[key]=value;
  }
  //Get Data
  static String getValue(String key){
    return localStorage[key].toString();
  }
  //Remove Data
  static void removeValue(String key){
    localStorage.remove((key));
  }
  //Clear All
  static void clearAll(){
    localStorage.clear();
  }
}