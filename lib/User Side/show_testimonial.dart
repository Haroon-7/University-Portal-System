import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:ups/Global/Global.dart';
import 'package:ups/widgets/responsive_button.dart';

import '../Global/Global.dart';

class ShowTestimonial extends StatefulWidget {
  final int uid;

  const ShowTestimonial({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ShowTestimonial> createState() => _ShowTestimonialState();
}

class _ShowTestimonialState extends State<ShowTestimonial> {
  List<Map<String, dynamic>> testinomial = [];
  List<Map<String, dynamic>> Reviews = [];
  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final String apiUrl = '$ip/Task/viewtestinomial';

    try {
      final response = await http.get(Uri.parse('$apiUrl?uid=${widget.uid}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          testinomial = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<void> AddReview() async {
    try {
      print('Adding review...');
      if (commentController.text.isNotEmpty) {
        // Create a FormData object
        var formData = http.MultipartRequest(
            'POST', Uri.parse('$ip/Task/Addreview?tid=${tid}'));
        // Add your fields to FormData
        formData.fields
            .addAll({'tid': tid.toString(), 'review': commentController.text});
        // Send the request
        var response = await formData.send();
        // Check the response
        if (response.statusCode == 200) {
          // Parse the response
          var responseData = await response.stream.bytesToString();
          var data = json.decode(responseData);
          print('Review updated successfully: $data');
        } else {
          print('Failed to update Review: ${response.statusCode}');
        }
      } else {
        print('Review is empty');
      }
    } catch (error) {
      print('Error updating Review: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Testinomials'),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Show dialog for adding review
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Add Review'),
                    content: SizedBox(
                      child: Column(
                        children: [
                          TextField(
                            controller: commentController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Enter your review...',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ResponsiveButton(
                        onPressed: AddReview,
                        requiredText: ' Add ',
                        height: 20,
                        width: 100,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Review'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: testinomial.length,
        itemBuilder: (context, index) {
          final scholarship = testinomial[index];
          return ListTile(
            title: Text(
              scholarship['Currentlydoing'],
            ),
            subtitle: Text(scholarship['Testinomial']),
            trailing: (Text(
              scholarship['review'],
            )),
            leading: Text(
              scholarship['name'],
            ),
          );
        },
      ),
    );
  }
}
