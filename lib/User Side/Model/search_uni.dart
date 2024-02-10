// To parse this JSON data, do
//
//     final searchUni = searchUniFromJson(jsonString);

import 'dart:convert';

List<SearchUni> searchUniFromJson(String str) =>
    List<SearchUni>.from(json.decode(str).map((x) => SearchUni.fromJson(x)));

String searchUniToJson(List<SearchUni> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchUni {
  String uName;
  String city;
  String image;
  int uid;
  String isSponser;
  String isRegistered;
  int programid;
  int amount;
  String url;

  SearchUni({
    required this.uName,
    required this.city,
    required this.image,
    required this.uid,
    required this.isSponser,
    required this.isRegistered,
    required this.programid,
    required this.amount,
    required this.url,
  });

  factory SearchUni.fromJson(Map<String, dynamic> json) => SearchUni(
        uName: json["u_name"],
        city: json["city"],
        image: json["image"],
        uid: json["uid"],
        isSponser: json["IS_Sponser"],
        isRegistered: json["is_registered"],
        programid: json["programid"],
        amount: json["Amount"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "u_name": uName,
        "city": city,
        "image": image,
        "uid": uid,
        "IS_Sponser": isSponser,
        "is_registered": isRegistered,
        "programid": programid,
        "Amount": amount,
        "url": url,
      };
}
