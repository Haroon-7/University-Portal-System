class LoginUser {

  late String name;
  late String password;

  late int uid; // Make u_id nullable

  LoginUser.fromMap(Map<String, dynamic> loginmap) {

    name = loginmap["name"];
    password = loginmap["password"];
    uid = loginmap["uid"] as int; // Handle the possible null value

  }
}
