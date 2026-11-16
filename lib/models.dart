class PuntoPlayer {
  PuntoPlayer({
    required this.id,
    required this.name,
    required this.colorIndex,
    this.score = 0,
  });

  final String id;
  String name;
  final int colorIndex;
  int score;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorIndex': colorIndex,
        'score': score,
      };

  factory PuntoPlayer.fromJson(Map<String, dynamic> json) => PuntoPlayer(
        id: json['id'] as String,
        name: json['name'] as String? ?? 'Player',
        colorIndex: (json['colorIndex'] as num?)?.toInt() ?? 0,
        score: (json['score'] as num?)?.toInt() ?? 0,
      );
}

class RoundChange {
  const RoundChange({
    required this.playerId,
    required this.playerName,
    required this.points,
  });

  final String playerId;
  final String playerName;
  final int points;

  Map<String, dynamic> toJson() => {
        'playerId': playerId,
        'playerName': playerName,
        'points': points,
      };

  factory RoundChange.fromJson(Map<String, dynamic> json) => RoundChange(
        playerId: json['playerId'] as String,
        playerName: json['playerName'] as String? ?? 'Player',
        points: (json['points'] as num?)?.toInt() ?? 0,
      );
}

class ScoreRound {
  const ScoreRound({
    required this.id,
    required this.number,
    required this.createdAt,
    required this.changes,
  });

  final String id;
  final int number;
  final DateTime createdAt;
  final List<RoundChange> changes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'createdAt': createdAt.toIso8601String(),
        'changes': changes.map((item) => item.toJson()).toList(),
      };

  factory ScoreRound.fromJson(Map<String, dynamic> json) => ScoreRound(
        id: json['id'] as String,
        number: (json['number'] as num?)?.toInt() ?? 1,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        changes: ((json['changes'] as List?) ?? const [])
            .map((item) => RoundChange.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}

class PuntoGame {
  PuntoGame({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.players,
    List<ScoreRound>? rounds,
  }) : rounds = rounds ?? [];

  final String id;
  String title;
  final DateTime createdAt;
  DateTime updatedAt;
  final List<PuntoPlayer> players;
  final List<ScoreRound> rounds;

  int get totalRounds => rounds.length;

  PuntoPlayer? get leader {
    if (players.isEmpty) return null;
    return players.reduce((a, b) => a.score >= b.score ? a : b);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'players': players.map((item) => item.toJson()).toList(),
        'rounds': rounds.map((item) => item.toJson()).toList(),
      };

  factory PuntoGame.fromJson(Map<String, dynamic> json) => PuntoGame(
        id: json['id'] as String,
        title: json['title'] as String? ?? 'Match',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
        players: ((json['players'] as List?) ?? const [])
            .map((item) => PuntoPlayer.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
        rounds: ((json['rounds'] as List?) ?? const [])
            .map((item) => ScoreRound.fromJson(
                Map<String, dynamic>.from(item as Map)))
            .toList(),
      );
}
