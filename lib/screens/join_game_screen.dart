import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';

/// Pantalla para unirse a una partida existente
class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _codeFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _codeFocusNode.dispose();
    super.dispose();
  }

  Future<void> _joinGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simular unión a partida
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.go('/lobby/${_codeController.text.toUpperCase()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      _buildHeaderIcon()
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .scale(begin: const Offset(0.8, 0.8)),

                      const SizedBox(height: 32),

                      Text(
                        'Unirse a Partida',
                        style: GoogleFonts.cinzel(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms),

                      const SizedBox(height: 8),

                      Text(
                        'Ingresa el código de la sala',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms),

                      const SizedBox(height: 48),

                      _buildForm()
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.republicanPrimary,
            AppColors.republicanSecondary,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.republicanPrimary.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.login_rounded,
        color: Colors.white,
        size: 48,
      ),
    );
  }

  Widget _buildForm() {
    return GlassCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de código
            Text(
              'Código de sala',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _codeController,
              focusNode: _codeFocusNode,
              style: GoogleFonts.sourceCodePro(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'ABC123',
                hintStyle: GoogleFonts.sourceCodePro(
                  color: AppColors.textMuted,
                  fontSize: 24,
                  letterSpacing: 8,
                ),
                prefixIcon: Icon(Icons.tag, color: AppColors.textMuted),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                LengthLimitingTextInputFormatter(6),
                UpperCaseTextFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el código de sala';
                }
                if (value.length != 6) {
                  return 'El código debe tener 6 caracteres';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),

            const SizedBox(height: 24),

            // Campo de nombre
            Text(
              'Tu nombre',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Ingresa tu nombre',
                prefixIcon: Icon(Icons.person_outline,
                    color: AppColors.textMuted),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor ingresa tu nombre';
                }
                if (value.trim().length < 2) {
                  return 'El nombre debe tener al menos 2 caracteres';
                }
                if (value.trim().length > 20) {
                  return 'El nombre no puede tener más de 20 caracteres';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _joinGame(),
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: 'UNIRSE',
              icon: Icons.group_add_rounded,
              isLoading: _isLoading,
              onPressed: _joinGame,
              gradient: LinearGradient(
                colors: [
                  AppColors.republicanPrimary,
                  AppColors.republicanSecondary,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Formateador para convertir texto a mayúsculas
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
