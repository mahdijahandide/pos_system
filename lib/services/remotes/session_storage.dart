import 'package:universal_html/html.dart';


class SessionStorageHelper{
  static Storage sessionStorage=window.sessionStorage;

  //To Save Data
  static void saveValue(String key,String value){
    sessionStorage[key]=value;
  }
  //Get Data
  static String getValue(String key){
    return sessionStorage[key].toString();
  }
  //Remove Data
  static void removeValue(String key){
    sessionStorage.remove((key));
  }
  //Clear All
  static void clearAll(){
    sessionStorage.clear();
  }
}