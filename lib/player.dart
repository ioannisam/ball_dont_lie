import 'package:flutter/material.dart';

class Player {
  String name;
  String position;
  double playingTime;
  int points;
  int assists;
  int rebounds;
  int blocks;
  int steals;
  int twoPointAttempts;
  int threePointAttempts;

  Player({
    required this.name,
    required this.position,
    this.playingTime = 0.0,
    this.points = 0,
    this.assists = 0,
    this.rebounds = 0,
    this.blocks = 0,
    this.steals = 0,
    this.twoPointAttempts = 0,
    this.threePointAttempts = 0,
  });
}

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


Future<void> editPlayerDialog(BuildContext context, Player currentPlayer, Function(Player) onEdited) async {
  String playerName = currentPlayer.name;
  String playerPosition = currentPlayer.position;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Player'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: (value) {
                playerName = value;
              },
              controller: TextEditingController()..text = currentPlayer.name,
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
            child: const Text('Save'),
            onPressed: () {
              onEdited(Player(
                name: playerName.isEmpty ? currentPlayer.name : playerName,
                position: playerPosition,
              ));
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


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
              onDelete(); // Call the delete action function
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
