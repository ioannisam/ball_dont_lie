import 'package:flutter/material.dart';
import 'package:ball_dont_lie/player/player.dart';

Future<void> deletePlayerDialog(BuildContext context, Function onDelete) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Player?'),
        content: const Text('Are you sure you want to delete this player? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}