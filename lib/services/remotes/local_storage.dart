import 'package:universal_html/html.dart';


class LocalStorageHelper{
  static Storage localStorage=window.localStorage;

  //To Save Data
  static void saveValue(String key,String value){
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