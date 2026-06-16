import 'package:flutter/material.dart';

class CoreFonts {
  const CoreFonts._();

  static const String russoOne = 'RussoOne';
  static const Color textColor = Color.fromRGBO(10, 10, 10, 1);

  static const TextStyle title = TextStyle(
    fontFamily: russoOne,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle body = TextStyle(
    fontFamily: russoOne,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textColor,
  );
}
