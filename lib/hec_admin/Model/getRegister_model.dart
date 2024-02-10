// To parse this JSON data, do
//
//     final getRegister = getRegisterFromJson(jsonString);

import 'dart:convert';

List<GetRegister> getRegisterFromJson(String str) => List<GetRegister>.from(json.decode(str).map((x) => GetRegister.fromJson(x)));

String getRegisterToJson(List<GetRegister> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetRegister {
  String notifications;
  int uid;
  String uName;
  String city;
  String image;

  GetRegister({
    required this.notifications,
    required this.uid,
    required this.uName,
    required this.city,
    required this.image

  });

  factory GetRegister.fromJson(Map<String, dynamic> json) => GetRegister(
    notifications: json["Notifications"],
    uid: json["uid"],
    uName: json["u_name"],
    city: json["city"],
    image: json["image"]

  );

  Map<String, dynamic> toJson() => {
    "Notifications": notifications,
    "uid": uid,
    "u_name": uName,
    "city":city,
    "image":image
  };
}
