import 'package:flutter/material.dart';

class CustomCircularProgress extends StatelessWidget {
  final int workingCount;
  final int totalEmployees;

  const CustomCircularProgress({
    super.key,
    required this.workingCount,
    required this.totalEmployees,
  });

  @override
  Widget build(BuildContext context) {
    final notWorkingCount = totalEmployees - workingCount;

    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(150, 150),
            painter: CircularProgressPainter(
              workingCount: workingCount,
              notWorkingCount: notWorkingCount,
              totalEmployees: totalEmployees,
            ),
          ),
          Positioned(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$workingCount',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'De $totalEmployees Func.',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final int workingCount;
  final int notWorkingCount;
  final int totalEmployees;

  CircularProgressPainter({
    required this.workingCount,
    required this.notWorkingCount,
    required this.totalEmployees,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final workingFraction = workingCount / totalEmployees;
    final notWorkingFraction = notWorkingCount / totalEmployees;

    Paint greenPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    Paint redPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(
      rect,
      -3.14 / 2,
      3.14 * 2 * workingFraction,
      false,
      greenPaint,
    );

    canvas.drawArc(
      rect,
      -3.14 / 2 + 3.14 * 2 * workingFraction,
      3.14 * 2 * notWorkingFraction,
      false,
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
