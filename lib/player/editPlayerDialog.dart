import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ball_dont_lie/player/player.dart';
import 'package:ball_dont_lie/widgets/snackbar.dart';

Future<void> editPlayerDialog(
    BuildContext context, 
    Player currentPlayer, 
    Function(String, String, String?, int, double) onEdit, 
    List<Player> existingPlayers) async {
  
  String playerName = currentPlayer.name;
  String playerPosition = currentPlayer.position;
  String? playerIcon = currentPlayer.icon;
  int playerJersey = currentPlayer.jersey;
  double playerHeight = currentPlayer.height;

  final picker = ImagePicker();

  List<String> predefinedIcons = [
    'assets/logo.png',
    'assets/ball2.png',
  ];

  Future<void> _pickIcon(Function setState) async {
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          playerIcon = image.path;
        });
      }
    } catch (e) {
      print("Error picking icon: $e");
    }
  }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Edit Player'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: playerName,
                  onChanged: (value) {
                    playerName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: playerJersey.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    playerJersey = int.tryParse(value) ?? playerJersey;
                  },
                  decoration: const InputDecoration(labelText: 'Jersey Number'),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  initialValue: playerHeight.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    playerHeight = double.tryParse(value) ?? playerHeight;
                  },
                  decoration: const InputDecoration(labelText: 'Height (m)'),
                ),
                const SizedBox(height: 20),
                const Text("Add an icon"),
                DropdownButton<String>(
                  value: predefinedIcons.contains(playerIcon) ? playerIcon : null,
                  hint: const Text("Select an icon"),
                  items: predefinedIcons.map((String icon) {
                    return DropdownMenuItem<String>(
                      value: icon,
                      child: Text(icon.split('/').last),
                    );
                  }).toList()
                  ..add(
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text("Choose your own icon..."),
                    ),
                  ),
                  onChanged: (String? newValue) {
                    if (newValue == null) {
                      _pickIcon(setState);
                    } else {
                      setState(() {
                        playerIcon = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                playerIcon != null
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
                        child: playerIcon!.startsWith('assets')
                            ? Image.asset(
                                playerIcon!,
                                width: 100,
                                height: 100,
                              )
                            : Image.file(
                                File(playerIcon!),
                                width: 100,
                                height: 100,
                              ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  bool playerExists = existingPlayers.any(
                    (existingPlayer) =>
                        existingPlayer.name.toLowerCase() == playerName.toLowerCase() &&
                        existingPlayer != currentPlayer,
                  );

                  if (playerName.trim().isEmpty) {
                    showSnackbar(context, "Player name can't be empty!", Colors.red);
                  } else if (playerExists) {
                    showSnackbar(context, "A player with this name already exists!", Colors.red);
                  } else {
                    onEdit(playerName, playerPosition, playerIcon, playerJersey, playerHeight);
                    showSnackbar(context, "Player edited successfully!", Colors.deepPurple);
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
