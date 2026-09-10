import 'package:flutter/material.dart';

class AppBackground1 extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AppBackground1({
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
        decoration: const BoxDecoration(
          color: Color(0xFF0D0D0D), // Deep rich dark base
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF2C2415), // Subtle warm golden highlight at top-right
              Color(0xFF141414), // Dark transitional grey
              Color(0xFF0A0A0A), // Deep dark shade towards bottom
            ],
            stops: [0.2, 0.3, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Top-right golden glow, same color, same shape/blur as bottom-left
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 400,
                height: 400,
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
              bottom: -80,
              left: -80,
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: [
                      const Color(0xFF2C2415).withOpacity(0.7),
                      const Color(0xFF2C2415).withOpacity(0.0),
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