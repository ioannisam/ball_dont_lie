import 'package:flutter/material.dart';
import 'package:ball_dont_lie/player/player.dart';

class Team {
  String name;
  String logo;
  List<Player> players;

  String photo;
  String description;
  String coachName;
  String coachPhoto;
  String assistantCoachName;
  String assistantCoachPhoto;

  Color mainColor;
  Color accentColor;

  Team({
    required this.name, 
    required this.logo, 
    required this.mainColor, 
    required this.accentColor,
  
    this.description = 'Basketball team',
    this.coachName= 'N/A',
    this.coachPhoto = 'assets/ball.png',
    this.assistantCoachName= 'N/A',
    this.assistantCoachPhoto = 'assets/ball2.png',
    this.photo = 'assets/placeholder.jpg',
  }) : players = [];

  void addPlayer(Player player) {
    players.add(player);
  }

  void removePlayer(Player player) {
    players.remove(player);
  }

  void deleteTeam() {
    players.clear();
  }
}