import 'package:flutter/material.dart';

class BloodDropIcon extends StatelessWidget {
  final double size;

  const BloodDropIcon({super.key, this.size = 512});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: BloodDropPainter(),
      ),
    );
  }
}

class BloodDropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.fill;

    final path = Path();
    // Start at the top point
    path.moveTo(size.width / 2, size.height * 0.1);
    
    // Draw the drop shape
    path.cubicTo(
      size.width * 0.2, size.height * 0.4, // Control point 1
      0, size.height * 0.7,               // Control point 2
      size.width / 2, size.height * 0.95   // Bottom point
    );
    
    path.cubicTo(
      size.width, size.height * 0.7,        // Control point 3
      size.width * 0.8, size.height * 0.4, // Control point 4
      size.width / 2, size.height * 0.1    // Back to top
    );

    canvas.drawPath(path, paint);
    
    // Add a small shine/highlight
    final shinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;
      
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.35, size.height * 0.4, size.width * 0.15, size.height * 0.2),
      shinePaint
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
