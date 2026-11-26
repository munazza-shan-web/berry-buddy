import 'package:berry_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('garden snacks, bath, and nap unlock the crown', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BerryBuddy());
    await tester.pumpAndSettle();

    Future<void> tap(String label) async {
      final finder = find.text(label);
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    await tap('Garden Dash');
    await tap('Start picking');
    for (var i = 0; i < 8; i++) {
      await tester.tap(find.byKey(const ValueKey('garden-berry')));
      await tester.pump(const Duration(milliseconds: 1400));
    }
    expect(find.text('Picked 8 of 8 snacks. Best streak: 8.'), findsOneWidget);
    await tap('Bring snacks home');
    await tap('Care');
    await tap('Garden snack (8)');
    expect(find.text('Garden snack (7)'), findsOneWidget);
    await tap('Give a bath');
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byKey(ValueKey('soap-$i')));
      await tester.pumpAndSettle();
    }
    await tap('Finish bath');
    await tap('Bedtime');
    await tap('Take a nap');
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    await tap('Home');
    expect(find.text('Blossom crown unlocked!'), findsOneWidget);
  });
}
