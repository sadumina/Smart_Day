import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    required this.value,
    super.key,
    this.size = 96,
    this.strokeWidth = 9,
    this.label,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final progress = value.clamp(0, 1).toDouble();
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: 500.ms,
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, _) {
              return CircularProgressIndicator(
                value: animatedValue,
                strokeWidth: strokeWidth,
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
          if (label != null)
            Text(label!, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
