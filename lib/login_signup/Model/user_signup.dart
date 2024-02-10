class SignUpUser {
  late String name;
  late String password;

  Map<String, dynamic> toJsonString() {
    return {
      "name": name,
      "password": password,
    };
  }
}
