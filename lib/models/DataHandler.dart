import 'dart:convert';

import 'package:sauce_app_dog/models/SauceExpiresData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SauceExpiresDataList.dart';

class DataHandler {
  // final Function onFinishedLoading;
  Map<String, SauceExpiresDataList> _data;
  SharedPreferences prefs;

  DataHandler();

  //Initializes SharedPreferences. This function returns a Future that is completed when the SharedPreferences Instance has been retrieved
  Future init() async {
    prefs = await SharedPreferences.getInstance();
    return Future.doWhile(() {
      return new Future.delayed(new Duration(milliseconds: 100), () {
        return (prefs == null);
      });
    });
  }

  //Loads and Deserializes saved data from SharedPreferences
  void loadData({Function onLoaded}) async {
    if (prefs == null) {
      await init();
    }

    Map<String, SauceExpiresDataList> sauceLists = {};
    ['Soy Sauce', 'BBQ Sauce', 'Hot Sauce', 'Mustard'].forEach((listName) {
      final String serializedList = prefs.getString(listName);
      if (serializedList != null) {
        //print(serializedList);
        List<SauceExpiresData> expiresDataList = [];
        Map<String, dynamic> decodedList = jsonDecode(serializedList);
        List<dynamic> decodedJson = decodedList['list'];
        decodedJson.forEach((elem) {
          expiresDataList.add(SauceExpiresData.fromJson(elem));
        });
        sauceLists[listName] = SauceExpiresDataList(expiresDataList);
      } else {
        sauceLists[listName] = SauceExpiresDataList([]);
      }
    });

    _data = sauceLists;
    onLoaded();
  }

  Map<String, SauceExpiresDataList> getData() {
    return _data;
  }

  void saveData(String listName, String serializedData) async {
    if (prefs == null) {
      await init();
    }
    await prefs.setString(listName, serializedData);
  }
}
