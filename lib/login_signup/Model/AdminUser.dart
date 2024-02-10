class Admin {
  late int hid;
  late String name;
  late String email;
  late String contact;

  // AdminUser({required this.hid, required this.name, required this.email, required this.contact});
  Admin.fromMap(Map<String, dynamic> loginmap) {

    hid = loginmap["hid"];
    name = loginmap["name"];
    email = loginmap["email"];
    contact = loginmap["contact"];


   // password = loginmap["password"];
    //u_id = loginmap["uid"] as int?; // Handle the possible null value

  }

}




