import 'package:flutter/material.dart';
import 'classes/team.dart';
import 'classes/player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Team> teams = [];
  bool isMoveMode = false;

  void _addTeam(String teamName) {
    bool teamExists = teams.any((team) => team.name.toLowerCase() == teamName.toLowerCase());

    if (teamExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A team with this name already exists!'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setState(() {
        teams.add(Team(name: teamName, image: 'assets/ball2.png', logo: 'assets/ball.png'));
      });
    }
  }

  void _showAddTeamDialog() {
    addTeamDialog(context, _addTeam);
  }

  void _deleteTeam(String teamName) {
    setState(() {
      teams.removeWhere((team) => team.name == teamName);
    });
  }

  void _showDeleteTeamDialog(String teamName) {
    deleteTeamDialog(context, () {
      _deleteTeam(teamName);
    });
  }

  void _reorderTeam(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Team team = teams.removeAt(oldIndex);
      teams.insert(newIndex, team);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ball Don’t Lie'),
        centerTitle: true,
        backgroundColor: Colors.orange,
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
      body: teams.isEmpty
          ? const Center(child: Text('No teams added yet!'))
          : GestureDetector(
              onTap: () {
                setState(() {
                  isMoveMode = false;
                });
              },
              child: isMoveMode
                  ? ReorderableListView.builder(
                      itemCount: teams.length,
                      onReorder: _reorderTeam,
                      itemBuilder: (context, index) {
                        return Container(
                          key: ValueKey(teams[index]),
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 5,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(15),
                              leading: Image.asset(
                                teams[index].logo,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(
                                teams[index].name,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteTeamDialog(teams[index].name);
                                  } else if (value == 'move') {
                                    setState(() {
                                      isMoveMode = true; 
                                    });
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'move',
                                    child: ListTile(
                                      leading: Icon(Icons.open_with),
                                      title: Text('Move Team'),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete Team'),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/court',
                                  arguments: teams[index],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: teams.length,
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
                                teams[index].logo,
                                width: 50,
                                height: 50,
                              ),
                              title: Text(
                                teams[index].name,
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              trailing: PopupMenuButton(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    _showDeleteTeamDialog(teams[index].name);
                                  } else if (value == 'move') {
                                    setState(() {
                                      isMoveMode = true;
                                    });
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'move',
                                    child: ListTile(
                                      leading: Icon(Icons.open_with),
                                      title: Text('Move Team'),
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: ListTile(
                                      leading: Icon(Icons.delete),
                                      title: Text('Delete Team'),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/court',
                                  arguments: teams[index],
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTeamDialog,
        tooltip: 'Add a team',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
