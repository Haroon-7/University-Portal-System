import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ups/Global/Global.dart';

import 'package:http/http.dart' as http;

class Rating extends StatefulWidget {
  final int uid;
  const Rating({Key? key, required this.uid}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class Review {
  final String userName;
  final double rating;
  final String comment;

  Review(this.userName, this.rating, this.comment);
}

class _RatingState extends State<Rating> {
  @override
  void initState() {
    super.initState();
    fetchData();
    TotalRating();
  }

  List<Review> reviewslist = [];

  Future<void> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('$ip/Possibletask/getRatings?uid=${widget.uid}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        List<Review> data = responseData.map((item) {
          return Review(
            item['name'],
            item['Rating'].toDouble(),
            item['Reviews'],
          );
        }).toList();

        setState(() {
          reviewslist = data;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  double? totalRate = 0;
  Future<void> TotalRating() async {
    try {
      final response = await http
          .get(Uri.parse('$ip/Possibletask/getTotalRatings?uid=${widget.uid}'));

      if (response.statusCode == 200) {
        final double responseData = json.decode(response.body);

        setState(() {
          totalRate = responseData;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  addreview(int? usid, String? reviews, int? rating, int? Uid, context) async {
    var request = await http.post(
      Uri.parse('$ip/Possibletask/AddReview?uid=$Uid&Usid=$usid'),
      body: {
        'Reviews': reviews,
        'rating': rating.toString(),
      },
    );
    if (request.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Review Added Successfully"),
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Review Not Added"),
        ),
      );
    }
  }

  TextEditingController reviewController = TextEditingController();
  double rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate University'),
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
                      height: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        children: [
                          RatingBar.builder(
                            itemSize: 25,
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
                          ),
                          TextField(
                            controller: reviewController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'Enter your review...',
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          // Handle review submission logic here
                          print('User rated $rating stars');
                          print('Review: ${reviewController.text}');
                          await addreview(
                              loggedInUser!.Usid,
                              reviewController.text,
                              rating.toInt(),
                              widget.uid,
                              context);
                          Navigator.pop(context); // Close the dialog
                        },
                        child: const Text('OK'),
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
            child: const Text('Rate'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Total Rating: "),
                  RatingBar.builder(
                    itemSize: 20,
                    initialRating: totalRate!,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: true,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.96,
              child: ListView.builder(
                itemCount: reviewslist.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('${reviewslist[index].userName}'),
                      subtitle: Column(
                        children: [
                          RatingBar.builder(
                            itemSize: 20,
                            initialRating: reviewslist[index].rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (newRating) {
                              setState(() {
                                rating = newRating;
                              });
                            },
                          ),
                          Text(
                            reviewslist[index].comment,
                            maxLines: 4,
                          ),
                        ],
                      ),
                      // You can add more details like date, etc. as needed.
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
