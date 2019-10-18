import 'package:flutter/material.dart';

class Drawhorizontalline extends CustomPainter {
  Paint _paint;
  bool reverse;
  double long;
  Color color;
  double think;
  double start;

  Drawhorizontalline(
      this.reverse, this.start, this.long, this.color, this.think) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = think
      ..strokeCap = StrokeCap.round;
  }
  @override
  void paint(Canvas canvas, Size size) {
    if (!reverse) {
      canvas.drawLine(Offset(-start, 0.0), Offset(long, 0.0), _paint);
    } else {
      canvas.drawLine(Offset(-90.0, 0.0), Offset(-10.0, 0.0), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
