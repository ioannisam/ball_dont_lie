import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ball Dont Lie'),
          backgroundColor: Colors.orange,
          centerTitle: true,
        ),
        body: Center(
          child: Text('Count your stats!'),
        ),
      ),
    );
  }
}
