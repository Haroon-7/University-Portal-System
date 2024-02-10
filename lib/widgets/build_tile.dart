import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTile(String imagePath, String label, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Image.asset(
            imagePath,
            height: 100, // Adjust the height as needed
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }