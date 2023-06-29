import "package:flutter/material.dart";
import "package:vector_math/vector_math.dart" as math;

// 全裸待機
// https://github.com/flutter/flutter/pull/122664

class MyCircularProgressIndicator extends StatelessWidget {
  const MyCircularProgressIndicator({
    required this.value,
    this.backColor = Colors.transparent,
    this.frontColor = Colors.red,
    this.strokeWidth = 2,
    super.key,
  });

  final Color backColor, frontColor;
  final double strokeWidth, value;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MyCircularProgressIndicatorPainter(
        backColor: backColor,
        frontColor: frontColor,
        strokeWidth: strokeWidth,
        value: value,
      ),
    );
  }
}

class _MyCircularProgressIndicatorPainter extends CustomPainter {
  const _MyCircularProgressIndicatorPainter({
    required this.value,
    required this.backColor,
    required this.frontColor,
    required this.strokeWidth,
  });

  final Color backColor, frontColor;
  final double strokeWidth, value;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final paint1 = Paint()
      ..strokeWidth = strokeWidth
      ..color = backColor
      ..style = PaintingStyle.stroke;
    final paint2 = Paint()
      ..strokeWidth = strokeWidth
      ..color = frontColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final r =
        Rect.fromCenter(center: Offset(w / 2, h / 2), width: w, height: h);

    canvas.drawArc(r, math.radians(0), math.radians(360), false, paint1);
    canvas.drawArc(
        r, math.radians(270), math.radians(360 * value), false, paint2);
  }

  @override
  bool shouldRepaint(_) => true;
}
