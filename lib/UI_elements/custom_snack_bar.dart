import 'package:flutter/material.dart';

import 'color.dart';

class CustomSnackBar extends StatelessWidget {
  final String text;
  CustomSnackBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(text),
      backgroundColor: primaryColor,
      shape: StadiumBorder(),
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      behavior: SnackBarBehavior.floating,
    );
  }
}
