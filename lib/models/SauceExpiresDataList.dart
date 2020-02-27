import './SauceExpiresData.dart';

class SauceExpiresDataList {
  final List<SauceExpiresData> list;

  SauceExpiresDataList(this.list);

  SauceExpiresDataList.fromJson(Map<String, dynamic> json)
      : list = json['list'] != null
            ? List<SauceExpiresData>.from(json['list'])
            : null;

  Map<String, dynamic> toJson() => {
        'list': list,
      };
}
