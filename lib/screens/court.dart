import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../team/team.dart';
import '../player/player.dart';
import '../player/addPlayerDialog.dart';
import '../player/editPlayerDialog.dart';
import '../player/deletePlayerDialog.dart';


class Court extends StatefulWidget {
  @override
  _CourtState createState() => _CourtState();
}

class _CourtState extends State<Court> {
  late Team team;
  late List<Player> players;
  bool isMoveMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    team = ModalRoute.of(context)!.settings.arguments as Team;
    players = team.players;
  }

  void _addPlayer(String playerName, String position, String? playerIcon, int jersey, double height) {
    setState(() {
      players.add(Player(
        name: playerName,
        icon: playerIcon,
        jersey: jersey,
        height: height,
        position: position,
      ));
    });
  }

  void _showAddPlayerDialog() {
    addPlayerDialog(context, (playerName, position, playerIcon, jersey, height) {
      _addPlayer(playerName, position, playerIcon, jersey, height);
    }, players);
  }

  void _editPlayer(String oldPlayerName, String newPlayerName, String newPosition, String? newIconPath, int newJerseyNumber, double newHeight) {
    setState(() {
      for (var player in players) {
        if (player.name == oldPlayerName) {
          player.name = newPlayerName;
          player.icon = newIconPath;
          player.jersey = newJerseyNumber;
          player.height = newHeight;
          player.position = newPosition;
          break;
        }
      }
    });
  }

  void _showEditPlayerDialog(String oldPlayerName, Player player) {
    editPlayerDialog(context, player, (newPlayerName, newPosition, newIconPath, newJerseyNumber, newHeight) {
      _editPlayer(oldPlayerName, newPlayerName, newPosition, newIconPath, newJerseyNumber, newHeight);
    }, players);
  }

  void _deletePlayer(String playerName) {
    setState(() {
      players.removeWhere((player) => player.name == playerName);
    });
  }

  void _showDeletePlayerDialog(String playerName) {
    deletePlayerDialog(context, () {
      _deletePlayer(playerName);
    });
  }

  void _reorderPlayer(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Player player = players.removeAt(oldIndex);
      players.insert(newIndex, player);
    });
  }

  void _showZoomedImage(String imagePath) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: InteractiveViewer(
              boundaryMargin: EdgeInsets.all(20.0),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(imagePath),
            ),
          ),
        );
      },
    );
  }

  void _showEditInfoDialog(BuildContext context) {
    TextEditingController coachNameController = TextEditingController(text: team.coachName);
    TextEditingController assistantCoachNameController = TextEditingController(text: team.assistantCoachName);
    TextEditingController descriptionController = TextEditingController(text: team.description);

    String coachPhotoPath = team.coachPhoto;
    String assistantCoachPhotoPath = team.assistantCoachPhoto;
    String teamPhotoPath = team.photo;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Team Info', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team Description
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Team Description',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    // Coach Info
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  coachPhotoPath = pickedFile.path;
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundImage: FileImage(File(coachPhotoPath)),
                              radius: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: coachNameController,
                              decoration: InputDecoration(
                                labelText: 'Coach Name',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Assistant Coach Info
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  assistantCoachPhotoPath = pickedFile.path;
                                });
                              }
                            },
                            child: CircleAvatar(
                              backgroundImage: FileImage(File(assistantCoachPhotoPath)),
                              radius: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: assistantCoachNameController,
                              decoration: InputDecoration(
                                labelText: 'Assistant Coach Name',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Team Photo
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                setState(() {
                                  teamPhotoPath = pickedFile.path;
                                });
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image(
                                image: FileImage(File(teamPhotoPath)),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Team Photo',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  team.coachName = coachNameController.text;
                  team.assistantCoachName = assistantCoachNameController.text;
                  team.description = descriptionController.text;
                  team.coachPhoto = coachPhotoPath;
                  team.assistantCoachPhoto = assistantCoachPhotoPath;
                  team.photo = teamPhotoPath;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${team.name} Court'),
        centerTitle: true,
        backgroundColor: team.mainColor,
        actions: [
          if (isMoveMode)
            IconButton(
              icon: const Icon(Icons.done),
              onPressed: () {
                setState(() {
                  isMoveMode = false;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Team: ${team.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('Members: ${players.length}', style: TextStyle(fontSize: 16)),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Image.asset(team.coachPhoto)
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Coach: ${team.coachName}', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey[300],
                                    child: Image.asset(team.assistantCoachPhoto)
                                  ),
                                  const SizedBox(width: 8),
                                  Text('Assistant: ${team.assistantCoachName}', style: TextStyle(fontSize: 16)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  team.description,
                                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _showEditInfoDialog(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _showZoomedImage(team.photo);
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          team.photo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: players.isEmpty
                ? const Center(child: Text('No players added yet!'))
                : isMoveMode
                    ? ReorderableListView.builder(
                        itemCount: players.length,
                        onReorder: _reorderPlayer,
                        itemBuilder: (context, index) {
                          return Container(
                            key: ValueKey(players[index]),
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: Image.asset(
                                  players[index].icon ?? 'assets/logo.png',
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  players[index].name,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Jersey: ${players[index].jersey} | Position: ${players[index].position}'),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _showDeletePlayerDialog(players[index].name);
                                    } else if (value == 'move') {
                                      setState(() {
                                        isMoveMode = true;
                                      });
                                    } else if (value == 'edit') {
                                      _showEditPlayerDialog(players[index].name, players[index]);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'move',
                                      child: ListTile(
                                        leading: Icon(Icons.open_with),
                                        title: Text('Move Player'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit Player'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete Player'),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    isMoveMode = false;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(15),
                                leading: Image.asset(
                                  players[index].icon ?? '/assets/logo.png',
                                  width: 50,
                                  height: 50,
                                ),
                                title: Text(
                                  players[index].name,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('Jersey: ${players[index].jersey} | Position: ${players[index].position}'),
                                trailing: PopupMenuButton(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    if (value == 'delete') {
                                      _showDeletePlayerDialog(players[index].name);
                                    } else if (value == 'move') {
                                      setState(() {
                                        isMoveMode = true;
                                      });
                                    } else if (value == 'edit') {
                                      _showEditPlayerDialog(players[index].name, players[index]);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'move',
                                      child: ListTile(
                                        leading: Icon(Icons.open_with),
                                        title: Text('Move Player'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit),
                                        title: Text('Edit Player'),
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete),
                                        title: Text('Delete Player'),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Navigate to player Screen          
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlayerDialog,
        tooltip: 'Add a player',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
