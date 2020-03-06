import 'package:intl/intl.dart';

class SauceExpiresData implements Comparable<SauceExpiresData> {
  final DateTime expireDate;
  int amount = 1;

  SauceExpiresData(this.expireDate);

  SauceExpiresData.fromJson(Map<String, dynamic> json)
      : expireDate = DateTime.parse(json['expireDate']),
        amount = json['amount'];

  Map<String, dynamic> toJson() => {
        'expireDate': DateFormat('yyyy-MM-dd').format(expireDate),
        'amount': amount
      };

  void increment() {
    amount++;
  }

  void setAmount(int amount) {
    this.amount = amount;
  }

  int compareTo(SauceExpiresData other) {
    return this.expireDate.compareTo(other.expireDate);
  }

  String toString() {
    return ("{expireDate: " +
        DateFormat('yyyy-MM-dd').format(expireDate) +
        ", amount: $amount");
  }
}
