import 'package:flutter/material.dart';

class CategoryColorHelper {
  static final List<(Color bg, Color text)> _colors = [
    (const Color(0xFFFFF9C4), const Color(0xFFFBC02D)), // Yellow/Orange
    (
      const Color(0xFFE8F5E9),
      const Color(0xFF66BB6A),
    ), // Light Green/Dark Green
    (const Color(0xFFE3F2FD), const Color(0xFF42A5F5)), // Light Blue/Blue
    (const Color(0xFFFFEBEE), const Color(0xFFEF5350)), // Light Red/Red
    (const Color(0xFFF3E5F5), const Color(0xFFAB47BC)), // Light Purple/Purple
    (const Color(0xFFE0F7FA), const Color(0xFF26C6DA)), // Cyan
  ];

  static (Color bg, Color text) getColors(int index) {
    if (_colors.isEmpty) {
      return (Colors.grey[200]!, Colors.grey[800]!);
    }
    return _colors[index % _colors.length];
  }
}
