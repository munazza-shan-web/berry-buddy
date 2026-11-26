import 'package:flutter/material.dart';

import 'jungle.dart';

Future<bool?> openJungleBath(BuildContext context) =>
    showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const JungleBath(),
    );

class JungleBath extends StatefulWidget {
  const JungleBath({super.key});
  @override
  State<JungleBath> createState() => _JungleBathState();
}

class _JungleBathState extends State<JungleBath> {
  static const _spots = [
    Alignment(-.31, -.14),
    Alignment(.12, -.35),
    Alignment(.29, .21),
  ];
  final _washed = <int>{};

  @override
  Widget build(BuildContext context) {
    final done = _washed.length == _spots.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Pond Bath',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                done
                    ? 'Splash! Berry is fresh and clean.'
                    : 'Tap each soap bubble to wash Berry.',
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: SizedBox(
                  height: 215,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 900),
                        builder: (context, value, child) =>
                            CustomPaint(painter: JungleArt(value, pond: true)),
                      ),
                      Align(
                        alignment: const Alignment(0, .37),
                        child: Image.asset(
                          'assets/fruit/happy.png',
                          height: 192,
                        ),
                      ),
                      for (var i = 0; i < _spots.length; i++)
                        if (!_washed.contains(i))
                          Align(
                            alignment: _spots[i],
                            child: IconButton.filledTonal(
                              key: ValueKey('soap-$i'),
                              onPressed: () => setState(() => _washed.add(i)),
                              tooltip: 'Pop soap bubble ${i + 1}',
                              icon: const Icon(Icons.bubble_chart_rounded),
                            ),
                          ),
                      if (done)
                        const Align(
                          alignment: Alignment(.61, -.58),
                          child: Icon(
                            Icons.auto_awesome_rounded,
                            color: Color(0xFF945170),
                            size: 32,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (done)
                FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Finish bath'),
                )
              else
                Text(
                  '${_washed.length} / ${_spots.length} popped',
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
