class UserLogin {
  late String name;
  late String password;
  int? Usid; // Make u_id nullable

  UserLogin.fromMap(Map<String, dynamic> loginmap) {
    name = loginmap["name"];
    password = loginmap["password"];
    Usid = loginmap["Usid"] as int?; // Handle the possible null value
  }
}
