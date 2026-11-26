enum Mood { happy, grumpy, tired, hungry, messy, sleeping }

class BerryPet {
  const BerryPet({
    this.food = 55,
    this.clean = 50,
    this.rest = 55,
    this.joy = 58,
  });

  final int food, clean, rest, joy;

  int get health => ((food + clean + rest) / 3).round();

  Mood get mood => switch ((food, clean, rest, joy)) {
    (< 28, _, _, _) || (_, < 28, _, _) || (_, _, _, < 28) => Mood.grumpy,
    (_, _, < 34, _) => Mood.tired,
    (< 50, _, _, _) => Mood.hungry,
    (_, < 45, _, _) => Mood.messy,
    _ => Mood.happy,
  };

  int _change(int value, int amount) => (value + amount).clamp(0, 100);

  BerryPet feed({required bool meal}) => BerryPet(
    food: _change(food, meal ? 32 : 17),
    clean: _change(clean, meal ? -8 : -4),
    rest: rest,
    joy: _change(joy, meal ? 5 : 14),
  );

  BerryPet bathe() => BerryPet(
    food: food,
    clean: _change(clean, 42),
    rest: rest,
    joy: _change(joy, 10),
  );

  BerryPet play() => BerryPet(
    food: _change(food, -19),
    clean: _change(clean, -15),
    rest: _change(rest, -16),
    joy: _change(joy, food < 35 || clean < 35 || rest < 35 ? -12 : 24),
  );

  BerryPet run(int snacks) => BerryPet(
    food: _change(food, snacks * 7 - 12),
    clean: _change(clean, -14),
    rest: _change(rest, -16),
    joy: _change(joy, 20),
  );

  BerryPet sleep() => BerryPet(
    food: _change(food, -8),
    clean: clean,
    rest: _change(rest, 48),
    joy: _change(joy, 9),
  );
}
