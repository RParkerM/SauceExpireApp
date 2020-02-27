import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app_dog/models/SauceExpiresDataList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './widgets/SauceList.dart';
import './models/SauceExpiresData.dart';
import 'widgets/MainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  List<SauceList> loadData() {
    List<SauceList> sauceLists = [];
    //List<String> sauces = ['Soy Sauce','BBQ Sauce','Hot Sauce','Mustard'];
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
        print(expiresDataList);
        sauceLists.add(SauceList(
          listName: listName,
          onUpdate: _onUpdate,
          dataList: SauceExpiresDataList(expiresDataList),
        ));
      } else {
        sauceLists.add(SauceList(listName: listName, onUpdate: _onUpdate));
      }
    });

    return sauceLists;
  }

  runApp(MyApp(sauceList: loadData()));
}

void _onUpdate(String listName, String serializedData) async {
  // print("Modified $listName");
  // print(serializedData);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(listName, serializedData);
}

class MyApp extends StatefulWidget {
  final List<SauceList> _sauceLists;

  //final List<SauceList> _sauceLists = [
  MyApp({List<SauceList> sauceList})
      : _sauceLists = sauceList != null
            ? sauceList
            : [
                SauceList(
                  listName: "Soy Sauce",
                  onUpdate: _onUpdate,
                ),
                SauceList(
                  listName: "BBQ Sauce",
                  onUpdate: _onUpdate,
                ),
                SauceList(
                  listName: "Hot Sauce",
                  onUpdate: _onUpdate,
                ),
                SauceList(
                  listName: "Mustard",
                  onUpdate: _onUpdate,
                  canAddMore: false,
                ),
              ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    widget._sauceLists.forEach((f) => print(f.getExpiredSauces()));
    return MaterialApp(
        title: 'Flutter Demo', home: MainPage(sauceLists: widget._sauceLists));
  }
}
