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

Future<void> addTeamDialog(BuildContext context, Function(String) onAdded) async {

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
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            child: const  Text('Add Team'),
            onPressed: () {
              onAdded(teamName.isEmpty ? 'My Team' : teamName);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> editTeamDialog(BuildContext context, String currentTeamName, Function(String) onEdited) async {

  String teamName = currentTeamName;

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Edit Team'),
        content: TextField(
          onChanged: (value) {
            teamName = value;
          },
          controller: TextEditingController()..text = currentTeamName,
          decoration: const InputDecoration(
            labelText: 'Team Name',
          ),
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
              onEdited(teamName.isEmpty ? currentTeamName : teamName);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> deleteTeamDialog(BuildContext context, Function onDelete) async {

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Team?'),
        content: const Text('Are you sure you want to delete this team? This action cannot be undone.'),
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