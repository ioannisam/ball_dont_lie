import 'package:flutter/material.dart';
import 'player.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

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

Future<void> editTeamDialog(BuildContext context, String currentTeamName, Function(String, String) onEdited) async {
  String teamName = currentTeamName;
  String? selectedLogoPath; // Holds the path to the selected logo
  final picker = ImagePicker();

  // Initialize the TextEditingController
  final TextEditingController teamNameController = TextEditingController(text: currentTeamName);

  Future<void> _pickLogo(Function setState) async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null && context.mounted) { // Check if context is still valid
        setState(() {
          selectedLogoPath = pickedFile.path; // Update image path safely
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  return showDialog(
    
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Team'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: teamNameController,
                  decoration: const InputDecoration(
                    labelText: 'Team Name',
                  ),
                ),
                const SizedBox(height: 20),
                selectedLogoPath != null
                    ? Image.file(File(selectedLogoPath!), width: 100, height: 100)
                    : Image.asset('assets/logo.png', width: 100, height: 100),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _pickLogo(setState);
                  },
                  child: const Text('Pick Team Logo'),
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
                  onEdited(teamNameController.text.isEmpty ? currentTeamName : teamNameController.text, selectedLogoPath ?? 'assets/logo.png');
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  ).whenComplete(() {
    teamNameController.dispose();
  });
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
              onDelete();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}