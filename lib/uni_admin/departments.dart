import 'package:flutter/material.dart';
import 'package:ups/login_signup/Model/login_model.dart';

class Departments extends StatefulWidget {
  const Departments({
    Key? key,
  }) : super(key: key);

  @override
  State<Departments> createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  List<String> departments = [];
  final TextEditingController _departmentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Departments'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _departmentController,
              decoration: InputDecoration(
                labelText: 'Enter Department Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addDepartment(_departmentController.text);
            },
            child: Text('Add Department'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: departments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(departments[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void addDepartment(String departmentName) {
    if (departmentName.isNotEmpty) {
      setState(() {
        departments.add(departmentName);
        _departmentController.clear();
      });
    }
  }
}
