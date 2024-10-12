import 'package:flutter/material.dart';

import 'loading.dart';
import 'home.dart';
import 'court.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/'     : (context) => Loading(),
      '/home' : (context) => Home(),
      '/court': (context) => Court(),
    },
  ));
}
