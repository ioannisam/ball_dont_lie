import 'package:flutter/material.dart';
import 'package:ball_dont_lie/player/player.dart';

class Team {
  String name;
  String logo;
  List<Player> players;

  Color mainColor;
  Color accentColor;

  Team({required this.name, required this.logo, required this.mainColor, required this.accentColor}) : players = [];

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