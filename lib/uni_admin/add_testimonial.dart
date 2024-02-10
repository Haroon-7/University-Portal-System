import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:ups/Global/Global.dart';
import 'package:ups/Global/Global.dart';
import 'package:ups/login_signup/Model/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:ups/widgets/responsive_button.dart';

import '../Global/Global.dart';

class Testimonial extends StatefulWidget {
  final LoginUser loginuserid;
  final int uid;

  const Testimonial({
    Key? key,
    required this.loginuserid,
    required this.uid,
  }) : super(key: key);

  @override
  State<Testimonial> createState() => _TestimonialState();
}

class _TestimonialState extends State<Testimonial> {
  TextEditingController nameController = TextEditingController();
  TextEditingController CurrentlydoingController = TextEditingController();
  TextEditingController TestinomialController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear text controllers when the page is re-entered
    nameController.clear();
    CurrentlydoingController.clear();
    TestinomialController.clear();
  }

  @override
  void dispose() {
    nameController.clear();
    CurrentlydoingController.clear();
    TestinomialController.clear();
    super.dispose();
  }

  void _addAnother() async {
    try {
      String name = nameController.text;
      String Currentlydoing = CurrentlydoingController.text;
      String Testinomial = TestinomialController.text;

      Map<String, dynamic> requestData = {
        'uid': widget.loginuserid.uid.toString(),
        'Currentlydoing': Currentlydoing,
        'name': name,
        'Testinomial': Testinomial
      };

      final response = await http.post(
        Uri.parse('$ip/Task/AddTestnmial?uid=${widget.loginuserid.uid}'),
        body: requestData,
      );

      if (response.statusCode == 200) {
        nameController.clear();
        CurrentlydoingController.clear();
        TestinomialController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Successfully'),
              content: Text('Testimonial added successfully.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Failed'),
              content: Text('Add Failed. Please provide valid Credentials.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Alumni Success Stories'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Image.asset('assets/UPS.png', width: 40, height: 40),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Name',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: CurrentlydoingController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Currently Work',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: TestinomialController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Testimonials',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(width: 120),
                  ResponsiveButton(
                    onPressed: _addAnother,
                    requiredText: ' Add ',
                    height: 40,
                    width: 100,
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}
