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

  void _addTeam(String teamName) {
    setState(() {
      teams.add(Team(name: teamName, image: 'assets/ball2.png', logo: 'assets/ball.png'));
    });
  }

  void _showAddTeamDialog() {
    addTeamDialog(context, _addTeam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basketball Stats'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: teams.isEmpty
          ? const Center(child: Text('No teams added yet!'))
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
                        teams[index].image, // Image path from team data
                        width: 50,
                        height: 50,
                      ),
                      title: Text(
                        teams[index].name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTeamDialog,
        tooltip: 'Add a team',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
