import 'package:flutter/material.dart';
import 'player.dart';

class Team {

  String name;
  String image;
  String logo;
  List<Player> players;

  Team({required this.name, required this.image, required this.logo}) : players = [];

  void addPlayer(Player player) {
    players.add(player);
  }

  void removePlayer(Player player) {
    players.remove(player);
  }

  

  void deleteTeam() {
    // Here you can define what happens when you delete a team.
    // For now, we will just clear the players list.
    players.clear();
    // Additional cleanup or deletion logic can be added here.
  }
}

Future<void> addTeamDialog(BuildContext context, Function(String) onTeamAdded) async {

    String teamName = 'My Team';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add a Team'),
          content: TextField(
            onChanged: (value) {
              teamName = value;
            },
            controller: TextEditingController()..text = 'My Team',
            decoration: const InputDecoration(
              labelText: 'Team Name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const  Text('Add Team'),
              onPressed: () {
                onTeamAdded(teamName.isEmpty ? 'My Team' : teamName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }