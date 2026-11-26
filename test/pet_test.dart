import 'package:berry_buddy/main.dart';
import 'package:berry_buddy/pet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('needs change mood and can be restored', () {
    const start = BerryPet();
    final played = start.play().play();
    expect(start.mood, Mood.happy);
    expect(played.mood, Mood.grumpy);
    expect(played.health, lessThan(start.health));
    final cared = played.bathe().feed(meal: true).feed(meal: true).sleep();
    expect(cared.mood, Mood.happy);
    expect(cared.health, greaterThan(start.health));
    expect(cared.bathe().bathe().clean, 100);
  });

  testWidgets('play, feed, bathe, sleep, and open the information screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BerryBuddy());
    await tester.pumpAndSettle();

    Future<void> tap(String label) async {
      final finder = find.text(label);
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    expect(find.text('Happy'), findsOneWidget);
    await tap('Play together');
    await tap('Play together');
    expect(find.text('Angry'), findsOneWidget);
    await tap('Care');
    await tap('Porridge');
    await tap('Give a bath');
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(ValueKey('soap-$i')));
      await tester.pumpAndSettle();
    }
    await tap('Finish bath');
    await tap('Toast');
    await tap('Bedtime');
    await tap('Take a nap');
    expect(find.text('Asleep'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Berry woke up rested!'), findsOneWidget);
    expect(find.text('Happy'), findsOneWidget);

    await tap('Info');
    for (final label in [
      'Privacy Policy',
      'Terms & Conditions',
      'Contact Us',
    ]) {
      await tap(label);
    }
    expect(find.textContaining('no support email configured'), findsOneWidget);
  });
}
