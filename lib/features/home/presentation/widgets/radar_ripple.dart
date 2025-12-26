import 'package:flutter/material.dart';

/// 搜索时的雷达波纹动画组件
class RadarRipple extends StatelessWidget {
  final AnimationController controller;

  const RadarRipple({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _RipplePainter(controller.value),
          size: const Size(400, 400),
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;

  _RipplePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      final double offset = i * 0.3;
      final double currentProgress = (progress + offset) % 1.0;
      final double radius = maxRadius * currentProgress;
      final double opacity = 1.0 - currentProgress;

      paint.color = Colors.deepOrange.withOpacity(opacity * 0.5);
      paint.strokeWidth = 2 + (4 * currentProgress);

      canvas.drawCircle(center, radius, paint);
      
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.deepOrange.withOpacity(opacity * 0.1);
      canvas.drawCircle(center, radius, fillPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
