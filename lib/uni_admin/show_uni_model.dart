// To parse this JSON data, do
//
//     final showUniversity = showUniversityFromJson(jsonString);

import 'dart:convert';

List<ShowUniversity> showUniversityFromJson(String str) => List<ShowUniversity>.from(json.decode(str).map((x) => ShowUniversity.fromJson(x)));

String showUniversityToJson(List<ShowUniversity> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowUniversity {
  int uid;
  String pname;
  String dname;

  ShowUniversity({
    required this .uid,
    required this.pname,
    required this.dname,
  });

  factory ShowUniversity.fromJson(Map<String, dynamic> json) => ShowUniversity(
    uid: json["uid"],
    pname: json["pname"],
    dname: json["dname"],
  );

  Map<String, dynamic> toJson() => {
    "uid":uid,
    "pname": pname,
    "dname": dname,
  };
}
