import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReqLocIcon extends CustomPainter {

  Paint _paint;
  double   radius=10.0;
  double   lineHeight=40.0;
  Color   color=Colors.green;

  ReqLocIcon({this.radius,this.color,this.lineHeight}) {
    _paint = Paint()
      ..color = color
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), radius, _paint);
    canvas.drawRect(Offset(-1 , 0) & Size(radius/2, lineHeight), _paint);
    //canvas.drawCircle(Offset(0.0, lineHeight), radius, _paint);
    canvas.drawRect(Offset(-radius , lineHeight) & Size(radius*2, radius*2), _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
