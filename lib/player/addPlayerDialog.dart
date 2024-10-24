import 'package:flutter/material.dart';
import 'package:ball_dont_lie/player/player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:ball_dont_lie/widgets/snackbar.dart';
import 'dart:io';

String getNextPlayerName(List<Player> existingPlayers) {
  int k = 1;
  String newPlayerName = 'My Player $k';

  while (existingPlayers.any((player) => player.name.toLowerCase() == newPlayerName.toLowerCase())) {
    k++;
    newPlayerName = 'My Player $k';
  }
  return newPlayerName;
}

Future<void> addPlayerDialog(
    BuildContext context, 
    Function(String, String, String?, int, double) onAdded,
    List<Player> existingPlayers) async {
  
  String playerName = getNextPlayerName(existingPlayers);
  String playerPosition = 'PG';
  String? playerIcon = 'assets/logo.png';
  final picker = ImagePicker();
  int playerJersey = 0;
  double playerHeight = 1.83;

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

  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add a Player'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Player Name
                TextFormField(
                  initialValue: playerName,
                  onChanged: (value) {
                    playerName = value;
                  },
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
                const SizedBox(height: 20),

                // Position Dropdown
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
                  decoration: const InputDecoration(labelText: 'Position'),
                ),
                const SizedBox(height: 20),

                // Jersey Number
                TextFormField(
                  initialValue: playerJersey.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) {
                    playerJersey = int.tryParse(value) ?? 0;
                  },
                  decoration: const InputDecoration(labelText: 'Jersey Number (0-100)'),
                ),
                const SizedBox(height: 20),

                // Height Input
                TextFormField(
                  initialValue: playerHeight.toString(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  onChanged: (value) {
                    playerHeight = double.tryParse(value) ?? 1.83;
                  },
                  decoration: const InputDecoration(labelText: 'Height (meters, e.g. 1.83)'),
                ),
                const SizedBox(height: 20),

                // Icon Selection
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

                // Display selected icon
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
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  
                  bool playerExists = existingPlayers.any((player) => player.name.toLowerCase() == playerName.toLowerCase());
                  if (playerName.trim().isEmpty) {
                    showSnackbar(context, "Player name can't be empty!", Colors.red);
                  } else if(playerExists) {
                    showSnackbar(context, "A Player with that name already exists!", Colors.red);
                  } else if(!(playerJersey>=0 && playerJersey<=99)) {
                    showSnackbar(context, "Invalid jersey number!", Colors.red);
                  } else if(!(playerHeight>0.62 && playerHeight<2.72)) {
                    showSnackbar(context, "It's unlikely this is a valid height...", Colors.red);
                  } else {
                    onAdded(playerName, playerPosition, playerIcon, playerJersey, playerHeight);
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('Add Player'),
              ),
            ],
          );
        }
      );
    },
  );
}
