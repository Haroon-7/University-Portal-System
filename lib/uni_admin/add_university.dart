import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ups/Global/Global.dart';

import 'package:ups/uni_admin/add_degree.dart';
import 'dart:io';
import '../hec_admin/notifications.dart';
import '../login_signup/Model/add_uni_Model.dart';
import '../login_signup/Model/login_model.dart';
import 'package:http/http.dart' as http;
import '../login_signup/API/api.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../widgets/responsive_button.dart';
import 'dashboard.dart';

class UniversityPage extends StatefulWidget {
  final LoginUser loginuserid;

  get loginUser => LoginUser;
  UniversityPage({
    required this.loginuserid,
  });
  @override
  _UniversityPageState createState() => _UniversityPageState();
}

class _UniversityPageState extends State<UniversityPage> {
  TextEditingController universityNameController = TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController admissionlink = TextEditingController();
  TextEditingController SurroundedCityController = TextEditingController();
  List<String> enteredValues = [];
  final List<String> cities = [
    "Abbottabad",
    "Badin",
    "Bahawalpur",
    "Bannu",
    "Bhakkar",
    "Burewala",
    "Chakwal",
    "Chaman",
    "Chiniot",
    "Chishtian",
    "Dadu",
    "Daska",
    "Depalpur",
    "Dera Ghazi Khan",
    "Dera Ismail Khan",
    "Dhanote",
    "Faisalabad",
    "Fateh Jang",
    "Gakhar Mandi",
    "Gojra",
    "Ghotki",
    "Gujranwala",
    "Gujrat",
    "Haripur",
    "Hafizabad",
    "Hyderabad",
    "Islamabad",
    "Jacobabad",
    "Jampur",
    "Jaranwala",
    "Jatoi",
    "Jauharabad",
    "Jhang",
    "Jhelum",
    "Kallar Syedan",
    "Kamoke",
    "Kamalia",
    "Karachi",
    "Kasur",
    "Khanewal",
    "Khairpur",
    "Khairpur Tamewali",
    "Kharian",
    "Khushab",
    "Kohat",
    "Kot Adu",
    "Kotri",
    "Kundian",
    "Lahore",
    "Lala Musa",
    "Larkana",
    "Loralai",
    "Malakwal",
    "Mansehra",
    "Mardan",
    "Mamoori",
    "Mian Channu",
    "Mianwali",
    "Mingora",
    "Mirpur Khas",
    "Morro",
    "Multan",
    "Muridke",
    "Muzaffarabad",
    "Muzaffargarh",
    "Nawabshah",
    "Nowshera",
    "Okara",
    "Pakpattan",
    "Peshawar",
    "Pattoki",
    "Quetta",
    "Rahim Yar Khan",
    "Rawalakot",
    "Rawalpindi",
    "Sadiqabad",
    "Sahiwal",
    "Sargodha",
    "Sheikhupura",
    "Shikarpur",
    "Sialkot",
    "Sukkur",
    "Swabi",
    "Swat",
    "Tando Allahyar",
    "Tando Adam",
    "Taxila",
    "Thatta",
    "Timargara",
    "Toba Tek Singh",
    "Turbat",
    "Vehari",
    "Wah Cantt",
    "Wazirabad",
    "Zhob"
  ];

  int _currentIndex = 0;
  XFile? _image;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    loginuserid: loggedInUni!,
                  )));
    } else if (_currentIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NotificationScreen(
                    type: '',
                  )));
    } else if (_currentIndex == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard(
                    loginuserid: loggedInUni!,
                  )));
    }
  }

  Future<void> addToDatabase() async {
    try {
      final response = await http.post(
        Uri.parse('${ip}/University/Addnearcity?uid=$uid'),
        body: {'uid': uid.toString(), 'city': SurroundedCityController.text},
      );

      if (response.statusCode == 200) {
        print('Value added to the database successfully');
      } else {
        print(
            'Failed to add value to the database. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _image = XFile(pickedImage.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/UPS.png', width: 40, height: 40),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: universityNameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter University',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller:
                            cityNameController, // Corrected variable name
                        decoration: InputDecoration(
                          hintText: 'Enter City Name',
                          /*border: OutlineInputBorder(),*/
                          filled: false,
                          fillColor: Colors.white,
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return cities.where((city) =>
                            city.toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        if (suggestion is String) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        } else {
                          // Handle the case where suggestion is not a String
                          return ListTile(
                            title: Text('Invalid suggestion type'),
                          );
                        }
                      },
                      onSuggestionSelected: (suggestion) {
                        if (suggestion is String) {
                          print('Selected: $suggestion');
                          cityNameController.text =
                              suggestion; // Set the selected suggestion to the controller
                        } else {
                          // Handle the case where suggestion is not a String
                          print(
                              'Invalid suggestion type: ${suggestion.runtimeType}');
                        }
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller:
                            SurroundedCityController, // Corrected variable name
                        decoration: InputDecoration(
                          hintText: 'Enter Surrounded Cities',
                          /*border: OutlineInputBorder(),*/
                          filled: false,
                          fillColor: Colors.white,
                        ),
                      ),
                      suggestionsCallback: (pattern) async {
                        return cities.where((city) =>
                            city.toLowerCase().contains(pattern.toLowerCase()));
                      },
                      itemBuilder: (context, suggestion) {
                        if (suggestion is String) {
                          return ListTile(
                            title: Text(suggestion),
                          );
                        } else {
                          // Handle the case where suggestion is not a String
                          return ListTile(
                            title: Text('Invalid suggestion type'),
                          );
                        }
                      },
                      onSuggestionSelected: (suggestion) {
                        if (suggestion is String) {
                          print('Selected: $suggestion');
                          SurroundedCityController.text =
                              suggestion; // Set the selected suggestion to the controller
                        } else {
                          // Handle the case where suggestion is not a String
                          print(
                              'Invalid suggestion type: ${suggestion.runtimeType}');
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      // Add the value to the list and send it to the database when the plus button is clicked
                      setState(() {
                        enteredValues.add(SurroundedCityController.text);
                        addToDatabase();
                        SurroundedCityController.clear();
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Display entered values below the TextField
              Container(
                height: 100, // Adjust the height as needed
                child: ListView.builder(
                  itemCount: enteredValues.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(enteredValues[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () async {
                      await _pickImageFromGallery();
                    },
                    child: const Text('Pick from Gallery'),
                  ),
                  const SizedBox(width: 10.0),
                  _image != null
                      ? Image.file(
                          File(_image!.path),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Placeholder(
                          fallbackHeight: 50,
                          fallbackWidth: 50,
                        ),
                ],
              ),
              const SizedBox(height: 50),

              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    AddUni au = AddUni(
                      uid: widget.loginuserid.uid,
                      u_name: universityNameController.text,
                      city: cityNameController.text,
                      image: _image?.path ?? '',
                    );

                    if (_image != null) {
                      au.image = _image!.path;
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Failed to pick an image. Please try again.'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }

                    int code = await APIHandler()
                        .addUniversity(au, File(_image!.path));

                    if (code == 200) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(''),
                            content: const Text('Data saved successfully.'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddDegree(
                                          loginuserid: loggedInUni!, uid: uid),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const AlertDialog(
                            title: Text('Data not saved!'),
                          );
                        },
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
        selectedItemColor: const Color(0xFF5d69b3),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My',
          ),
        ],
      ),
    );
  }
}
