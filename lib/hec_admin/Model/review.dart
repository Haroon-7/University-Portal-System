import 'dart:convert';

List<GetNames> getRegisterFromJson(String str) =>
    List<GetNames>.from(json.decode(str).map((x) => GetNames.fromJson(x)));

String getRegisterToJson(List<GetNames> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetNames {
  int uid;
  String name;
  String Currentlydoing;
  String Testinomial;

  GetNames(
      {required this.uid,
      required this.name,
      required this.Currentlydoing,
      required this.Testinomial});

  factory GetNames.fromJson(Map<String, dynamic> json) => GetNames(
      uid: json["uid"],
      name: json["name"],
      Currentlydoing: json["Currentlydoing"],
      Testinomial: json["Testinomial"]);

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "Currentlydoing": Currentlydoing,
        "Testinomial": Testinomial
      };
}
