import 'package:flutter/material.dart';
import 'package:habit_tracker/UI_elements/text_styles.dart';

import 'color.dart';

class PrimaryButton extends StatelessWidget {
  final String text;

  PrimaryButton({required this.text});
  @override

  Widget build(BuildContext context) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text16Medium(
        text: text,
        color: Colors.white,
      ),
    );
  }
}
