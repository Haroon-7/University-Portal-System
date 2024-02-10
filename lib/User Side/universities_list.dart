import 'package:flutter/material.dart';
import 'package:ups/Global/Global.dart'; // Import the Global.dart file
import 'package:ups/User%20Side/sponserd_uni_details.dart';
import 'package:ups/navpages/Search.dart';
import 'package:ups/navpages/user_notifications.dart';
import '../hec_admin/show_programs.dart';
import 'details.dart';

class User extends StatefulWidget {
  final List<Map<String, dynamic>> searchData;
  int? progid;

  User({
    Key? key,
    required this.searchData,
    required this.progid,
  }) : super(key: key);

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SearchPage()));
    } else if (_currentIndex == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserNotifications()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug prints to check the 'IS_Sponser' values
    for (final item in widget.searchData) {
      print('${item['u_name']} - IS_Sponser: ${item['IS_Sponser']}');
    }

    // Placeholder for global variables
    // Replace with the actual value
    /* String City = 'Some City'; // Replace with the actual value
    double fee = 0.0; // Replace with the actual value
    String Stype = 'Some Type'; */ // Replace with the actual value

    // Separate sponsor and non-sponsor universities
    List<Map<String, dynamic>> sponsorUniversities = widget.searchData
        .where((item) => item['IS_Sponser'] == 'true')
        .toList();
    List<Map<String, dynamic>> nonSponsorUniversities = widget.searchData
        .where((item) =>
            item['IS_Sponser'] !=
            'true') /*.map((item) {
      // Adding additional global items to each item in the list
      item['programId'] = proid;
      item['City'] = City;
      item['fee'] = fee;
      item['Stype'] = Stype;
      return item;
    })*/
        .toList();

    bool showSeparator =
        sponsorUniversities.isNotEmpty && nonSponsorUniversities.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities List'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (sponsorUniversities.isNotEmpty)
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: sponsorUniversities.length,
                      itemBuilder: (context, index) {
                        final item = sponsorUniversities[index];
                        return GestureDetector(
                          onTap: () {
                            int uid = item['uid'] ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UniversityDetailPage(
                                  universityName:
                                      item['u_name'] ?? 'Unknown University',
                                  // proid: proid,
                                  progid: widget.progid,
                                  uid: uid,
                                  isSponsor: true,
                                  url: item['url'] ?? 'Unknown url',
                                ),
                              ),
                            );
                          },
                          child: buildUniversityCard(
                            item,
                            isSponsor: true,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: nonSponsorUniversities.length,
                itemBuilder: (context, index) {
                  final item = nonSponsorUniversities[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UniversityDetailPage(
                            universityName:
                                item['u_name'] ?? 'Unknown University',
                            uid: item['uid'] ?? 'Unknown id',
                            progid: widget.progid,
                            isSponsor: false,
                            url: item['url'] ?? 'Unknown url',
                          ),
                        ),
                      );
                    },
                    child: buildUniversityCard(
                      item,
                      isSponsor: false,
                    ),
                  );
                },
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
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  Widget buildUniversityCard(Map<String, dynamic> item,
      {required bool isSponsor}) {
    String universityName = item['u_name'] ?? 'Unknown University';
    String city = item['city'] ?? 'Unknown City';
    String universityImage = item['image'] ?? 'image';
    var ImageURL =
        "http://192.168.43.217/UniversityPortalSystem/Content/universityimages/";
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    universityName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(city),
                  if (isSponsor)
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: const Text(
                        'Sponsored',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: SizedBox(
                width: 50,
                height: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    ImageURL + universityImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
