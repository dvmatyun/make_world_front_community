import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// {@template ShimmerAim}
/// A widget that creates a ShimmerAiming effect similar
/// to a moving highlight or reflection.
/// This is commonly used as a placeholder or loading indicator.
/// {@endtemplate}
/// {@category shaders}
class ShimmerAim extends StatefulWidget {
  /// {@macro ShimmerAim}
  const ShimmerAim({
    this.color,
    this.backgroundColor,
    this.speed = 15,
    this.stripeWidth = .2,
    this.size = const Size(128, 28),
    this.cornerRadius = 8,
    this.initialSeed = .0,
    super.key,
  });

  /// The color used for the ShimmerAiming effect,
  /// usually a light color for contrast.
  /// If not specified, defaults to the color
  /// set in the current theme's `ColorScheme.onSurface`.
  final Color? color;

  /// The color of the widget's background.
  /// Should typically contrast with [color].
  /// If not specified, defaults to the color
  /// set in the current theme's `ColorScheme.surface`.
  final Color? backgroundColor;

  /// The radius of the corners of the widget in logical pixels.
  /// Defaults to 8 logical pixels.
  final double cornerRadius;

  /// The speed of the ShimmerAiming effect, in logical pixels per second.
  /// Defaults to 0.015.
  final double speed;

  /// The width of the stripes in the ShimmerAiming effect,
  /// expressed as a fraction of the widget's width.
  /// Defaults to 0.1, meaning each stripe will be 1/10th of the widget's width.
  final double stripeWidth;

  /// The size of the widget in logical pixels.
  /// Defaults to a size of 128 logical pixels wide and 28 logical pixels tall.
  final Size size;

  /// The initial offset of the ShimmerAiming effect.
  /// Expressed as a fraction of the widget's width.
  /// Defaults to 0.0,
  /// meaning the ShimmerAiming effect starts at the leading edge of the widget.
  final double initialSeed;

  @override
  State<ShimmerAim> createState() => _ShimmerAimState();
}

class _ShimmerAimState extends State<ShimmerAim> with SingleTickerProviderStateMixin {
  /// Init shader.
  static final Future<FragmentShader?> _shaderFuture =
      FragmentProgram.fromAsset('assets/shaders/shimmer_aim.frag').then<FragmentShader?>(
    (program) => program.fragmentShader(),
    onError: (e, __) => print(' > shader error: $e'),
  );
  FragmentShader? _shader;

  /// Seed value notifier for shader mutation.
  late final ValueNotifier<double> _seed;

  /// Animated ticker.
  late final Ticker _ticker;

  void _updateSeed(Duration elapsed) => _seed.value = elapsed.inMilliseconds * widget.speed / 8000;

  @override
  void initState() {
    super.initState();
    _seed = ValueNotifier<double>(widget.initialSeed);
    _ticker = createTicker(_updateSeed)..start();
    _initAsync();
  }

  Future<void> _initAsync() async {
    _shader = await _shaderFuture;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _seed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: widget.size,
        child: RepaintBoundary(
          child: _shader == null
              ? const CircularProgressIndicator()
              : CustomPaint(
                  size: widget.size,
                  painter: _ShimmerAimPainter(
                    shader: _shader,
                    seed: _seed,
                    /* ?? Colors.grey */
                    color: widget.color ?? Theme.of(context).colorScheme.primary,
                    /* ?? Theme.of(context).colorScheme.surface */
                    backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.background,
                    cornerRadius: widget.cornerRadius,
                    stripeWidth: widget.stripeWidth,
                  ),
                ),
        ),
      );
}

class _ShimmerAimPainter extends CustomPainter {
  _ShimmerAimPainter({
    required this.seed,
    required this.color,
    required this.backgroundColor,
    required this.stripeWidth,
    required this.cornerRadius,
    required this.shader,
  }) : super(repaint: seed);

  final ValueListenable<double> seed;
  final Color color;
  final Color backgroundColor;
  final double stripeWidth;
  final double cornerRadius;
  final FragmentShader? shader;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (shader == null) return canvas.drawRect(rect, Paint()..color = backgroundColor);
    final paint = Paint()
      ..shader = (shader!
        ..setFloat(0, size.width)
        ..setFloat(1, size.height)
        ..setFloat(2, seed.value)
        ..setFloat(3, color.red / 255)
        ..setFloat(4, color.green / 255)
        ..setFloat(5, color.blue / 255)
        ..setFloat(6, color.alpha / 255)
        ..setFloat(7, backgroundColor.red / 255)
        ..setFloat(8, backgroundColor.green / 255)
        ..setFloat(9, backgroundColor.blue / 255)
        ..setFloat(10, backgroundColor.alpha / 255)
        ..setFloat(11, stripeWidth));
    canvas
      ..clipRRect(RRect.fromRectAndRadius(rect, Radius.circular(cornerRadius)))
      ..drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _ShimmerAimPainter oldDelegate) =>
      color != oldDelegate.color ||
      backgroundColor != oldDelegate.backgroundColor ||
      cornerRadius != oldDelegate.cornerRadius ||
      stripeWidth != oldDelegate.stripeWidth;
}
