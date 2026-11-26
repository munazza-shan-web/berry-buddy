import 'dart:async';

import 'package:flutter/material.dart';

import 'info.dart';
import 'bath.dart';
import 'garden.dart';
import 'jungle.dart';
import 'runner.dart';
import 'pet.dart';

const ink = Color(0xFF263B32);
const moss = Color(0xFF32604B);
const paper = Color(0xFFFFF8EE);

enum PetAction { play, meal, snack, gardenSnack, bath }

void main() => runApp(const BerryBuddy());

class BerryBuddy extends StatelessWidget {
  const BerryBuddy({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'NoteWeave: Berry Buddy',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: moss),
      scaffoldBackgroundColor: paper,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: ink,
          fontWeight: FontWeight.w900,
          letterSpacing: -.8,
        ),
      ),
    ),
    home: const PetGame(),
  );
}

class PetGame extends StatefulWidget {
  const PetGame({super.key});

  @override
  State<PetGame> createState() => _PetGameState();
}

class _PetGameState extends State<PetGame> {
  BerryPet _pet = const BerryPet();
  int _page = 0;
  Timer? _nap;
  String _status = '';
  PetAction? _action;
  int _actionCount = 0;
  int _gardenSnacks = 0;
  bool _fedGardenSnack = false;
  bool _bathed = false;
  bool _napped = false;
  bool get _crown => _fedGardenSnack && _bathed && _napped;
  bool get _sleeping => _nap != null;
  Mood get _mood => _sleeping ? Mood.sleeping : _pet.mood;

  @override
  void dispose() {
    _nap?.cancel();
    super.dispose();
  }

  void _update(BerryPet pet, PetAction action) => setState(() {
    _pet = pet;
    _action = action;
    _actionCount++;
    if (action == PetAction.bath) _bathed = true;
    if (action == PetAction.gardenSnack) {
      _gardenSnacks--;
      _fedGardenSnack = true;
    }
    _status = switch (action) {
      PetAction.play =>
        pet.mood == Mood.grumpy
            ? 'Berry needs a break. Try food or a bath.'
            : 'Berry bounced after the ball!',
      PetAction.meal => 'Berry ate the porridge.',
      PetAction.snack => 'Berry enjoyed the toast.',
      PetAction.gardenSnack => 'Berry munched on a garden snack!',
      PetAction.bath => 'Bubble bath! Berry feels fresher.',
    };
  });

  void _startNap() {
    setState(() {
      _status = 'Berry is asleep…';
      _nap = Timer(const Duration(seconds: 3), () {
        setState(() {
          _nap = null;
          _pet = _pet.sleep();
          _napped = true;
          _status = 'Berry woke up rested!';
        });
      });
    });
  }

  Future<void> _playGarden() async {
    final snacks = await openGarden(context);
    if (!mounted || snacks == null) return;
    _update(_pet.play(), PetAction.play);
    setState(() {
      _gardenSnacks += snacks;
      _status = snacks == 0
          ? 'The garden is open for another try.'
          : 'Brought home $snacks ${snacks == 1 ? 'snack' : 'snacks'}. Visit Care to feed Berry.';
    });
  }

  Future<void> _runTrail() async {
    final food = await openJungleRun(context);
    if (!mounted || food == null || _sleeping) return;
    _update(_pet.run(food), PetAction.play);
    setState(
      () => _status = food == 0
          ? 'Berry enjoyed the jungle trail.'
          : 'Berry ate $food ${food == 1 ? 'snack' : 'snacks'} on the trail!',
    );
  }

  Future<void> _batheBerry() async {
    final washed = await openJungleBath(context);
    if (mounted && washed == true && !_sleeping) {
      _update(_pet.bathe(), PetAction.bath);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        key: PageStorageKey(_page),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/branding/logo.png',
                      height: 44,
                      semanticLabel: 'NoteWeave: Berry Buddy',
                    ),
                  ),
                  const SizedBox(height: 13),
                  switch (_page) {
                    0 => _home(),
                    1 => _care(),
                    2 => _bedtime(),
                    _ => const InfoScreen(),
                  },
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: NavigationBar(
      height: 67,
      selectedIndex: _page,
      onDestinationSelected: (page) => setState(() {
        _page = page;
        _action = null;
        if (!_sleeping) _status = '';
      }),
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.spa_rounded), label: 'Care'),
        NavigationDestination(
          icon: Icon(Icons.bedtime_rounded),
          label: 'Bedtime',
        ),
        NavigationDestination(
          icon: Icon(Icons.info_outline_rounded),
          label: 'Info',
        ),
      ],
    ),
  );

  Widget _home() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Meet Berry', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      _scene(),
      const SizedBox(height: 11),
      _panel([
        _meter(
          'Health',
          _pet.health,
          Icons.favorite_rounded,
          const Color(0xFFA33057),
        ),
        _meter(
          'Food',
          _pet.food,
          Icons.restaurant_rounded,
          const Color(0xFFB35831),
        ),
        _meter(
          'Cleanliness',
          _pet.clean,
          Icons.water_drop_rounded,
          const Color(0xFF287678),
        ),
        _meter(
          'Energy',
          _pet.rest,
          Icons.bolt_rounded,
          const Color(0xFF6F5DA5),
        ),
      ]),
      const SizedBox(height: 8),
      FilledButton.icon(
        onPressed: _sleeping ? null : _runTrail,
        icon: const Icon(Icons.directions_run_rounded),
        label: const Text('Jungle Run'),
      ),
      FilledButton.icon(
        onPressed: _sleeping
            ? null
            : () => _update(_pet.play(), PetAction.play),
        icon: const Icon(Icons.sports_baseball_rounded),
        label: const Text('Play together'),
      ),
      FilledButton.tonalIcon(
        onPressed: _sleeping ? null : _playGarden,
        icon: const Icon(Icons.local_florist_rounded),
        label: const Text('Garden Dash'),
      ),
      _feedback(),
      const SizedBox(height: 12),
      _panel([
        Row(
          children: [
            Icon(
              _crown ? Icons.emoji_events_rounded : Icons.flag_outlined,
              color: moss,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _crown ? 'Blossom crown unlocked!' : 'Blossom crown',
                style: const TextStyle(fontWeight: FontWeight.w800, color: ink),
              ),
            ),
          ],
        ),
        _milestone('Feed a garden snack', _fedGardenSnack),
        _milestone('Give a bubble bath', _bathed),
        _milestone('Finish a nap', _napped),
      ]),
    ],
  );

  Widget _milestone(String label, bool done) => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Row(
      children: [
        Icon(
          done ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 16,
          color: moss,
        ),
        const SizedBox(width: 7),
        Expanded(child: Text(label)),
      ],
    ),
  );

  Widget _care() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Care for Berry', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      _scene(compact: true),
      const SizedBox(height: 11),
      _panel([
        _meter(
          'Food',
          _pet.food,
          Icons.restaurant_rounded,
          const Color(0xFFB35831),
        ),
        _meter(
          'Cleanliness',
          _pet.clean,
          Icons.water_drop_rounded,
          const Color(0xFF287678),
        ),
      ]),
      const SizedBox(height: 9),
      Wrap(
        spacing: 7,
        runSpacing: 4,
        children: [
          FilledButton.tonalIcon(
            onPressed: _sleeping || _pet.food == 100
                ? null
                : () => _update(_pet.feed(meal: true), PetAction.meal),
            icon: const Icon(Icons.soup_kitchen_rounded),
            label: const Text('Porridge'),
          ),
          FilledButton.tonalIcon(
            onPressed: _sleeping || _pet.food == 100
                ? null
                : () => _update(_pet.feed(meal: false), PetAction.snack),
            icon: const Icon(Icons.bakery_dining_rounded),
            label: const Text('Toast'),
          ),
          FilledButton.icon(
            onPressed: _sleeping || _pet.clean == 100 ? null : _batheBerry,
            icon: const Icon(Icons.bathtub_rounded),
            label: const Text('Give a bath'),
          ),
        ],
      ),
      const SizedBox(height: 5),
      OutlinedButton.icon(
        onPressed: _sleeping || _gardenSnacks == 0 || _pet.food == 100
            ? null
            : () => _update(_pet.feed(meal: false), PetAction.gardenSnack),
        icon: const Icon(Icons.local_florist_rounded),
        label: Text('Garden snack ($_gardenSnacks)'),
      ),
      _feedback(),
    ],
  );

  Widget _bedtime() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Bedtime', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 10),
      _scene(night: true),
      const SizedBox(height: 11),
      _panel([
        _meter(
          'Energy',
          _pet.rest,
          Icons.bolt_rounded,
          const Color(0xFF6F5DA5),
        ),
      ]),
      const SizedBox(height: 9),
      FilledButton.icon(
        onPressed: _sleeping || _pet.rest == 100 ? null : _startNap,
        icon: const Icon(Icons.nightlight_round),
        label: Text(_sleeping ? 'Sleeping…' : 'Take a nap'),
      ),
      _feedback(),
    ],
  );

  Widget _feedback() => Padding(
    padding: const EdgeInsets.only(top: 5),
    child: Semantics(
      liveRegion: true,
      child: Text(
        _status.isNotEmpty
            ? _status
            : switch (_mood) {
                Mood.happy => 'Berry is ready to play.',
                Mood.grumpy => 'Berry is angry. Check what’s low.',
                Mood.tired => 'Berry could use a nap.',
                Mood.hungry => 'Try a snack from the Care screen.',
                Mood.messy => 'Berry could use a bath.',
                Mood.sleeping => 'Berry is asleep…',
              },
        textAlign: TextAlign.center,
        style: const TextStyle(color: ink),
      ),
    ),
  );

  Widget _scene({bool night = false, bool compact = false}) {
    final (label, asset) = switch (_mood) {
      Mood.happy => ('Happy', 'happy'),
      Mood.grumpy => ('Angry', 'angry'),
      Mood.tired => ('Tired', 'sleep'),
      Mood.hungry => ('Hungry', 'sad'),
      Mood.messy => ('Messy', 'sad'),
      Mood.sleeping => ('Asleep', 'sleep'),
    };
    final bubbleBath = _action == PetAction.bath;
    final eating =
        _action == PetAction.meal ||
        _action == PetAction.snack ||
        _action == PetAction.gardenSnack;
    return Container(
      height: compact ? 169 : 205,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: night
              ? const [Color(0xFF3A3964), Color(0xFF655983)]
              : const [Color(0xFFF5DCCF), Color(0xFFFFECDB)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 900),
            builder: (context, time, child) => CustomPaint(
              painter: JungleArt(time, night: night, pond: bubbleBath),
            ),
          ),
          Center(
            child: TweenAnimationBuilder<double>(
              key: ValueKey(_actionCount),
              duration: const Duration(milliseconds: 520),
              tween: Tween(begin: 0, end: 1),
              builder: (context, progress, child) => Transform.translate(
                offset: Offset(
                  0,
                  _action != null && !MediaQuery.disableAnimationsOf(context)
                      ? -28 * progress * (1 - progress)
                      : 0,
                ),
                child: child,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Image.asset(
                  'assets/fruit/$asset.png',
                  key: ValueKey(asset),
                  height: compact ? 177 : 211,
                  semanticLabel: 'Berry is ${label.toLowerCase()}',
                ),
              ),
            ),
          ),
          if (_crown)
            const Align(
              alignment: Alignment(0, -.76),
              child: Icon(
                Icons.local_florist_rounded,
                color: Color(0xFFAF4D75),
                size: 29,
              ),
            ),
          if (night && _sleeping)
            const Positioned(
              left: 30,
              bottom: 27,
              child: Icon(
                Icons.bed_rounded,
                color: Color(0xFFFFDA91),
                size: 33,
              ),
            ),
          if (_action == PetAction.play)
            const Positioned(
              right: 28,
              bottom: 25,
              child: Icon(
                Icons.sports_baseball_rounded,
                color: Color(0xFFA3504F),
                size: 31,
              ),
            ),
          if (bubbleBath)
            const Positioned(
              right: 31,
              bottom: 25,
              child: Icon(
                Icons.bubble_chart_rounded,
                color: Color(0xFF2C8388),
                size: 46,
              ),
            ),
          if (eating)
            const Positioned(
              right: 31,
              bottom: 25,
              child: Icon(
                Icons.restaurant_rounded,
                color: Color(0xFF965636),
                size: 31,
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: ink,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(List<Widget> children) => DecoratedBox(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFEEDFD3)),
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
      child: Column(children: children),
    ),
  );

  Widget _meter(String label, int value, IconData icon, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 6),
        SizedBox(
          width: 98,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value / 100,
              color: color,
              backgroundColor: const Color(0xFFF2ECE7),
              minHeight: 7,
              semanticsLabel: label,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 35, child: Text('$value%', textAlign: TextAlign.right)),
      ],
    ),
  );
}
