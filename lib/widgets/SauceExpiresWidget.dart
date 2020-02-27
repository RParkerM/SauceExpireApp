import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/SauceExpiresData.dart';

class SauceExpiresWidget extends StatelessWidget {
  final SauceExpiresData data;
  final Function incrementData;
  final Function deleteData;
  final Function updateData;

  SauceExpiresWidget(this.data, this.incrementData,
      {@required this.deleteData, @required this.updateData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: incrementData,
          child: Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.all(6),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkResponse(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 0),
                              child: Icon(
                                Icons.settings,
                                size: 14,
                              ),
                            ),
                            onTap: () {},
                            onLongPress: () {
                              updateData();
                            },
                          ),
                          Text("Expires"),
                          SizedBox(
                            width: 10,
                            height: 10,
                          )
                        ]),
                    Text(
                      DateFormat("M-d").format(data.expireDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(data.amount.toString())
                  ],
                ),
              )),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: InkResponse(
            onTap: () {},
            onLongPress: () {
              //onLongPressUp: () {
              deleteData();
            },
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}

/*@override
  State<StatefulWidget> createState() {
    return _SaucesExpiresState(this.data);
  }
}

class _SaucesExpiresState extends State<SauceExpiresWidget> {
  final SauceExpiresData data;

  _SaucesExpiresState(this.data);

  void incrementData() {
    this.setState(() => data.increment());
  }

  @override
  Widget build(BuildContext context) {
    //print(DateFormat("M-d").format(data.expireDate));
    return Stack(
      children: [
        GestureDetector(
          onTap: incrementData,
          child: Container(
              //padding: EdgeInsets.all(10),
              width: 100,
              height: 100,
              margin: EdgeInsets.all(6),
              child: Card(
                elevation: 5,
                margin: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1, vertical: 0),
                              child: Icon(
                                Icons.settings,
                                size: 14,
                              ),
                            ),
                            onTap: () {
                              print("Settings");
                            },
                            onLongPress: () {
                              print("Pressed long");
                            },
                          ),
                          Text("Expires"),
                          SizedBox(
                            width: 10,
                            height: 10,
                          )
                        ]),
                    Text(
                      DateFormat("M-d").format(data.expireDate),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(data.amount.toString())
                  ],
                ),
              )),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          child: GestureDetector(
            onTap: () {
              print("close");
            },
            onLongPress: () {
              print("Pressed long");
            },
            child: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }
}*/
