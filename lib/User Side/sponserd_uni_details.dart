// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:ups/Global/Global.dart';
// import 'package:ups/User%20Side/admission.dart';
// import 'package:ups/User%20Side/faculty.dart';
// import 'package:ups/User%20Side/programs.dart';
// import 'package:ups/User%20Side/scholarship.dart';
// import '../Global/Global.dart';
// import '../Global/Global.dart';
// import '../hec_admin/show_programs.dart';
// import 'package:http/http.dart' as http;

// class SponseredUniversityDetailPage extends StatefulWidget {
//   late final String universityName;
//   final int uid;
//   final int progid;
//   bool? isSponsor;

//   SponseredUniversityDetailPage({
//     Key? key,
//     required this.universityName,
//     required this.uid,
//     required this.progid,
//     required this.isSponsor,
//   }) : super(key: key);

//   @override
//   State<SponseredUniversityDetailPage> createState() =>
//       _UniversityDetailsPageState();
// }

// class _UniversityDetailsPageState extends State<SponseredUniversityDetailPage> {
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // Fetch the user program data on initialization
//   //   viewUserProgram();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('University Details'),
//         centerTitle: true,
//         actions: const [
//           // Add a Text widget displaying the university name
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => Programs(
//                       universityName: widget.universityName,
//                       uid: widget.uid,
//                       proid: widget.progid,
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(200, 50),
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 'Programs',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => Scholarship(
//                         universityName: widget.universityName, uid: widget.uid),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(200, 50),
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 'Scholarships',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => Faculty(
//                         universityName: widget.universityName, uid: widget.uid),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(200, 50),
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 'Faculty',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) =>
//                         Admission(universityName: widget.universityName),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 fixedSize: const Size(200, 50),
//                 padding: const EdgeInsets.all(16),
//               ),
//               child: const Text(
//                 'Admission',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
