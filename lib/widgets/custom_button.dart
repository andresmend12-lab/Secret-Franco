import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Botón principal con gradiente y animaciones
class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final LinearGradient? gradient;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.gradient,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: widget.width ?? double.infinity,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          decoration: BoxDecoration(
            gradient: widget.onPressed == null
                ? LinearGradient(
                    colors: [
                      AppColors.textMuted.withValues(alpha: 0.3),
                      AppColors.textMuted.withValues(alpha: 0.2),
                    ],
                  )
                : widget.gradient ?? AppColors.buttonGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.onPressed != null && !_isPressed
                ? [
                    BoxShadow(
                      color: AppColors.fascistPrimary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                if (widget.icon != null) ...[
                  Icon(widget.icon, color: Colors.white, size: 22),
                  const SizedBox(width: 12),
                ],
                Text(
                  widget.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate(target: widget.onPressed != null ? 1 : 0).shimmer(
          duration: 2.seconds,
          color: Colors.white.withValues(alpha: 0.1),
        );
  }
}

/// Botón secundario con borde
class SecondaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double? width;
  final Color? borderColor;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.borderColor,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: widget.width ?? double.infinity,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
          decoration: BoxDecoration(
            color: _isPressed
                ? AppColors.surface.withValues(alpha: 0.5)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.borderColor ??
                  AppColors.fascistPrimary.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  color: widget.borderColor ?? AppColors.textPrimary,
                  size: 22,
                ),
                const SizedBox(width: 12),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.borderColor ?? AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Botón de icono con efecto glow
class GlowIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;

  const GlowIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 48,
  });

  @override
  State<GlowIconButton> createState() => _GlowIconButtonState();
}

class _GlowIconButtonState extends State<GlowIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.fascistPrimary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        width: widget.size,
        height: widget.size,
        transform: Matrix4.identity()..scale(_isPressed ? 0.9 : 1.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: _isPressed ? 0.1 : 0.3),
              blurRadius: _isPressed ? 5 : 15,
              spreadRadius: _isPressed ? 0 : 2,
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: color,
          size: widget.size * 0.5,
        ),
      ),
    );
  }
}
