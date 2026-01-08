import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/enums.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/player_avatar.dart';
import '../widgets/policy_tracker.dart';

/// Pantalla principal del juego
class GameScreen extends StatefulWidget {
  final String gameCode;

  const GameScreen({
    super.key,
    required this.gameCode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Estado de ejemplo
  GamePhase _currentPhase = GamePhase.nomination;
  int _republicanPolicies = 2;
  int _fascistPolicies = 3;
  int _electionTracker = 1;
  Role _playerRole = Role.republican;
  bool _showRole = false;

  final List<PlayerAvatarData> _players = [
    PlayerAvatarData(
        oderId: '1', name: 'Carlos', isPresident: true, isConnected: true),
    PlayerAvatarData(oderId: '2', name: 'María', isConnected: true),
    PlayerAvatarData(
        oderId: '3', name: 'Pedro', isChancellor: true, isConnected: true),
    PlayerAvatarData(oderId: '4', name: 'Ana', isConnected: true, hasVoted: true),
    PlayerAvatarData(
        oderId: '5', name: 'Luis', isAlive: false, isConnected: true),
    PlayerAvatarData(oderId: '6', name: 'Tú', isConnected: true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showParticles: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              _buildPhaseIndicator(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBoardTab(),
                    _buildPlayersTab(),
                    _buildHistoryTab(),
                  ],
                ),
              ),
              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Botón de menú
          GlowIconButton(
            icon: Icons.menu,
            onPressed: () => _showGameMenu(),
            size: 44,
          ),

          const Spacer(),

          // Código de sala
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.gameCode,
              style: GoogleFonts.sourceCodePro(
                color: AppColors.textSecondary,
                fontSize: 12,
                letterSpacing: 2,
              ),
            ),
          ),

          const Spacer(),

          // Botón de rol
          GestureDetector(
            onTap: () => setState(() => _showRole = !_showRole),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: _playerRole == Role.republican
                    ? AppColors.republicanGradient
                    : AppColors.fascistGradient,
                boxShadow: [
                  BoxShadow(
                    color: (_playerRole == Role.republican
                            ? AppColors.republicanPrimary
                            : AppColors.fascistPrimary)
                        .withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Icon(
                _showRole ? Icons.visibility : Icons.visibility_off,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.fascistGold.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flag_rounded,
            color: AppColors.fascistGold,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  _currentPhase.displayName.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.fascistGold,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentPhase.instruction,
                  textAlign: TextAlign.center,
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
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 3.seconds, color: AppColors.fascistGold.withValues(alpha: 0.1));
  }

  Widget _buildBoardTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Rol del jugador
          if (_showRole) _buildRoleCard(),

          const SizedBox(height: 20),

          // Tracker republicano
          RepublicanPolicyTracker(
            policiesEnacted: _republicanPolicies,
          ).animate().fadeIn().slideX(begin: -0.1),

          const SizedBox(height: 16),

          // Tracker franquista
          FascistPolicyTracker(
            policiesEnacted: _fascistPolicies,
          ).animate().fadeIn().slideX(begin: 0.1),

          const SizedBox(height: 16),

          // Election tracker
          ElectionTracker(
            failedElections: _electionTracker,
          ).animate().fadeIn(),

          const SizedBox(height: 24),

          // Acción actual según fase
          _buildCurrentAction(),
        ],
      ),
    );
  }

  Widget _buildRoleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: _playerRole == Role.republican
            ? AppColors.republicanGradient
            : AppColors.fascistGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (_playerRole == Role.republican
                    ? AppColors.republicanPrimary
                    : AppColors.fascistPrimary)
                .withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'TU ROL SECRETO',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _playerRole.displayName.toUpperCase(),
            style: GoogleFonts.cinzel(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _playerRole.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn()
        .scale(begin: const Offset(0.9, 0.9))
        .shimmer(duration: 1.seconds);
  }

  Widget _buildCurrentAction() {
    switch (_currentPhase) {
      case GamePhase.nomination:
        return _buildNominationAction();
      case GamePhase.voting:
        return _buildVotingAction();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildNominationAction() {
    return GlassCard(
      child: Column(
        children: [
          Icon(
            Icons.how_to_vote,
            color: AppColors.fascistGold,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Esperando nominación',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'El Presidente está eligiendo un Canciller',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVotingAction() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            'VOTA POR EL GOBIERNO',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _VoteButton(
                  label: 'JA!',
                  subtitle: 'Aprobar',
                  color: AppColors.voteYes,
                  icon: Icons.check_circle,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _VoteButton(
                  label: 'NEIN!',
                  subtitle: 'Rechazar',
                  color: AppColors.voteNo,
                  icon: Icons.cancel,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'JUGADORES EN PARTIDA',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 24),
          PlayersGrid(
            players: _players,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'HISTORIAL DE ACCIONES',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        _buildHistoryItem(
          'Política franquista aprobada',
          'Carlos y Pedro aprobaron una política',
          Icons.policy,
          AppColors.fascistPrimary,
        ),
        _buildHistoryItem(
          'Elección fallida',
          'El gobierno fue rechazado',
          Icons.how_to_vote,
          AppColors.warning,
        ),
        _buildHistoryItem(
          'Política republicana aprobada',
          'María y Ana aprobaron una política',
          Icons.policy,
          AppColors.republicanPrimary,
        ),
        _buildHistoryItem(
          'Partida iniciada',
          '6 jugadores se unieron',
          Icons.play_circle,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.textMuted,
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

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: AppColors.textMuted.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.fascistGold,
        indicatorWeight: 3,
        labelColor: AppColors.fascistGold,
        unselectedLabelColor: AppColors.textMuted,
        tabs: const [
          Tab(icon: Icon(Icons.dashboard), text: 'Tablero'),
          Tab(icon: Icon(Icons.people), text: 'Jugadores'),
          Tab(icon: Icon(Icons.history), text: 'Historial'),
        ],
      ),
    );
  }

  void _showGameMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuItem(
              Icons.menu_book,
              'Reglas del juego',
              () => Navigator.pop(context),
            ),
            _buildMenuItem(
              Icons.settings,
              'Configuración',
              () => Navigator.pop(context),
            ),
            _buildMenuItem(
              Icons.exit_to_app,
              'Abandonar partida',
              () {
                Navigator.pop(context);
                // Confirmar salida
              },
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: Text(
        text,
        style: TextStyle(color: color ?? AppColors.textPrimary),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Botón de voto
class _VoteButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _VoteButton({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.cinzel(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: color.withValues(alpha: 0.7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
