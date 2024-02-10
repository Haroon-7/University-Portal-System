class Degree {

  late String Program;
  late List<String> plist;
  late List<String> Test;
  late String sdate,edate;
  late String description;
  int? fee;
  Degree();
  Degree.fromMap(Map<String, dynamic> loginmap,) {

    Program = loginmap["Program"];
    plist = loginmap["plist"];
    sdate = loginmap["sdate"];
    edate = loginmap["edate"];
    Test = loginmap["Test"];
    description = loginmap["description"];
    fee= loginmap["fee"] as int?; // Handle the possible null value

  }
  Map<String,dynamic> toMap()
  {
   return  {
      "degree":Program,
     "programs":plist,
     "fee": fee,
     "tests":Test,
     "des":description,
     "sdate":sdate,
     "edate":edate
    };

  }
}