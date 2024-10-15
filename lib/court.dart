import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'team.dart';
import 'player.dart';
import 'dart:io';

class Court extends StatefulWidget {
  const Court({super.key});

  @override
  _CourtState createState() => _CourtState();
}

class _CourtState extends State<Court> {
  bool isMoveMode = false;
  String? teamImagePath;

  String teamName = "";
  int numberOfMembers = 0;
  String coachName = "-";
  String assistantCoachName = "-";

  void _addPlayer(String playerName, String playerPosition) {
    final Team team = ModalRoute.of(context)!.settings.arguments as Team;

    if (team.players.any((player) => player.name.toLowerCase() == playerName.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A player with this name already exists!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      team.addPlayer(Player(name: playerName, position: playerPosition));
      numberOfMembers = team.players.length;
    });
  }

  void _showAddPlayerDialog() {
    addPlayerDialog(context, (newPlayer) {
      _addPlayer(newPlayer.name, newPlayer.position);
    });
  }

  void _showEditTeamInfoDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempCoach = coachName;
        String tempAssistantCoach = assistantCoachName;

        return AlertDialog(
          title: const Text('Edit Team Info'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Coach Name'),
                onChanged: (value) {
                  tempCoach = value;
                },
                controller: TextEditingController(text: coachName),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Assistant Coach Name'),
                onChanged: (value) {
                  tempAssistantCoach = value;
                },
                controller: TextEditingController(text: assistantCoachName),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  coachName = tempCoach;
                  assistantCoachName = tempAssistantCoach;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        teamImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Team team = ModalRoute.of(context)!.settings.arguments as Team;

    return Scaffold(
      appBar: AppBar(
        title: Text('${team.name} Players'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Team Information',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: _showEditTeamInfoDialog,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text('Team Name: ${team.name}', style: const TextStyle(fontSize: 18)),
                      Text('Number of Members: $numberOfMembers', style: const TextStyle(fontSize: 18)),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 10),
                          Text('Coach: $coachName', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person, size: 20),
                          const SizedBox(width: 10),
                          Text('Assistant Coach: $assistantCoachName', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(15.0),
                      image: teamImagePath != null
                          ? DecorationImage(
                              image: FileImage(File(teamImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: AssetImage('assets/placeholder.jpg'),
                              fit: BoxFit.cover,
                            ),
                    ),
                    child: Center(
                      child: Text(
                        teamImagePath == null ? 'Tap to add team photo' : '',
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: team.players.length,
              itemBuilder: (context, index) {
                final player = team.players[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage('assets/placeholder.jpg'),
                    ),
                    title: Text('${player.name} (${player.position})'),
                    onTap: () {
                      if(!isMoveMode) {
                        //go to the payers stat page
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPlayerDialog,
        tooltip: 'Add Player',
        child: const Icon(Icons.add),
      ),
    );
  }
}
