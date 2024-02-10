class HECLogin {

  late String name;
  late String password;
  int? h_id; // Make u_id nullable

  HECLogin.fromMap(Map<String, dynamic> loginmap) {

    name = loginmap["name"];
    password = loginmap["password"];
    h_id = loginmap["hid"] as int?; // Handle the possible null value

  }
}