import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'jungle.dart';

Future<int?> openJungleRun(BuildContext context) => showModalBottomSheet<int>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  useSafeArea: true,
  builder: (_) => const JungleRun(),
);

class JungleRun extends StatefulWidget {
  const JungleRun({super.key});
  @override
  State<JungleRun> createState() => _JungleRunState();
}

class _JungleRunState extends State<JungleRun>
    with SingleTickerProviderStateMixin {
  static const _course = 15.0;
  static const _arrivals = [2.3, 3.5, 5.3, 7.0, 8.5, 10.2, 12.0, 13.5];
  static const _high = [false, false, true, false, true, false, true, false];
  late final AnimationController _clock = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 15),
  )..addListener(_tick);
  final _handled = <int>{};
  double? _jumpAt;
  double? _ateAt;
  int _food = 0;
  bool _started = false;
  double get _time => _clock.value * _course;
  bool get _finished => _clock.isCompleted;

  double get _lift {
    final jump = _jumpAt;
    if (jump == null) return 0;
    final progress = ((_time - jump) / .94).clamp(0.0, 1.0);
    return 4 * progress * (1 - progress);
  }

  void _tick() {
    final now = _time;
    for (var i = 0; i < _arrivals.length; i++) {
      if (_handled.contains(i) || (now - _arrivals[i]).abs() > .20) continue;
      final caught = _high[i] ? _lift > .36 : _lift < .30;
      if (caught) {
        _handled.add(i);
        _food++;
        _ateAt = now;
      }
    }
    setState(() {});
  }

  void _jump() {
    if (_clock.isAnimating && (_jumpAt == null || _time - _jumpAt! >= .94)) {
      setState(() => _jumpAt = _time);
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Jungle Run',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 6),
            Text(
              _finished
                  ? 'Berry ate $_food of ${_arrivals.length} trail snacks!'
                  : 'Berry runs on its own. Jump for the high snacks.',
            ),
            const SizedBox(height: 10),
            _track(),
            const SizedBox(height: 8),
            if (_started && !_finished) ...[
              LinearProgressIndicator(
                value: _clock.value,
                semanticsLabel: 'Trail progress',
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _jump,
                icon: const Icon(Icons.arrow_upward_rounded),
                label: const Text('Jump'),
              ),
            ] else
              FilledButton(
                onPressed: _finished
                    ? () => Navigator.pop(context, _food)
                    : () {
                        setState(() => _started = true);
                        _clock.forward();
                      },
                child: Text(_finished ? 'Back to camp' : 'Start run'),
              ),
          ],
        ),
      ),
    ),
  );

  Widget _track() => CallbackShortcuts(
    bindings: {const SingleActivator(LogicalKeyboardKey.space): _jump},
    child: Focus(
      autofocus: true,
      child: GestureDetector(
        onTap: _jump,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: 218,
            child: LayoutBuilder(
              builder: (context, box) {
                final runnerX = box.maxWidth * .23;
                final showEat = _ateAt != null && _time - _ateAt! < .45;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: JungleArt(_time / 5, travel: _time * 115),
                    ),
                    if (_started && !_finished)
                      for (var i = 0; i < _arrivals.length; i++)
                        if (!_handled.contains(i) &&
                            _arrivals[i] >= _time - .20 &&
                            runnerX + (_arrivals[i] - _time) * 115 <
                                box.maxWidth)
                          Positioned(
                            left: runnerX + (_arrivals[i] - _time) * 115,
                            bottom: _high[i] ? 93 : 29,
                            child: Icon(
                              _high[i]
                                  ? Icons.icecream_rounded
                                  : Icons.local_florist_rounded,
                              color: _high[i]
                                  ? const Color(0xFF913D66)
                                  : const Color(0xFFB93555),
                              size: 25,
                              semanticLabel: _high[i]
                                  ? 'High snack'
                                  : 'Trail snack',
                            ),
                          ),
                    Positioned(
                      left: runnerX - 36,
                      bottom:
                          -1 +
                          _lift * 77 +
                          (_clock.isAnimating
                              ? math.sin(_time * 28).abs() * 5
                              : 0),
                      child: Transform.rotate(
                        angle: _clock.isAnimating
                            ? math.sin(_time * 14) * .11
                            : 0,
                        child: Image.asset(
                          showEat
                              ? 'assets/fruit/sad.png'
                              : 'assets/fruit/happy.png',
                          width: 100,
                          semanticLabel: showEat ? 'Berry eating' : 'Berry',
                        ),
                      ),
                    ),
                    if (showEat)
                      Positioned(
                        left: runnerX + 33,
                        bottom: 72 + _lift * 77,
                        child: const Text(
                          'Yum!',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF76294C),
                          ),
                        ),
                      ),
                    Positioned(
                      right: 11,
                      top: 10,
                      child: Chip(label: Text('Snacks $_food')),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    ),
  );
}
