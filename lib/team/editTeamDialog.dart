import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ball_dont_lie/team/team.dart';
import 'package:ball_dont_lie/widgets/snackbar.dart';
import 'package:ball_dont_lie/widgets/colorblob.dart';

Future<void> editTeamDialog(
    BuildContext context,
    Team team,
    Function(String, String, Color, Color) onEdit,
    List<Team> existingTeams) async {
  
  String teamName = team.name;
  String? selectedLogoPath = team.logo;
  final picker = ImagePicker();
  Color mainColor = team.mainColor;
  Color accentColor = team.accentColor;

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

  Future<void> _pickColor(BuildContext context, Function(Color) onColorPicked) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: basicColors.map((color) {
              return GestureDetector(
                onTap: () {
                  onColorPicked(color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        const Text('Main Color'),
                        colorBlob(mainColor, () {
                          _pickColor(context, (color) {
                            setState(() {
                              if (color != accentColor) {
                                mainColor = color;
                              } else {
                                showSnackbar(context, "Main and Accent colors cannot be the same!", Colors.red);
                              }
                            });
                          });
                        }),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Accent Color'),
                        colorBlob(accentColor, () {
                          _pickColor(context, (color) {
                            setState(() {
                              if (color != mainColor) {
                                accentColor = color;
                              } else {
                                showSnackbar(context, "Main and Accent colors cannot be the same!", Colors.red);
                              }
                            });
                          });
                        }),
                      ],
                    ),
                  ],
                ),
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
                  bool teamExists = existingTeams.any(
                    (existingTeam) =>
                        existingTeam.name.toLowerCase() == teamName.toLowerCase() &&
                        existingTeam != team,
                  );

                  if (teamName.trim().isEmpty) {
                    showSnackbar(context, "Team name can't be empty!", Colors.red);
                  } else if (teamExists) {
                    showSnackbar(context, "A team with this name already exists!", Colors.red);
                  } else {
                    onEdit(teamName, selectedLogoPath ?? 'assets/logo.png', mainColor, accentColor);
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