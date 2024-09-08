import 'package:flutter/material.dart';

extension HexColor on String {
  Color toColor() {
    final hexString = this.replaceAll('#', '');
    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16)); // Add alpha value
    } else if (hexString.length == 8) {
      return Color(int.parse(hexString, radix: 16));
    } else {
      throw Exception('Invalid hex color');
    }
  }
}
