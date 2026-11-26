import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

Future<int?> openGarden(BuildContext context) => showModalBottomSheet<int>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (_) => const GardenRound(),
);

class GardenRound extends StatefulWidget {
  const GardenRound({super.key});

  @override
  State<GardenRound> createState() => _GardenRoundState();
}

class _GardenRoundState extends State<GardenRound> {
  static const turns = 8;
  final _random = Random();
  Timer? _clock;
  int _turn = 0;
  int _target = 0;
  int _picked = 0;
  int _streak = 0;
  int _best = 0;
  int? _choice;

  bool get _finished => _turn > turns;

  @override
  void dispose() {
    _clock?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() {
      _turn = 1;
      _target = _random.nextInt(3);
    });
    _clock = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
      setState(() {
        if (_choice == null) _streak = 0;
        _turn++;
        _choice = null;
        _target = (_target + 1 + _random.nextInt(2)) % 3;
      });
      if (_finished) timer.cancel();
    });
  }

  void _pick(int index) {
    setState(() {
      _choice = index;
      if (index == _target) {
        _picked++;
        _streak++;
        _best = max(_best, _streak);
      } else {
        _streak = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Garden Dash',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _finished
                  ? 'Picked $_picked of $turns snacks. Best streak: $_best.'
                  : 'Tap the pink berry before it moves. Pick snacks to feed Berry.',
            ),
            const SizedBox(height: 16),
            if (_finished)
              FilledButton(
                onPressed: () => Navigator.pop(context, _picked),
                child: Text(
                  _picked == 0 ? 'Back to Berry' : 'Bring snacks home',
                ),
              )
            else if (_turn == 0)
              FilledButton(
                onPressed: _start,
                child: const Text('Start picking'),
              )
            else ...[
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 10,
                runSpacing: 4,
                children: [
                  Text('Patch $_turn of $turns'),
                  Text('Snacks $_picked · Streak $_streak'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  for (var i = 0; i < 3; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(child: _patch(i)),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _choice == null
                    ? 'Pick the berry!'
                    : _choice == _target
                    ? 'Nice catch!'
                    : 'That’s a leaf. Next patch!',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    ),
  );

  Widget _patch(int index) {
    final berry = index == _target;
    final chosen = index == _choice;
    return Material(
      color: chosen
          ? (berry ? const Color(0xFFC5E6BF) : const Color(0xFFF4D8BE))
          : (berry ? const Color(0xFFFFD8E0) : const Color(0xFFE7EFD9)),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Semantics(
        label: berry ? 'Pick berry' : 'Leaf',
        button: _choice == null,
        child: InkWell(
          key: ValueKey(berry ? 'garden-berry' : 'garden-leaf-$index'),
          onTap: _choice == null ? () => _pick(index) : null,
          child: SizedBox(
            height: 82,
            child: berry && !chosen
                ? Image.asset(
                    'assets/fruit/happy.png',
                    excludeFromSemantics: true,
                  )
                : Icon(
                    chosen
                        ? (berry ? Icons.check : Icons.close)
                        : Icons.eco_rounded,
                    color: berry
                        ? const Color(0xFF9C3552)
                        : const Color(0xFF427052),
                    size: 34,
                  ),
          ),
        ),
      ),
    );
  }
}
