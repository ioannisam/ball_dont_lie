import 'package:flutter/material.dart';

List<Color> basicColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.purple,
  Colors.pink,
  Colors.brown,
  Colors.grey,
  Colors.teal,
  Colors.cyan,
  Colors.lime,
  Colors.white,
  Colors.black,
];

Widget colorBlob(Color color, VoidCallback onPressed) {
  return GestureDetector(
    onTap: onPressed,
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.black, width: 1),
      ),
    ),
  );
}