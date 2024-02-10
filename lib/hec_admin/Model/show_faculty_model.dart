// To parse this JSON data, do
//
//     final showFaculty = showFacultyFromJson(jsonString);

import 'dart:convert';

List<ShowFaculty> showFacultyFromJson(String str) => List<ShowFaculty>.from(json.decode(str).map((x) => ShowFaculty.fromJson(x)));

String showFacultyToJson(List<ShowFaculty> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowFaculty {
  String? rank;
  String? total;
  int? uid;

  ShowFaculty({
    required this.uid,
    required this.rank,
    required this.total,
  });

  factory ShowFaculty.fromJson(Map<String, dynamic> json) => ShowFaculty(
    uid: json["uid"],
    rank: json["Rank"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "Rank": rank,
    "total": total,
  };
}
