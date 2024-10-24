import 'package:flutter/material.dart';
import 'package:ball_dont_lie/widgets/snackbar.dart';

Future<void> deletePlayerDialog(BuildContext context, Function() onDeleted) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Player'),
        content: const Text('Are you sure you want to delete this player?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              onDeleted();
              showSnackbar(context, "Player deleted successfully!", Colors.black87);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}