import 'package:flutter/material.dart';
import 'package:ball_dont_lie/player/player.dart';

Future<void> addPlayerDialog(BuildContext context, Function(Player) onAdded) async {
  
  String playerName = 'New Player';
  String playerPosition = 'PG';

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add a Player'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                playerName = value;
              },
              controller: TextEditingController()..text = 'New Player',
              decoration: const InputDecoration(
                labelText: 'Player Name',
              ),
            ),
            DropdownButtonFormField<String>(
              value: playerPosition,
              onChanged: (newPosition) {
                playerPosition = newPosition!;
              },
              items: const [
                DropdownMenuItem(value: 'PG', child: Text('Point Guard (PG)')),
                DropdownMenuItem(value: 'SG', child: Text('Shooting Guard (SG)')),
                DropdownMenuItem(value: 'SF', child: Text('Small Forward (SF)')),
                DropdownMenuItem(value: 'PF', child: Text('Power Forward (PF)')),
                DropdownMenuItem(value: 'C', child: Text('Center (C)')),
              ],
              decoration: const InputDecoration(
                labelText: 'Position',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Add Player'),
            onPressed: () {
              onAdded(Player(name: playerName, position: playerPosition));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
