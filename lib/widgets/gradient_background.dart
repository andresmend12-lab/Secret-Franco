import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../utils/constants.dart';

/// Fondo con gradiente animado y partículas
class GradientBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const GradientBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<GradientBackground> createState() => _GradientBackgroundState();
}

class _GradientBackgroundState extends State<GradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo gradiente animado
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: const [
                    AppColors.backgroundDark,
                    Color(0xFF1A0A0A),
                    AppColors.backgroundMedium,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0,
                    0.5 + 0.2 * math.sin(_controller.value * 2 * math.pi),
                    1,
                  ],
                ),
              ),
            );
          },
        ),

        // Efecto de resplandor superior
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.fascistPrimary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Efecto de resplandor inferior
        Positioned(
          bottom: -150,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.republicanPrimary.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Partículas flotantes
        if (widget.showParticles) ...[
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final offset = index * 0.125;
                final y = math.sin((_controller.value + offset) * 2 * math.pi);
                final x = math.cos((_controller.value + offset) * 2 * math.pi);
                return Positioned(
                  top: MediaQuery.of(context).size.height *
                          (0.2 + index * 0.1) +
                      y * 20,
                  left: MediaQuery.of(context).size.width *
                          (0.1 + (index % 4) * 0.25) +
                      x * 15,
                  child: Container(
                    width: 4 + index % 3 * 2.0,
                    height: 4 + index % 3 * 2.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (index % 2 == 0
                              ? AppColors.fascistGold
                              : AppColors.republicanAccent)
                          .withValues(alpha: 0.3),
                      boxShadow: [
                        BoxShadow(
                          color: (index % 2 == 0
                                  ? AppColors.fascistGold
                                  : AppColors.republicanAccent)
                              .withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ],

        // Contenido
        widget.child,
      ],
    );
  }
}

/// Decorador de contenido con tarjeta glass
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.borderColor,
    this.borderRadius = AppRadius.xl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? AppColors.textMuted.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
