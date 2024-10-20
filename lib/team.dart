import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ball_dont_lie/player.dart';
import 'package:ball_dont_lie/snackbar.dart';

class Team {
  String name;
  String logo;
  List<Player> players;

  Team({required this.name, required this.logo}) : players = [];

  void addPlayer(Player player) {
    players.add(player);
  }

  void removePlayer(Player player) {
    players.remove(player);
  }

  void deleteTeam() {
    players.clear();
  }
}

String getNextTeamName(List<Team> existingTeams) {
  int k = 1;
  String newTeamName = 'My Team $k';

  while (existingTeams.any((team) => team.name.toLowerCase() == newTeamName.toLowerCase())) {
    k++;
    newTeamName = 'My Team $k';
  }
  return newTeamName;
}


Future<void> addTeamDialog(BuildContext context, Function(String, String) onAdded, List<Team> existingTeams) async {
  String teamName = getNextTeamName(existingTeams);
  String? selectedLogoPath = 'assets/logo.png';
  final picker = ImagePicker();

  List<String> predefinedLogos = [
    'assets/logo.png',
    'assets/ball2.png',
  ];

  Future<void> _pickLogo(Function setState) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedLogoPath = image.path;
        });
      }
    } catch (e) {
      print("Error picking logo: $e");
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Team'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: teamName,
                  onChanged: (value) {
                    teamName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Team Name'),
                ),
                const SizedBox(height: 20),
                const Text("Add a logo"),
                DropdownButton<String>(
                  value: predefinedLogos.contains(selectedLogoPath) ? selectedLogoPath : null,
                  hint: const Text("Select a logo"),
                  items: predefinedLogos.map((String logo) {
                    return DropdownMenuItem<String>(
                      value: logo,
                      child: Text(logo.split('/').last),
                    );
                  }).toList()
                  ..add(
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text("Choose your own logo..."),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      _pickLogo(setState);
                    } else {
                      setState(() {
                        selectedLogoPath = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                selectedLogoPath != null
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: selectedLogoPath!.startsWith('assets')
                            ? Image.asset(
                                selectedLogoPath!,
                                width: 100,
                                height: 100,
                              )
                            : Image.file(
                                File(selectedLogoPath!),
                                width: 100,
                                height: 100,
                              ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  bool teamExists = existingTeams.any((team) => team.name.toLowerCase() == teamName.toLowerCase());
                  
                  if (teamName.trim().isEmpty) {
                    showSnackbar(context, "Team name can't be empty!", Colors.red);
                  } else if (teamExists) {
                    showSnackbar(context, "A team with this name already exists!", Colors.red);
                  } else {
                    onAdded(teamName, selectedLogoPath ?? 'assets/logo.png');
                    showSnackbar(context, "Team added successfully!", Colors.deepPurple);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> editTeamDialog(
  BuildContext context,
  String oldTeamName,
  Function(String, String) onEdit,
  List<Team> existingTeams,
) async {
  String newTeamName = oldTeamName;
  String? selectedLogoPath = 'assets/logo.png';
  final picker = ImagePicker();

  List<String> predefinedLogos = [
    'assets/logo.png',
    'assets/ball2.png',
  ];

  Future<void> _pickLogo(Function setState) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedLogoPath = image.path;
        });
      }
    } catch (e) {
      print("Error picking logo: $e");
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Team'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: newTeamName,
                  onChanged: (value) {
                    newTeamName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Team Name'),
                ),
                const SizedBox(height: 20),
                const Text("Add a logo"),
                DropdownButton<String>(
                  value: predefinedLogos.contains(selectedLogoPath) ? selectedLogoPath : null,
                  hint: const Text("Select a logo"),
                  items: predefinedLogos.map((String logo) {
                    return DropdownMenuItem<String>(
                      value: logo,
                      child: Text(logo.split('/').last),
                    );
                  }).toList()
                  ..add(
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text("Choose your own logo..."),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      _pickLogo(setState);
                    } else {
                      setState(() {
                        selectedLogoPath = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                selectedLogoPath != null
                    ? Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.deepPurple, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: selectedLogoPath!.startsWith('assets')
                            ? Image.asset(
                                selectedLogoPath!,
                                width: 100,
                                height: 100,
                              )
                            : Image.file(
                                File(selectedLogoPath!),
                                width: 100,
                                height: 100,
                              ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  bool teamExists = existingTeams
                      .where((team) => team.name.toLowerCase() != oldTeamName.toLowerCase())
                      .any((team) => team.name.toLowerCase() == newTeamName.toLowerCase());

                  if(newTeamName.trim().isEmpty) {
                    showSnackbar(context, "Team name can't be empty!", Colors.red);
                  } else if (teamExists) {
                    showSnackbar(context, "A team with this name already exists!", Colors.red);
                  } else {
                    onEdit(newTeamName, selectedLogoPath ?? 'assets/logo.png');
                    showSnackbar(context, "Team edited successfully!", Colors.deepPurple);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> deleteTeamDialog(BuildContext context, Function() onDeleted) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Team'),
        content: const Text('Are you sure you want to delete this team?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDeleted();
              showSnackbar(context, "Team deleted successfully!", Colors.black87);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}