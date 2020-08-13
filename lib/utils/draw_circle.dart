


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawCircle extends CustomPainter {

  Paint _paint;
  double   radius=10.0;
  Color   color=Colors.green;

  DrawCircle({this.radius,this.color}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), radius, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
