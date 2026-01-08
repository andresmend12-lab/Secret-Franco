import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

/// Logo animado del juego
class GameLogo extends StatelessWidget {
  final double size;
  final bool animate;

  const GameLogo({
    super.key,
    this.size = 120,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget logo = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icono/Símbolo
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.fascistPrimary.withValues(alpha: 0.3),
                AppColors.fascistPrimary.withValues(alpha: 0.1),
                Colors.transparent,
              ],
              stops: const [0.3, 0.6, 1.0],
            ),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Círculo exterior
                Container(
                  width: size * 0.85,
                  height: size * 0.85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.fascistGold.withValues(alpha: 0.6),
                      width: 3,
                    ),
                  ),
                ),
                // Círculo interior
                Container(
                  width: size * 0.65,
                  height: size * 0.65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.fascistPrimary,
                        AppColors.fascistSecondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.fascistPrimary.withValues(alpha: 0.6),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // Letra central
                Text(
                  'SF',
                  style: GoogleFonts.cinzel(
                    fontSize: size * 0.25,
                    fontWeight: FontWeight.bold,
                    color: AppColors.fascistGold,
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Título
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.fascistGold,
              AppColors.republicanGold,
              AppColors.fascistGold,
            ],
          ).createShader(bounds),
          child: Text(
            'SECRET',
            style: GoogleFonts.cinzel(
              fontSize: size * 0.3,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 12,
            ),
          ),
        ),

        Text(
          'FRANCO',
          style: GoogleFonts.cinzel(
            fontSize: size * 0.35,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 8,
          ),
        ),
      ],
    );

    if (animate) {
      return logo
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(
            duration: 3.seconds,
            color: AppColors.fascistGold.withValues(alpha: 0.3),
          );
    }

    return logo;
  }
}

/// Subtítulo decorativo
class DecorativeSubtitle extends StatelessWidget {
  final String text;
  final double fontSize;

  const DecorativeSubtitle({
    super.key,
    required this.text,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDivider(),
        const SizedBox(width: 16),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: AppColors.textSecondary,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(width: 16),
        _buildDivider(),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 40,
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            AppColors.fascistGold.withValues(alpha: 0.5),
          ],
        ),
      ),
    );
  }
}
