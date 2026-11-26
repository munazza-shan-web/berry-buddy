import 'package:berry_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Berry runs, eats, and jumps for a high snack', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const BerryBuddy());
    await tester.pumpAndSettle();

    Future<void> open(String label) async {
      final item = find.text(label);
      await tester.ensureVisible(item);
      await tester.tap(item);
      await tester.pumpAndSettle();
    }

    await open('Jungle Run');
    await tester.tap(find.text('Start run'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2300));
    expect(find.text('Snacks 1'), findsOneWidget);
    expect(find.text('Yum!'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.text('Snacks 2'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1400));
    await tester.tap(find.text('Jump'));
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Snacks 3'), findsOneWidget);

    await tester.pump(const Duration(seconds: 10));
    expect(find.text('Berry ate 3 of 8 trail snacks!'), findsOneWidget);
    await open('Back to camp');
    expect(find.text('Berry ate 3 snacks on the trail!'), findsOneWidget);
  });
}
