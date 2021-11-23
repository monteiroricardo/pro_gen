import 'package:flutter/material.dart';

class SizeHelper {
  static double height(double value, BuildContext context) {
    return (MediaQuery.of(context).size.height * value) / 100;
  }

  static double width(double value, BuildContext context) {
    return (MediaQuery.of(context).size.width * value) / 100;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }
}
