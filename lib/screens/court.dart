import 'package:flutter/material.dart';
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
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Team: ${team.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Members: ${players.length}', style: TextStyle(fontSize: 16)),
                      Text('Coach: ${team.coachName}', style: TextStyle(fontSize: 16)),
                      Text('Assistant: ${team.assistantCoachName}', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Logic for editing team info
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      // Zoom logic for team photo
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.photo, size: 50),
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
