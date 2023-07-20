import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainterWidget extends CustomPainter {
  final int hours;
  final int minutes;
  ClockPainterWidget({
    required this.hours,
    required this.minutes,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw clock circle
    canvas.drawCircle(center, radius, paint);

    final hourHandPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    final minuteHandPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    final secondHandPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2.0;

    final hour = hours % 12;
    final minute = minutes;
    final second = DateTime.now().second;

    // Draw hour hand
    final hourHandX = center.dx +
        radius * 0.5 * cos(-pi / 2 + 2 * pi * (hour + minute / 60) / 12);
    final hourHandY = center.dy +
        radius * 0.5 * sin(-pi / 2 + 2 * pi * (hour + minute / 60) / 12);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Draw minute hand
    final minuteHandX =
        center.dx + radius * 0.7 * cos(-pi / 2 + 2 * pi * minute / 60);
    final minuteHandY =
        center.dy + radius * 0.7 * sin(-pi / 2 + 2 * pi * minute / 60);
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    //Draw second hand
    final secondHandX =
        center.dx + radius * 0.9 * cos(-pi / 2 + 2 * pi * second / 60);
    final secondHandY =
        center.dy + radius * 0.9 * sin(-pi / 2 + 2 * pi * second / 60);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);

    // Draw numbers
    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final numberRadius = radius * 0.85;
    for (var i = 1; i <= 12; i++) {
      final numberX = center.dx + numberRadius * cos(-pi / 2 + 2 * pi * i / 12);
      final numberY = center.dy + numberRadius * sin(-pi / 2 + 2 * pi * i / 12);

      final textSpan = TextSpan(
        text: '$i',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.text = textSpan;
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(numberX - textPainter.width / 2,
              numberY - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
