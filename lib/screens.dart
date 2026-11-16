import 'package:flutter/material.dart';

import 'models.dart';
import 'settings_screen.dart';
import 'store.dart';
import 'ui.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PuntoStore.instance;
    final games = store.games;

    return Scaffold(
      appBar: AppBar(
        title: const PuntoLogo(),
        actions: [
          IconButton(
            tooltip: store.isDarkMode ? 'Light mode' : 'Dark mode',
            onPressed: store.toggleDarkMode,
            icon: Icon(store.isDarkMode
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded),
          ),
          IconButton(
            tooltip: 'Settings',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: SafeArea(
        child: games.isEmpty
            ? _EmptyHome(onCreate: () => _openCreate(context))
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                children: [
                  _HomeHero(
                    gameCount: games.length,
                    playerCount: games.fold<int>(
                        0, (sum, game) => sum + game.players.length),
                  ),
                  const SizedBox(height: 26),
                  SectionLabel(
                    'Your scoreboards',
                    trailing: Text('${games.length} saved',
                        style: Theme.of(context).textTheme.labelMedium),
                  ),
                  const SizedBox(height: 12),
                  for (final game in games) ...[
                    _GameTile(
                      game: game,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => GameScreen(gameId: game.id),
                        ),
                      ),
                      onDelete: () => _confirmDelete(context, game),
                    ),
                    const SizedBox(height: 12),
                  ],
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: () => _openCreate(context),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Create a scoreboard'),
                  ),
                ],
              ),
      ),
      floatingActionButton: games.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => _openCreate(context),
              backgroundColor: puntoLime,
              foregroundColor: const Color(0xFF24242F),
              child: const Icon(Icons.add_rounded, size: 30),
            ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CreateGameScreen()),
    );
  }

  Future<void> _confirmDelete(BuildContext context, PuntoGame game) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete scoreboard?'),
        content: Text('“${game.title}” and its round history will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      PuntoStore.instance.deleteGame(game.id);
    }
  }
}

class _EmptyHome extends StatelessWidget {
  const _EmptyHome({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: puntoLime,
                borderRadius: BorderRadius.circular(36),
              ),
              child: const Icon(Icons.emoji_events_rounded,
                  size: 58, color: Color(0xFF29283A)),
            ),
            const SizedBox(height: 24),
            Text('Let the games begin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    )),
            const SizedBox(height: 9),
            Text(
              'Keep everyone’s score in one place.\nCards, dominoes, family games — you name it.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.6),
                    height: 1.45,
                  ),
            ),
            const SizedBox(height: 26),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first scoreboard'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero({required this.gameCount, required this.playerCount});

  final int gameCount;
  final int playerCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: puntoPurple,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GOOD TIMES.\nFAIR SCORES.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -.4,
                    )),
                const SizedBox(height: 10),
                Text(
                  '$gameCount active ${gameCount == 1 ? 'game' : 'games'} · $playerCount players',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.sports_esports_rounded,
              color: puntoLime, size: 58),
        ],
      ),
    );
  }
}

class _GameTile extends StatelessWidget {
  const _GameTile({
    required this.game,
    required this.onTap,
    required this.onDelete,
  });

  final PuntoGame game;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final leader = game.leader;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: puntoPurple.withOpacity(.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.sports_score_rounded,
                        color: puntoPurple),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 3),
                        Text(
                          '${game.players.length} players · ${game.totalRounds} ${game.totalRounds == 1 ? 'round' : 'rounds'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(.55),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: onDelete,
                    tooltip: 'Delete',
                    icon: const Icon(Icons.more_horiz_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.emoji_events_rounded,
                            color: Color(0xFFE6A93C), size: 18),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            leader == null ? 'No leader yet' : '${leader.name} is ahead',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    leader?.score.toString() ?? '0',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _titleController = TextEditingController();
  final List<TextEditingController> _playerControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    for (final controller in _playerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addPlayer() {
    if (_playerControllers.length >= 8) return;
    setState(() => _playerControllers.add(TextEditingController()));
  }

  void _removePlayer(int index) {
    if (_playerControllers.length <= 2) return;
    final controller = _playerControllers.removeAt(index);
    controller.dispose();
    setState(() {});
  }

  void _create() {
    final names = _playerControllers
        .map((controller) => controller.text.trim())
        .toList();

    if (names.any((name) => name.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a name for every player.')),
      );
      return;
    }

    final normalized = names.map((name) => name.toLowerCase()).toSet();
    if (normalized.length != names.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player names must be different.')),
      );
      return;
    }

    final game = PuntoStore.instance.createGame(
      title: _titleController.text,
      playerNames: names,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => GameScreen(gameId: game.id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New scoreboard')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: puntoPurple,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.groups_rounded, color: puntoLime, size: 42),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Who’s playing?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SectionLabel('Match name'),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Friday Night Cards',
                prefixIcon: Icon(Icons.edit_rounded),
              ),
            ),
            const SizedBox(height: 25),
            SectionLabel(
              'Players',
              trailing: Text('${_playerControllers.length}/8'),
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < _playerControllers.length; i++) ...[
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: playerColors[i].withOpacity(.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Text('${i + 1}',
                        style: TextStyle(
                          color: playerColors[i],
                          fontWeight: FontWeight.w900,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _playerControllers[i],
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        hintText: 'Player ${i + 1} name',
                        prefixIcon: const Icon(Icons.person_outline_rounded),
                      ),
                    ),
                  ),
                  if (_playerControllers.length > 2)
                    IconButton(
                      onPressed: () => _removePlayer(i),
                      icon: const Icon(Icons.close_rounded),
                    ),
                ],
              ),
              const SizedBox(height: 10),
            ],
            if (_playerControllers.length < 8)
              OutlinedButton.icon(
                onPressed: _addPlayer,
                icon: const Icon(Icons.person_add_alt_1_rounded),
                label: const Text('Add another player'),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _create,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Start keeping score'),
            ),
            const SizedBox(height: 10),
            Text(
              'You can add points, subtract points, and undo a saved round later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.55),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.gameId});

  final String gameId;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Map<String, int> _draft = {};

  int _draftFor(String playerId) => _draft[playerId] ?? 0;

  void _change(String playerId, int delta) {
    setState(() => _draft[playerId] = _draftFor(playerId) + delta);
  }

  void _discardDraft() {
    setState(() => _draft.clear());
  }

  void _saveRound() {
    final changes = Map<String, int>.from(_draft)
      ..removeWhere((key, value) => value == 0);
    if (changes.isEmpty) return;

    PuntoStore.instance.addRound(widget.gameId, changes);
    setState(() => _draft.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Round saved. Scores updated!')),
    );
  }

  Future<void> _customPoints(PuntoPlayer player) async {
    final controller = TextEditingController();
    final result = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Adjust ${player.name}’s points'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(signed: true),
          decoration: const InputDecoration(
            hintText: 'e.g. 12 or -5',
            helperText: 'Use a minus sign to subtract points.',
          ),
          onSubmitted: (value) {
            final parsed = int.tryParse(value.trim());
            Navigator.pop(dialogContext, parsed);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text.trim());
              Navigator.pop(dialogContext, parsed);
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result != null && result != 0 && mounted) {
      _change(player.id, result);
    }
  }

  Future<void> _undo(PuntoGame game) async {
    if (game.rounds.isEmpty) return;
    final lastRound = game.rounds.last;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Undo last round?'),
        content: Text('Round ${lastRound.number} will be removed and its points reversed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep it'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Undo round'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      PuntoStore.instance.undoLastRound(game.id);
    }
  }

  void _showHistory(PuntoGame game) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => RoundHistorySheet(game: game),
    );
  }

  @override
  Widget build(BuildContext context) {
    final game = PuntoStore.instance.gameById(widget.gameId);
    if (game == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This scoreboard is no longer available.')),
      );
    }

    final pendingTotal = _draft.values.fold<int>(0, (sum, value) => sum + value);
    final leader = game.leader;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(game.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w900)),
            Text('Round ${game.totalRounds + 1}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.55),
                    )),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Round history',
            onPressed: () => _showHistory(game),
            icon: const Icon(Icons.history_rounded),
          ),
          IconButton(
            tooltip: 'Undo last round',
            onPressed: game.rounds.isEmpty ? null : () => _undo(game),
            icon: const Icon(Icons.undo_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 20),
          children: [
            _ScoreSummary(
              leader: leader,
              roundCount: game.totalRounds,
              playerCount: game.players.length,
            ),
            const SizedBox(height: 22),
            SectionLabel(
              'Tap to add points',
              trailing: Text(
                '${game.players.length} players',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            const SizedBox(height: 12),
            for (final player in game.players) ...[
              _PlayerScoreCard(
                player: player,
                pending: _draftFor(player.id),
                onAdd: (value) => _change(player.id, value),
                onCustom: () => _customPoints(player),
              ),
              const SizedBox(height: 12),
            ],
            const SizedBox(height: 6),
            if (game.rounds.isNotEmpty)
              OutlinedButton.icon(
                onPressed: () => _showHistory(game),
                icon: const Icon(Icons.receipt_long_rounded),
                label: Text('View ${game.totalRounds} saved rounds'),
              ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(.35),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PENDING',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.1)),
                    Text(
                      pendingTotal > 0 ? '+$pendingTotal' : '$pendingTotal',
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: pendingTotal == 0 &&
                        _draft.values.every((value) => value == 0)
                    ? null
                    : _discardDraft,
                child: const Text('Clear'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _draft.values.any((value) => value != 0)
                    ? _saveRound
                    : null,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save round'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({
    required this.leader,
    required this.roundCount,
    required this.playerCount,
  });

  final PuntoPlayer? leader;
  final int roundCount;
  final int playerCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: puntoPurple,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded,
              color: puntoLime, size: 34),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('CURRENT LEADER',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.1,
                    )),
                const SizedBox(height: 3),
                Text(
                  leader?.name ?? 'No scores yet',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$roundCount rounds · $playerCount players',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            leader?.score.toString() ?? '0',
            style: const TextStyle(
              color: puntoLime,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayerScoreCard extends StatelessWidget {
  const _PlayerScoreCard({
    required this.player,
    required this.pending,
    required this.onAdd,
    required this.onCustom,
  });

  final PuntoPlayer player;
  final int pending;
  final ValueChanged<int> onAdd;
  final VoidCallback onCustom;

  @override
  Widget build(BuildContext context) {
    final accent = playerColors[player.colorIndex % playerColors.length];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 43,
                  height: 43,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    player.name.isEmpty ? '?' : player.name[0].toUpperCase(),
                    style: TextStyle(
                        color: accent, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      if (pending != 0)
                        Text(
                          '${pending > 0 ? '+' : ''}$pending pending',
                          style: TextStyle(
                            color: pending > 0
                                ? const Color(0xFF269B75)
                                : const Color(0xFFE07B65),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  player.score.toString(),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                for (final value in [1, 5, 10]) ...[
                  Expanded(
                    child: _PointButton(
                      label: '+$value',
                      onTap: () => onAdd(value),
                      color: accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: _PointButton(
                    label: 'Custom',
                    icon: Icons.tune_rounded,
                    onTap: onCustom,
                    color: Theme.of(context).colorScheme.onSurface,
                    outlined: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PointButton extends StatelessWidget {
  const _PointButton({
    required this.label,
    required this.onTap,
    required this.color,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final IconData? icon;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: outlined ? Colors.transparent : color.withOpacity(.12),
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Container(
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            border: outlined
                ? Border.all(color: Theme.of(context).dividerColor)
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 15, color: color),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundHistorySheet extends StatelessWidget {
  const RoundHistorySheet({super.key, required this.game});

  final PuntoGame game;

  @override
  Widget build(BuildContext context) {
    final rounds = game.rounds.reversed.toList();
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .72,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Round history',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      )),
              const SizedBox(height: 4),
              Text(
                '${game.title} · ${game.totalRounds} saved rounds',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: rounds.isEmpty
                    ? const Center(child: Text('No rounds saved yet.'))
                    : ListView.separated(
                        itemCount: rounds.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final round = rounds[index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text('ROUND ${round.number}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                          )),
                                      const Spacer(),
                                      Text(formatShortDate(round.createdAt),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  for (final change in round.changes)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Row(
                                        children: [
                                          Expanded(child: Text(change.playerName)),
                                          Text(
                                            '${change.points > 0 ? '+' : ''}${change.points}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              color: change.points >= 0
                                                  ? const Color(0xFF269B75)
                                                  : const Color(0xFFE07B65),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
