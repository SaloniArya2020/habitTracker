import 'package:flutter/material.dart';

class Text16Medium extends StatelessWidget {
  final String text;
  final Color color;
  Text16Medium({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w500),);
  }
}

class Text18Medium extends StatelessWidget {
  final String text;
  final Color color;
  Text18Medium({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w500),);
  }
}

class Text16Bold extends StatelessWidget {
  final String text;
  final Color color;
  Text16Bold({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600),);
  }
}

class Text18Bold extends StatelessWidget {
  final String text;
  final Color color;
  Text18Bold({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w600),);
  }
}
