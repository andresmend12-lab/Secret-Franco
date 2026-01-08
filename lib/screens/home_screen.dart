import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/game_logo.dart';

/// Pantalla principal del juego
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo y título
                const GameLogo(size: 100)
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: -0.3, end: 0, duration: 600.ms),

                const SizedBox(height: 16),

                const DecorativeSubtitle(text: 'JUEGO DE DEDUCCION SOCIAL')
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 600.ms),

                const Spacer(flex: 2),

                // Botones de acción
                _buildActionButtons(context),

                const Spacer(),

                // Footer
                _buildFooter()
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Crear partida
        PrimaryButton(
          text: 'CREAR PARTIDA',
          icon: Icons.add_circle_outline,
          onPressed: () => context.push('/create'),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 400.ms),

        const SizedBox(height: 16),

        // Unirse a partida
        SecondaryButton(
          text: 'UNIRSE A PARTIDA',
          icon: Icons.login_rounded,
          onPressed: () => context.push('/join'),
        )
            .animate()
            .fadeIn(delay: 500.ms, duration: 500.ms)
            .slideY(begin: 0.3, end: 0, duration: 400.ms),

        const SizedBox(height: 32),

        // Reglas
        TextButton.icon(
          onPressed: () => _showRulesDialog(context),
          icon: Icon(
            Icons.menu_book_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
          label: Text(
            'VER REGLAS DEL JUEGO',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 500.ms),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoChip(Icons.people, '5-10 Jugadores'),
            const SizedBox(width: 16),
            _buildInfoChip(Icons.timer, '30-60 min'),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Secret Franco v1.0.0',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book_rounded,
                      color: AppColors.fascistGold, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    'Reglas del Juego',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              const Divider(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRuleSection(
                        'Objetivo',
                        'Los Republicanos deben aprobar 5 políticas republicanas o '
                            'identificar y fusilar a Franco. Los Franquistas deben aprobar '
                            '6 políticas franquistas o elegir a Franco como Canciller.',
                      ),
                      _buildRuleSection(
                        'Roles',
                        '• Republicanos: No saben quién es quién.\n'
                            '• Franquistas: Conocen a los otros franquistas.\n'
                            '• Franco: En partidas pequeñas conoce a sus aliados.',
                      ),
                      _buildRuleSection(
                        'Turnos',
                        '1. El Presidente nomina un Canciller.\n'
                            '2. Todos votan Sí o No.\n'
                            '3. Si es aprobado, el Presidente descarta una carta.\n'
                            '4. El Canciller promulga una de las dos restantes.',
                      ),
                      _buildRuleSection(
                        'Poderes Ejecutivos',
                        'Al aprobar políticas franquistas se desbloquean poderes:\n'
                            '• Examinar cartas\n'
                            '• Investigar lealtad\n'
                            '• Elección especial\n'
                            '• Fusilamiento',
                      ),
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

  Widget _buildRuleSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.fascistGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
