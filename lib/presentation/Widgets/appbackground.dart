import 'package:flutter/material.dart';
import 'package:guyline/core/theme/appcolors.dart';

class AppBackground extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBackground({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration:  BoxDecoration(
          color: Color(0xFF141414), // Deep rich dark base
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2C2415), // Subtle warm golden highlight at top-right
              Color(0xFF141414), // Dark transitional grey
              Color(0xFF0A0A0A), // Deep dark shade towards bottom
            ],
            stops: [0.1, 0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Top-right golden glow, same color, same shape/blur as bottom-left
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: [
                      const Color(0xFF2C2415).withOpacity(0.6),
                      const Color(0xFF2C2415).withOpacity(0.0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            // Bottom-left white/soft glow, exactly like the reference image
            Positioned(
              bottom: -150,
              left: -150,
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: [
                      AppColors.textcolor1.withOpacity(0.13),
                      AppColors.textcolor1.withOpacity(0.0)
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}