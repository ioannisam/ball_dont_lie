class Player {
  String name;
  String position;
  String? icon;
  int    jersey;
  double height;

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
    required this.icon,
    required this.jersey,
    required this.height,
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