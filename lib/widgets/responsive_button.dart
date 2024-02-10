import 'package:flutter/material.dart';
import 'package:ups/misc/colors.dart';

import '../misc/colors.dart';

class ResponsiveButton extends StatelessWidget {
  final double? width;
  final double height;
  final bool? isResponsive;
  final String requiredText;
  final VoidCallback? onPressed; // Add an onPressed callback

  const ResponsiveButton({
    Key? key,
    this.width,
    this.isResponsive = false,
    required this.requiredText,
    this.onPressed, required this.height, // Initialize the onPressed callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Handle tap event with the provided onPressed callback
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.lightBlue,
        ),
        child: Center(
          child: Text(
            requiredText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
