import 'package:flutter/material.dart';

import 'screens/loading.dart';
import 'screens/home.dart';
import 'screens/settings.dart';
import 'screens/court.dart';
import 'screens/info.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/loading',
    routes: {
      '/loading'      : (context) => Loading(),
      '/home'         : (context) => Home(),
      '/home/court'   : (context) => Court(),
      '/home/settings': (context) => Settings(),
      '/home/info'    : (context) => Info(),
    },
  ));
}