import 'package:flutter/material.dart';
import 'package:sauce_app_dog/models/DataHandler.dart';
import 'widgets/MainPage.dart';

const bool tabBarEnabled = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoaded = false;
  final DataHandler dataHandler;

  _MyAppState() : dataHandler = new DataHandler();

  @override
  void initState() {
    super.initState();
    dataHandler.loadData(onLoaded: () => setState(() => isLoaded = true));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: isLoaded
            ? MainPage(
                sauceDataLists: dataHandler.getData(),
                dataHandler: dataHandler,
              )
            : Scaffold(
                appBar: AppBar(
                title: Text("Loading"),
              )));
  }
}
