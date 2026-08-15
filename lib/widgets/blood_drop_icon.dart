import 'package:flutter/material.dart';

class TeardropIcon extends StatelessWidget {
  final double size;

  const TeardropIcon({super.key, this.size = 512});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: TeardropPainter()),
    );
  }
}

class TeardropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade900
      ..style = PaintingStyle.fill;

    final path = Path();
    // Start at the bottom rounded part
    path.moveTo(size.width / 2, size.height * 0.9);

    // Draw the teardrop shape
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.6, // Control point 1
      0,
      size.height * 0.3, // Control point 2
      size.width / 2,
      size.height * 0.05, // Top point
    );

    path.cubicTo(
      size.width,
      size.height * 0.3, // Control point 3
      size.width * 0.8,
      size.height * 0.6, // Control point 4
      size.width / 2,
      size.height * 0.9, // Back to bottom
    );

    canvas.drawPath(path, paint);

    // Add a small shine/highlight
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromLTWH(
        size.width * 0.35,
        size.height * 0.6,
        size.width * 0.15,
        size.height * 0.2,
      ),
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
