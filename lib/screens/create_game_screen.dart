import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/gradient_background.dart';

/// Pantalla para crear una nueva partida
class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simular creación de partida
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      // Navegar al lobby con un código de ejemplo
      context.go('/lobby/ABC123');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // AppBar personalizado
              _buildAppBar(context),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // Icono
                      _buildHeaderIcon()
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .scale(begin: const Offset(0.8, 0.8)),

                      const SizedBox(height: 32),

                      // Título
                      Text(
                        'Crear Nueva Partida',
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
                        'Ingresa tu nombre para comenzar',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: 300.ms, duration: 500.ms),

                      const SizedBox(height: 48),

                      // Formulario
                      _buildForm()
                          .animate()
                          .fadeIn(delay: 400.ms, duration: 500.ms)
                          .slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 32),

                      // Información
                      _buildInfoCard()
                          .animate()
                          .fadeIn(delay: 500.ms, duration: 500.ms),
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
        gradient: AppColors.buttonGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.fascistPrimary.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const Icon(
        Icons.add_circle_outline,
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
              onFieldSubmitted: (_) => _createGame(),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'CREAR PARTIDA',
              icon: Icons.play_arrow_rounded,
              isLoading: _isLoading,
              onPressed: _createGame,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.info.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.info, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Serás el anfitrión',
                  style: TextStyle(
                    color: AppColors.info,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Podrás iniciar la partida cuando haya entre 5 y 10 jugadores.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
