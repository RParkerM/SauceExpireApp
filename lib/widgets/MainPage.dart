import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sauce_app_dog/widgets/SauceList.dart';

class MainPage extends StatelessWidget {
  final List<SauceList> sauceLists;
  //bool hasExpiredSauces = false;

  const MainPage({@required this.sauceLists});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: (true)
      //     ? null
      //     : Container(
      //         //child: CircleAvatar(
      //         //child: CircleAvatar(
      //         child: FloatingActionButton(
      //           backgroundColor: Theme.of(context).errorColor,
      //           onPressed: () => null,
      //           child: Icon(
      //             Icons.new_releases,
      //             size: 42,
      //             //color: Theme.of(context).errorColor,
      //           ),
      //         ),
      //         //),
      //       ),
      // // ),
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: sauceLists,
        ),
      ),
    );
  }
}
