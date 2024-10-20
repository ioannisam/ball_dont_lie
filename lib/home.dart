import 'package:flutter/material.dart';
import 'team.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Team> teams = [];
  bool isMoveMode = false;

  void _addTeam(String teamName, String teamLogo, Color mainColor, Color accentColor) { 
    setState(() {
      teams.add(Team(
        name: teamName,
        logo: teamLogo,
        mainColor: mainColor,
        accentColor: accentColor,
      ));
    });
  }

  void _showAddTeamDialog() {
    addTeamDialog(context, (teamName, teamLogo, mainColor, accentColor) {
      _addTeam(teamName, teamLogo, mainColor, accentColor);
    }, teams);
  }

  void _editTeam(String oldTeamName, String newTeamName, String newLogoPath, Color newMainColor, Color newAccentColor) {
    setState(() {
      for (var team in teams) {
        if (team.name == oldTeamName) {
          team.name = newTeamName;
          team.logo = newLogoPath;
          team.mainColor = newMainColor;
          team.accentColor = newAccentColor;
          break;
        }
      }
    });
  }

  void _showEditTeamDialog(String oldTeamName, Team team) {
    editTeamDialog(context, team, (newTeamName, newLogoPath, newMainColor, newAccentColor) {
      _editTeam(oldTeamName, newTeamName, newLogoPath, newMainColor, newAccentColor);
    }, teams);
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
                                  } else if (value == 'edit') {
                                    _showEditTeamDialog(teams[index].name, teams[index]);
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
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit Team'),
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
                                if (!isMoveMode) {
                                  Navigator.pushNamed(
                                    context,
                                    '/home/court',
                                    arguments: teams[index],
                                  );
                                }
                                // This line can be removed if the user just wants to exit move mode on tap.
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
                                  } else if (value == 'edit') {
                                    _showEditTeamDialog(teams[index].name, teams[index]);
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
                                    value: 'edit',
                                    child: ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text('Edit Team'),
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
                                if (!isMoveMode) {
                                  Navigator.pushNamed(
                                    context,
                                    '/home/court',
                                    arguments: teams[index],
                                  );
                                }
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
