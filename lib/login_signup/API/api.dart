import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ups/login_signup/Model/add_review.dart';
import 'package:ups/login_signup/Model/add_testimonial.dart';
import 'package:ups/login_signup/Model/add_uni_Model.dart';
import 'package:ups/login_signup/Model/signup_model.dart';
import 'package:ups/login_signup/Model/user_signup.dart';
import '../../Global/Global.dart';

class APIHandler {
  Future<http.Response> login(String username, String password) async {
    String url = '${ip}/Login/Login';

    // Encode the parameters in the URL
    String encodedUrl = Uri.parse(url).replace(queryParameters: {
      'name': username,
      'password': password,
    }).toString();

    // Send a GET request
    var response = await http.get(
      Uri.parse(encodedUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    return response;
  }

  Future<http.Response> Userlogin(String username, String password) async {
    String url = '${ip}/Login/UserLogin';

    // Encode the parameters in the URL
    String encodedUrl = Uri.parse(url).replace(queryParameters: {
      'name': username,
      'password': password,
    }).toString();

    // Send a GET request
    var response = await http.get(
      Uri.parse(encodedUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    return response;
  }

  Future<int> UserSignUpAccount(SignUpUser us) async {
    String url = '${ip}/Signup/UserSignup';
    print(url);
    Map<String, dynamic> jsonstring = us.toJsonString();
    String reqbody = jsonEncode(jsonstring);
    print(reqbody);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: reqbody);
    return response.statusCode;
  }

  Future<int> SignUpAccount(UserSignUp us) async {
    String url = '${ip}/Signup/Signup';
    print(url);
    Map<String, dynamic> jsonstring = us.toJsonString();
    String reqbody = jsonEncode(jsonstring);
    print(reqbody);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: reqbody);
    return response.statusCode;
  }

  Future<int> ReviewAdd(Review us) async {
    String url = '${ip}/Task/Addreview$tid';
    print(url);
    Map<String, dynamic> jsonstring = us.toJsonString();
    String reqbody = jsonEncode(jsonstring);
    print(reqbody);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: reqbody);
    return response.statusCode;
  }

  Future<int> addUniversity(AddUni au, File imgfile) async {
    try {
      String apiUrl =
          '${ip}/University/addUniversity?uid=${Uri.encodeComponent(au.uid.toString())}';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields.addAll({
        'uid': au.uid.toString(),
        'name': au.u_name ?? '',
        'city': au.city ?? '',
      });

      // Add image file
      request.files
          .add(await http.MultipartFile.fromPath('image', imgfile.path));

      // Set content type
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return 200;
      } else {
        print(response.reasonPhrase);
        throw Exception('Failed to upload data');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Failed to upload data');
    }
  }

  Future<http.Response> adminlogin(String username, String password) async {
    String url = '${ip}/Admin/adminlogin';

    // Encode the parameters in the URL
    String encodedUrl = Uri.parse(url).replace(queryParameters: {
      'name': username,
      'password': password,
    }).toString();

    // Send a GET request
    var response = await http.get(
      Uri.parse(encodedUrl),
      headers: {'Content-Type': 'application/json'},
    );

    print(response.body);

    return response;
  }

  Future<http.Response> UpdateDeg(String json) async {
    var response = await http.post(
      Uri.parse(''),
      body: json,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<int> addTestimonial(AddTes at) async {
    try {
      String apiUrl = '${ip}/Task/AddTestnmial?uid=$uid&tid=$tid';
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add form fields
      request.fields.addAll({
        'uid': at.uid.toString(),
        'tid': at.tid.toString(),
        'name': at.name ?? '',
        'Currentlydoing': at.Currentlydoing ?? '',
        'Testimonial': at.Testimonial ?? ''
      });

      // Add image file

      // Set content type
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
        return 200;
      } else {
        print(response.reasonPhrase);
        throw Exception('Failed to upload data');
      }
    } catch (error) {
      print('Error occurred: $error');
      throw Exception('Failed to upload data');
    }
  }

/*
  Future<void> onSearch(String txt, List<dynamic> program,
      Function setSearchProgram) async {
    if (txt.isNotEmpty) {
      List<dynamic> tempData = program.where((item) {
        return item['program'].toLowerCase().contains(txt.toLowerCase());
      }).toList();
      setSearchProgram(tempData);
    } else {
      setSearchProgram(program);
    }
  }

  Future<void> handleRadioButtonPress(String value,
      Function setProgram, Function setSearchProgram,
      Function setSelectedDegree,
      Function setSelectedProgram) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ip}/UniversityPortalSystem/api/University/getDegreePrograms?degree=$value'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched items: $data');
        setProgram(data);
        setSearchProgram(data);
        setSelectedDegree(value);
      } else {
        print('Fetch failed');
      }
      setSelectedProgram([]);
    } catch (error) {
      print('Fetch error: $error');
    }
  }
*/

  /* Future<void> saveData() async {
    List<dynamic> selectedProgramsIds = [];
    selectedProgram.forEach((prog) {
      final foundObject = program.firstWhere((item) => item['program'] == prog, orElse: () => null);
      if (foundObject != null) {
        selectedProgramsIds.add(foundObject['id']);
      }
    });

    List<dynamic> selectedOfferIds = [];

    try {
      for (var programId in selectedProgramsIds) {
        final formData = FormData.fromMap({'Status': 'true'});

        final response = await http.post(
          Uri.parse('${url}/UniversityPortalSystem/api/University/AddoruodateUniprogram?uid=$uid&proid=$programId'),
          body: formData,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          selectedOfferIds.add(data);
        } else {
          print('Program insertion failed for program ID: $programId');
          // Handle the failed insertion as required
        }
      }
      setState(() {
        selectedProgram = [];
      });
    } catch (error) {
      print('An error occurred while inserting degree: $error');
      // Handle error
    }

    await handleFee(selectedOfferIds);
    await handleElligibility(selectedOfferIds);
    await handleAdmission(selectedOfferIds);
  }

  Future<void> handleFee(List<dynamic> selectedOfferIds) async {
    try {
      for (var offerId in selectedOfferIds) {
        final formData = FormData.fromMap({'Fee': amount});

        final response = await http.post(
          Uri.parse('${url}/UniversityPortalSystem/api/University/AddorupdateFee?oid=$offerId'),
          body: formData,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Fee Structure inserted successfully: $data');
        } else {
          print('Fee insertion failed for offer ID: $offerId');
          // Handle the failed insertion as required
        }

        setState(() {
          selectedProgram = [];
        });
      }
    } catch (error) {
      print('An error occurred while inserting degree: $error');
      // Handle error
    }
  }

  Future<void> handleElligibility(List<dynamic> selectedOfferIds) async {
    try {
      for (var offerId in selectedOfferIds) {
        final formData = FormData.fromMap({
          'NTS': NTS.toString(),
          'GAT': GAT.toString(),
          'Other': Other.toString(),
          'Description': description,
        });

        final response = await http.post(
          Uri.parse('${url}/UniversityPortalSystem/api/University/AddorupdateElligiblty?oid=$offerId'),
          body: formData,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Eligibility Criteria inserted successfully: $data');
        } else {
          print('Eligibility Criteria insertion failed for offer ID: $offerId');
          // Handle the failed insertion as required
        }
      }
    } catch (error) {
      print('An error occurred while inserting Eligibility Criteria: $error');
      // Handle error
    }
  }

  String formatDate(String date) {
    final formattedDate = DateTime.parse(date);
    final year = formattedDate.year;
    final month = formattedDate.month;
    final day = formattedDate.day;
    return '$year,$month,$day';
  }

  Future<void> handleAdmission(List<dynamic> selectedOfferIds) async {
    try {
      for (var offerId in selectedOfferIds) {
        final formData = FormData.fromMap({
          'sdate': formatDate(startDate),
          'edate': formatDate(endDate),
        });

        final response = await http.post(
          Uri.parse('${url}/UniversityPortalSystem/api/University/AddorupdateAdmission?oid=$offerId'),
          body: formData,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Admission Date inserted successfully: $data');
        } else {
          print('Admission Date insertion failed for offer ID: $offerId');
          final errorResponse = await response.body;
          print('Error response: $errorResponse');
        }
        print('Fee inserted successfully');
      }
    } catch (error) {
      print('An error occurred while inserting Admission Date: $error');
      // Handle error
    }
  }*/
}
