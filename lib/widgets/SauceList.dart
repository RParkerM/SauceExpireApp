import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sauce_app_dog/models/SauceExpiresDataList.dart';
import 'package:sauce_app_dog/widgets/SauceExpiresWidget.dart';

import '../models/SauceExpiresData.dart';

class SauceList extends StatefulWidget {
  final String listName;
  final SauceExpiresDataList dataList;
  final Function onUpdate;
  final bool canAddMore;

  SauceList(
      {@required this.listName,
      this.dataList,
      this.onUpdate,
      this.canAddMore = true});

  @override
  _SauceListState createState() =>
      _SauceListState(expireData: dataList, onUpdate: onUpdate);

  List<SauceExpiresData> getExpiredSauces({DateTime date}) {
    if (date == null) date = DateTime.now();
    return dataList.list
        .where((sauceData) => isDateEarlier(sauceData.expireDate, date))
        .toList();
  }

  bool isDateEarlier(DateTime a, DateTime b) {
    return a.year < b.year ||
        a.year == b.year &&
            (a.month < b.month || a.month == b.month && (a.day < b.day));
  }
}

class _SauceListState extends State<SauceList> {
  final List<SauceExpiresData> expireList;
  final Function onUpdate;

  _SauceListState({SauceExpiresDataList expireData, this.onUpdate})
      : expireList = expireData != null && expireData.list != null
            ? expireData.list
            : [];

  String get serializedList {
    return jsonEncode(SauceExpiresDataList(expireList));
  }

  @override
  Widget build(BuildContext context) {
    expireList.sort();
    return Container(
        height: 100,
        margin: EdgeInsets.symmetric(vertical: 25),
        //margin: EdgeInsets.all(25),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: expireList.length + 1 + (widget.canAddMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                height: 10,
                width: 100,
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text(
                  widget.listName,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              );
            } else if (widget.canAddMore && index == expireList.length + 1) {
              return IconButton(
                icon: Icon(Icons.add_circle),
                color: Colors.green,
                onPressed: _addNewSauceDate,
              );
            } else {
              SauceExpiresData newData = expireList[index - 1];
              return SauceExpiresWidget(
                newData,
                () => setState(newData.increment),
                deleteData: () => _removeSauceData(index - 1),
                updateData: () => _modifySauceData(index - 1),
              );
            }
          },
        ));
  }

  @override
  void setState(Function fn) {
    super.setState(fn);
    print("Updating");
    if (onUpdate != null) {
      print("Calling onUpdate");
      onUpdate(widget.listName, this.serializedList);
    }
  }

  void _addNewSauceDate() {
    _sauceDatePicker().then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        expireList.add(SauceExpiresData(pickedDate));
      });
    });
  }

  void _modifySauceData(index) {
    TextEditingController _amountController =
        new TextEditingController(text: expireList[index].amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.all(16),
          //title: Text("Modify Date or Amount"),
          children: [
            TextField(
                onChanged: (text) {
                  final int newAmount = int.tryParse(text);
                  if (newAmount != null) {
                    setState(() {
                      expireList[index].amount = newAmount;
                    });
                  }
                },
                keyboardType: TextInputType.number,
                controller: _amountController,
                decoration: new InputDecoration(labelText: 'Amount Needed:')),
            RaisedButton(
              child: Text("Change Date"),
              onPressed: () {
                _sauceDatePicker().then((pickedDate) {
                  if (pickedDate == null) {
                    return;
                  }
                  final amount = expireList[index].amount;
                  setState(() {
                    expireList[index] = SauceExpiresData(pickedDate);
                    expireList[index].setAmount(amount);
                  });
                });
              },
            )
          ],
        );
      },
    );
  }

  void _removeSauceData(index) {
    setState(() => expireList.removeAt(index));
  }

  Future<DateTime> _sauceDatePicker() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
  }
}
