import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class PuntoStore extends ChangeNotifier {
  PuntoStore._();

  static final PuntoStore instance = PuntoStore._();

  static const _gamesKey = 'punto_games_v1';
  static const _darkKey = 'punto_dark_mode_v1';

  SharedPreferences? _preferences;
  Future<void> _pendingWrites = Future<void>.value();
  final List<PuntoGame> games = [];
  bool isDarkMode = false;

  Future<void> load() async {
    _preferences = await SharedPreferences.getInstance();
    isDarkMode = _preferences?.getBool(_darkKey) ?? false;

    final raw = _preferences?.getString(_gamesKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as List;
        games
          ..clear()
          ..addAll(decoded.map((item) => PuntoGame.fromJson(
              Map<String, dynamic>.from(item as Map))));
      } catch (_) {
        games.clear();
      }
    }
    notifyListeners();
  }

  PuntoGame createGame({
    required String title,
    required List<String> playerNames,
  }) {
    final now = DateTime.now();
    final seed = now.microsecondsSinceEpoch.toString();
    final players = <PuntoPlayer>[];

    for (var i = 0; i < playerNames.length; i++) {
      players.add(PuntoPlayer(
        id: '${seed}_$i',
        name: playerNames[i].trim(),
        colorIndex: i % 8,
      ));
    }

    final game = PuntoGame(
      id: seed,
      title: title.trim().isEmpty ? 'Friendly Match' : title.trim(),
      createdAt: now,
      updatedAt: now,
      players: players,
    );
    games.insert(0, game);
    _changed();
    return game;
  }

  PuntoGame? gameById(String id) {
    for (final game in games) {
      if (game.id == id) return game;
    }
    return null;
  }

  void addRound(String gameId, Map<String, int> pointChanges) {
    final game = gameById(gameId);
    if (game == null) return;

    final changes = <RoundChange>[];
    for (final player in game.players) {
      final points = pointChanges[player.id] ?? 0;
      if (points == 0) continue;
      player.score += points;
      changes.add(RoundChange(
        playerId: player.id,
        playerName: player.name,
        points: points,
      ));
    }

    if (changes.isEmpty) return;

    final now = DateTime.now();
    game.rounds.add(ScoreRound(
      id: now.microsecondsSinceEpoch.toString(),
      number: game.rounds.length + 1,
      createdAt: now,
      changes: changes,
    ));
    game.updatedAt = now;
    _changed();
  }

  bool undoLastRound(String gameId) {
    final game = gameById(gameId);
    if (game == null || game.rounds.isEmpty) return false;

    final last = game.rounds.removeLast();
    for (final change in last.changes) {
      for (final player in game.players) {
        if (player.id == change.playerId) {
          player.score -= change.points;
          break;
        }
      }
    }
    game.updatedAt = DateTime.now();
    _changed();
    return true;
  }

  void deleteGame(String gameId) {
    games.removeWhere((game) => game.id == gameId);
    _changed();
  }

  void toggleDarkMode() => setDarkMode(!isDarkMode);

  void setDarkMode(bool value) {
    if (isDarkMode == value) return;
    isDarkMode = value;
    notifyListeners();
    _queueWrite(_saveDarkMode);
  }

  Future<void> _saveDarkMode() async {
    final preferences = _preferences;
    if (preferences == null) return;
    await preferences.setBool(_darkKey, isDarkMode);
  }

  Future<void> clearAllData() async {
    games.clear();
    isDarkMode = false;
    notifyListeners();

    await _pendingWrites.catchError((_) {});
    final preferences = _preferences ?? await SharedPreferences.getInstance();
    _preferences = preferences;
    await preferences.remove(_gamesKey);
    await preferences.remove(_darkKey);
  }

  void _changed() {
    notifyListeners();
    _queueWrite(_persist);
  }

  void _queueWrite(Future<void> Function() operation) {
    _pendingWrites = _pendingWrites.catchError((_) {}).then((_) => operation());
  }

  Future<void> _persist() async {
    final preferences = _preferences;
    if (preferences == null) return;
    final encoded = jsonEncode(games.map((game) => game.toJson()).toList());
    await preferences.setString(_gamesKey, encoded);
  }
}
