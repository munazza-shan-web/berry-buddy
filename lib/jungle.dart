import 'dart:math' as math;

import 'package:flutter/material.dart';

class JungleArt extends CustomPainter {
  const JungleArt(
    this.time, {
    this.night = false,
    this.pond = false,
    this.travel = 0,
  });
  final double time;
  final bool night, pond;
  final double travel;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 400, size.height / 240);
    const area = Rect.fromLTWH(0, 0, 400, 240);
    void oval(double x, double y, double w, double h, Color color) =>
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: w, height: h),
          Paint()..color = color,
        );
    canvas.drawRect(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: night
              ? const [Color(0xFF24335D), Color(0xFF59698B)]
              : const [Color(0xFF8CD9AF), Color(0xFFFFE5A0)],
        ).createShader(area),
    );
    oval(
      314,
      58,
      67,
      59,
      night ? const Color(0xFFFFEAB7) : const Color(0xFFFFF0BC),
    );
    for (var i = 0; i < 11; i++) {
      final x = i * 44.0 - 18;
      oval(
        x,
        155.0 + (i % 3) * 13,
        112,
        107,
        night ? const Color(0xFF466481) : const Color(0xFF84B88B),
      );
      canvas.drawRRect(
        RRect.fromLTRBR(
          x - 5,
          20 + (i % 4) * 12,
          x + 5,
          191,
          const Radius.circular(5),
        ),
        Paint()
          ..color = night ? const Color(0xFF455E76) : const Color(0xFF72A079),
      );
    }
    for (final x in [24.0, 375.0]) {
      canvas.drawRRect(
        RRect.fromLTRBR(x - 12, -15, x + 12, 207, const Radius.circular(13)),
        Paint()
          ..color = night ? const Color(0xFF374A65) : const Color(0xFF4D7051),
      );
    }
    for (var i = 0; i < 11; i++) {
      oval(
        i * 44.0 - 24,
        5 + (i % 3) * 10.0,
        96,
        61,
        night ? const Color(0xFF314B66) : const Color(0xFF43825D),
      );
    }
    canvas.drawPath(
      Path()
        ..moveTo(0, 197)
        ..quadraticBezierTo(186, 181, 400, 196)
        ..lineTo(400, 240)
        ..lineTo(0, 240)
        ..close(),
      Paint()
        ..color = night ? const Color(0xFF344F66) : const Color(0xFF5B9B65),
    );
    oval(
      211,
      225,
      370,
      58,
      night ? const Color(0xFF53677B) : const Color(0xFFDFB680),
    );
    if (!pond) {
      for (var i = 0; i < 10; i++) {
        final x = (i * 43 - travel) % 420 - 10;
        oval(x, 215.0 + (i % 3) * 7, 11, 3, const Color(0xFFBA936B));
      }
    }
    if (pond) {
      oval(207, 216, 243, 45, const Color(0xFF64C8CF));
      oval(214, 208, 143, 6, const Color(0xFF9AE1DB));
    }
    for (final x in [12.0, 47.0, 365.0, 390.0]) {
      for (var leaf = 0; leaf < 4; leaf++) {
        canvas.save();
        canvas.translate(x, 222);
        canvas.rotate((leaf - 1.5) * .43);
        oval(
          0,
          -17,
          8,
          32,
          night ? const Color(0xFF4D7681) : const Color(0xFF327B53),
        );
        canvas.restore();
      }
    }
    for (var i = 0; i < 3; i++) {
      final phase = time * math.pi * 2;
      final x = 82 + i * 110 + math.sin(phase + i * 2) * 23;
      final y = 69 + i * 22 + math.cos(phase * 2 + i) * 13;
      final spread = 4 + math.sin(phase * 8 + i).abs() * 7;
      final color = [
        const Color(0xFFF68CB9),
        const Color(0xFFFFD381),
        const Color(0xFFAE9DF1),
      ][i];
      oval(x - spread / 2, y - 2, spread, 12, color);
      oval(x + spread / 2, y - 2, spread, 12, color);
      oval(x, y, 2, 9, const Color(0xFF563A53));
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(JungleArt old) =>
      old.time != time ||
      old.night != night ||
      old.pond != pond ||
      old.travel != travel;
}
