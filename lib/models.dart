class Game {
  final int? id;
  final String team1Name;
  final String team2Name;
  final int totalRounds;
  final String gameDate;
  final int isFinished;
  final String? winnerTeam;

  Game({
    this.id,
    required this.team1Name,
    required this.team2Name,
    required this.totalRounds,
    required this.gameDate,
    this.isFinished = 0,
    this.winnerTeam,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'team1_name': team1Name,
      'team2_name': team2Name,
      'total_rounds': totalRounds,
      'game_date': gameDate,
      'is_finished': isFinished,
      'winner_team': winnerTeam,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      team1Name: map['team1_name'],
      team2Name: map['team2_name'],
      totalRounds: map['total_rounds'],
      gameDate: map['game_date'],
      isFinished: map['is_finished'],
      winnerTeam: map['winner_team'],
    );
  }
}

class RoundScore {
  final int? id;
  final int gameId;
  final int roundNumber;
  final int team1Score;
  final int team2Score;
  final int team1Penalty;
  final int team2Penalty;

  RoundScore({
    this.id,
    required this.gameId,
    required this.roundNumber,
    required this.team1Score,
    required this.team2Score,
    this.team1Penalty = 0,
    this.team2Penalty = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'game_id': gameId,
      'round_number': roundNumber,
      'team1_score': team1Score,
      'team2_score': team2Score,
      'team1_penalty': team1Penalty,
      'team2_penalty': team2Penalty,
    };
  }

  factory RoundScore.fromMap(Map<String, dynamic> map) {
    return RoundScore(
      id: map['id'],
      gameId: map['game_id'],
      roundNumber: map['round_number'],
      team1Score: map['team1_score'],
      team2Score: map['team2_score'],
      team1Penalty: map['team1_penalty'],
      team2Penalty: map['team2_penalty'],
    );
  }
}