import 'package:flutter/material.dart';

class AnimationManager {
  static final AnimationManager _instance = AnimationManager._internal();

  factory AnimationManager() => _instance;

  AnimationManager._internal();

  // Shared animation controller for main menu
  late AnimationController mainMenuController;

  // Shared animation controller for fight scenes
  late AnimationController fightController;

  // Shared animation controller for wandering
  late AnimationController wanderingController;

  void initializeControllers(TickerProvider vsync) {
    mainMenuController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 10),
    )..repeat();

    fightController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 16),
    )..repeat();

    wanderingController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  void disposeControllers() {
    mainMenuController.dispose();
    fightController.dispose();
    wanderingController.dispose();
  }

  // Utility method to create a shared bobbing animation
  Animation<double> createBobbingAnimation(
    AnimationController controller, {
    double frequency = 2.0,
    double amplitude = 3.0,
    double offset = 0.0,
  }) {
    return Tween<double>(begin: 0.0, end: amplitude)
        .animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(offset, 1.0, curve: Curves.linear),
          ),
        )
        .drive(
          Tween<double>(
            begin: 0.0,
            end: amplitude,
          ).chain(CurveTween(curve: SawTooth(frequency))),
        );
  }

  // Utility method to create a shared floating animation
  Animation<Offset> createFloatingAnimation(
    AnimationController controller, {
    double startX = 0.0,
    double startY = 0.0,
    double endX = 0.0,
    double endY = -20.0,
    double delay = 0.0,
    double duration = 0.5,
  }) {
    return Tween<Offset>(
      begin: Offset(startX, startY),
      end: Offset(endX, endY),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + duration, curve: Curves.bounceInOut),
      ),
    );
  }

  // Utility method to create a shared rotation animation
  Animation<double> createRotationAnimation(
    AnimationController controller, {
    double startAngle = 0.0,
    double endAngle = 2 * 3.14159,
    double delay = 0.0,
    double duration = 1.0,
  }) {
    return Tween<double>(begin: startAngle, end: endAngle).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + duration, curve: Curves.linear),
      ),
    );
  }

  // Utility method to create a shared scale animation
  Animation<double> createScaleAnimation(
    AnimationController controller, {
    double startScale = 1.0,
    double endScale = 1.5,
    double delay = 0.0,
    double duration = 0.5,
  }) {
    return Tween<double>(begin: startScale, end: endScale).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + duration, curve: Curves.easeInOut),
      ),
    );
  }

  // Utility method to create a shared opacity animation
  Animation<double> createOpacityAnimation(
    AnimationController controller, {
    double startOpacity = 0.0,
    double endOpacity = 1.0,
    double delay = 0.0,
    double duration = 0.5,
  }) {
    return Tween<double>(begin: startOpacity, end: endOpacity).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(delay, delay + duration, curve: Curves.easeInOut),
      ),
    );
  }

  // Performance optimization: batch animation updates
  void updateAllAnimations() {
    mainMenuController.value += 0.016; // ~60fps
    fightController.value += 0.016;
    wanderingController.value += 0.016;
  }

  // Performance optimization: pause all animations when not visible
  void pauseAllAnimations() {
    mainMenuController.stop();
    fightController.stop();
    wanderingController.stop();
  }

  // Performance optimization: resume all animations
  void resumeAllAnimations() {
    mainMenuController.repeat();
    fightController.repeat();
    wanderingController.repeat();
  }
}

// Custom curve for better animation control
class SawTooth extends Curve {
  final double frequency;

  const SawTooth(this.frequency);

  @override
  double transform(double t) {
    return (t * frequency) - (t * frequency).floor();
  }
}

// Custom curve for pixel-perfect animations
class PixelCurve extends Curve {
  final double steps;

  const PixelCurve(this.steps);

  @override
  double transform(double t) {
    return ((t * steps).floor() / steps);
  }
}

// Animation performance monitor
class AnimationPerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String animationName;

  const AnimationPerformanceMonitor({
    super.key,
    required this.child,
    required this.animationName,
  });

  @override
  AnimationPerformanceMonitorState createState() =>
      AnimationPerformanceMonitorState();
}

class AnimationPerformanceMonitorState
    extends State<AnimationPerformanceMonitor> {
  DateTime? lastFrameTime;
  int frameCount = 0;
  double averageFps = 0.0;

  @override
  Widget build(BuildContext context) {
    lastFrameTime ??= DateTime.now();

    frameCount++;
    final currentTime = DateTime.now();
    final elapsed = currentTime.difference(lastFrameTime!).inMilliseconds;

    if (elapsed >= 1000) {
      averageFps = frameCount * 1000.0 / elapsed;
      frameCount = 0;
      lastFrameTime = currentTime;
    }

    return widget.child;
  }
}
