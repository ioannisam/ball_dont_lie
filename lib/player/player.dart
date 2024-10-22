import 'package:flutter/material.dart';

class Player {
  String name;
  String position;
  double playingTime;
  int points;
  int assists;
  int rebounds;
  int blocks;
  int steals;
  int twoPointAttempts;
  int threePointAttempts;

  Player({
    required this.name,
    required this.position,
    this.playingTime = 0.0,
    this.points = 0,
    this.assists = 0,
    this.rebounds = 0,
    this.blocks = 0,
    this.steals = 0,
    this.twoPointAttempts = 0,
    this.threePointAttempts = 0,
  });
}






