class AddTes {
  int? uid;
  int? tid;
  String? name;
  String? Currentlydoing;
  String? Testimonial;

  Map<String, dynamic> toJsonString() {
    return {
      "uid": uid,
      "tid": tid,
      "name": name,
      "Currentlydoing": Currentlydoing,
      "Testimonial": Testimonial
    };
  }

  AddTes(
      {required this.uid,
      required this.tid,
      required this.name,
      required this.Currentlydoing,
      required this.Testimonial});
}



//   AddUni copyWith({
//     String? name,
//     String? city,
//     String? image,
//     String? url,
//     String? Flink,
//     String? u_name,
//     String? password,
//   }) {
//     return AddUni(
//       name: name ?? this.name,
//       city: city ?? this.city,
//       image: image ?? this.image,
//       url: url ?? this.url,
//       Flink: Flink ?? this.Flink,
//       u_name: u_name ?? this.u_name,
//       password: password ?? this.password,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};
//
//     if(name != null){
//       result.addAll({'name': name});
//     }
//     if(city != null){
//       result.addAll({'city': city});
//     }
//     if(image != null){
//       result.addAll({'image': image});
//     }
//     if(url != null){
//       result.addAll({'url': url});
//     }
//     if(Flink != null){
//       result.addAll({'Flink': Flink});
//     }
//     if(u_name != null){
//       result.addAll({'u_name': u_name});
//     }
//     if(password != null){
//       result.addAll({'password': password});
//     }
//
//     return result;
//   }
//
//   factory AddUni.fromMap(Map<String, dynamic> map) {
//     return AddUni(
//       name: map['name'],
//       city: map['city'],
//       image: map['image'],
//       url: map['url'],
//       Flink: map['Flink'],
//       u_name: map['u_name'],
//       password: map['password'],
//     );
//   }
//
//   String toJson() => json.encode(toMap());
//
//   factory AddUni.fromJson(String source) => AddUni.fromMap(json.decode(source));
//
//   @override
//   String toString() {
//     return 'AddUni(name: $name, city: $city, image: $image, url: $url, Flink: $Flink, u_name: $u_name, password: $password)';
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//
//     return other is AddUni &&
//         other.name == name &&
//         other.city == city &&
//         other.image == image &&
//         other.url == url &&
//         other.Flink == Flink &&
//         other.u_name == u_name &&
//         other.password == password;
//   }
//
//   @override
//   int get hashCode {
//     return name.hashCode ^
//     city.hashCode ^
//     image.hashCode ^
//     url.hashCode ^
//     Flink.hashCode ^
//     u_name.hashCode ^
//     password.hashCode;
//   }
// }
