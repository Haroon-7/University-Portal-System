// To parse this JSON data, do
//
//     final showEnrolledUniversity = showEnrolledUniversityFromJson(jsonString);

import 'dart:convert';

List<ShowEnrolledUniversity> showEnrolledUniversityFromJson(String str) => List<ShowEnrolledUniversity>.from(json.decode(str).map((x) => ShowEnrolledUniversity.fromJson(x)));

String showEnrolledUniversityToJson(List<ShowEnrolledUniversity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowEnrolledUniversity {
  String uName;
  String city;
  String image;
  int? uid;

  ShowEnrolledUniversity({
    required this.uName,
    required this.city,
    required this.image,
    required this.uid
  });

  factory ShowEnrolledUniversity.fromJson(Map<String, dynamic> json) => ShowEnrolledUniversity(
    uName: json["u_name"],
    city: json["city"],
    image: json["image"],
    uid: json["uid"]
  );

  Map<String, dynamic> toJson() => {
    "u_name": uName,
    "city": city,
    "image": image,
    "uid":uid
  };
}
