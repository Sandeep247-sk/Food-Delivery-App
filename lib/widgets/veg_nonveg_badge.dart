import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class VegNonVegBadge extends StatelessWidget {
  final bool isVeg;
  final double size;

  const VegNonVegBadge({
    super.key,
    required this.isVeg,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVeg ? AppTheme.vegGreen : AppTheme.nonVegRed;

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: isVeg ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isVeg ? null : BorderRadius.circular(2),
        ),
      ),
    );
  }
}
