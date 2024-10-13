import 'package:flutter/material.dart';

import 'loading.dart';
import 'home.dart';
import 'settings.dart';
import 'court.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/loading',
    routes: {
      '/loading'      : (context) => Loading(),
      '/home'         : (context) => Home(),
      '/home/court'   : (context) => Court(),
      '/home/settings': (context) => Settings(),
    },
  ));
}
