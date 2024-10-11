import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Draw the custom circular progress
          CustomPaint(
            size: Size(150, 150),
            painter: CircularProgressPainter(),
          ),
          // Text inside the circle
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '10',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text('De 40 Func.', style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint bluePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint yellowPaint = Paint()
      ..color = Colors.yellow
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2, // Starting point (top of the circle)
      3.14 * 2, // 75% of the circle
      false,
      bluePaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2, // Starting point (top of the circle)
      3.14 * 1.5, // 75% of the circle
      false,
      redPaint,
    );

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2, // Starting point (top of the circle)
      3.14 * 1.0, // 75% of the circle
      false,
      yellowPaint,
    );

    // Draw the green (25%) arc
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -3.14 / 2, // Starting point (top of the circle)
      3.14 * 0.5, // 25% of the circle
      false,
      greenPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
