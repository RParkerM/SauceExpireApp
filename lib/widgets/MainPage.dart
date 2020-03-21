import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/DataHandler.dart';
import '../models/SauceExpiresDataList.dart';
import './SauceList.dart';

class MainPage extends StatefulWidget {
  //final List<SauceList> sauceLists = [];
  final DataHandler dataHandler;
  final Map<String, SauceExpiresDataList> sauceDataLists;

  MainPage({@required this.sauceDataLists, @required this.dataHandler});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final List<SauceList> sauceLists = [];
  bool hasExpiredSauces = false;
  bool saucesExpireBeforeAWeek = false;
  MediaQueryData media;
  int expiredSauceAmount = 0;
  int expiringSauceAmount = 0;

  final double bottomBarHeight = 70;

  @override
  void initState() {
    super.initState();
    widget.sauceDataLists.forEach((listName, expiresDataList) {
      sauceLists.add(SauceList(
        listName: listName,
        dataList: expiresDataList,
        onUpdate: _onUpdate,
      ));
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      checkIfSaucesExpired();
      this.setState(() {});
    }
  }

  void _onUpdate(String listName, String serializedData) async {
    widget.dataHandler.saveData(listName, serializedData);
    checkIfSaucesExpired();
  }

  void checkIfSaucesExpired() {
    int expiredSauces = 0;
    int expiringSauces = 0;

    sauceLists.forEach((sauceList) {
      int _expiredSauces = sauceList.getExpiredSauces();
      expiringSauces += sauceList.getExpiredSauces(
              date: DateTime.now().add(Duration(days: 7))) -
          _expiredSauces;
      expiredSauces += _expiredSauces;
    });
    if (expiringSauces != expiringSauceAmount ||
        expiredSauces != expiredSauceAmount) {
      setState(() {
        hasExpiredSauces = expiredSauces > 0 ? true : false;
        saucesExpireBeforeAWeek = expiringSauces > 0 ? true : false;
        expiringSauceAmount = expiringSauces;
        expiredSauceAmount = expiredSauces;
        print("Expired: " +
            expiredSauceAmount.toString() +
            ": Expiring: " +
            expiringSauceAmount.toString());
      });
    }
//    print(hasExpiredSauces);
  }

  @override
  Widget build(BuildContext context) {
    media = MediaQuery.of(context);
    // int _currentIndex = 0;
    print(hasExpiredSauces);
    Color expiredColor = hasExpiredSauces ? Colors.red : Colors.white;

    Color expiringColor =
        saucesExpireBeforeAWeek ? Colors.orange : Colors.white;

    final appBar = AppBar(
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          "Sauces: " + DateFormat("M-d").format(DateTime.now()),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "1 week: " +
              DateFormat("M-d")
                  .format(DateTime.now().add(new Duration(days: 7))),
          style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16),
        ),
      ]),
    );

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            width: media.size.width,
            height: bottomBarHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Expired",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: expiredColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                      Text(
                        expiredSauceAmount.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: expiredColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Expiring Soon:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: expiringColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        ),
                        Text(
                          expiringSauceAmount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: expiringColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        )
                      ])
                ]),
          ),
        ),
        appBar: appBar,
        body: Container(
          height: (MediaQuery.of(context).size.height -
              (appBar.preferredSize.height + bottomBarHeight)),
          child: SingleChildScrollView(
            child: Column(
              children: sauceLists,
            ),
          ),
        ),
      ),
    );
  }
}
