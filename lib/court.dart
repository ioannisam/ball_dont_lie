import 'package:flutter/material.dart';
import 'classes/team.dart';

class Court extends StatelessWidget {
  const Court({super.key});

  @override
  Widget build(BuildContext context) {

    final Team team = ModalRoute.of(context)!.settings.arguments as Team;

    return Scaffold(
      appBar: AppBar(
        title: Text(team.name),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back
          },
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                team.image,
                width: 100,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: team.players.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text(
                      team.players[index].name, // Display player name
                      style: const TextStyle(fontSize: 18), // Customize the font size
                    ),
                    onTap: () {
                      // You will add player tap functionality later
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Functionality to add players will be set later
        },
        tooltip: 'Add a player',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
