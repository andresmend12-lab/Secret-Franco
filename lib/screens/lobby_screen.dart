import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_button.dart';
import '../widgets/player_avatar.dart';

/// Pantalla de lobby esperando jugadores
class LobbyScreen extends StatefulWidget {
  final String gameCode;

  const LobbyScreen({
    super.key,
    required this.gameCode,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  bool _isHost = true; // Simular que es el host
  bool _isStarting = false;

  // Jugadores de ejemplo
  final List<_LobbyPlayer> _players = [
    _LobbyPlayer(id: '1', name: 'Tú', isHost: true, isConnected: true),
    _LobbyPlayer(id: '2', name: 'Carlos', isHost: false, isConnected: true),
    _LobbyPlayer(id: '3', name: 'María', isHost: false, isConnected: true),
    _LobbyPlayer(id: '4', name: 'Pedro', isHost: false, isConnected: false),
    _LobbyPlayer(id: '5', name: 'Ana', isHost: false, isConnected: true),
  ];

  bool get _canStart =>
      _players.length >= GameConstants.minPlayers &&
      _players.length <= GameConstants.maxPlayers;

  Future<void> _startGame() async {
    if (!_canStart) return;

    setState(() => _isStarting = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.go('/game/${widget.gameCode}');
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.gameCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 20),
            const SizedBox(width: 12),
            Text('Código copiado al portapapeles'),
          ],
        ),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _leaveGame() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('¿Salir de la partida?'),
        content: Text(
          _isHost
              ? 'Como anfitrión, si sales se cancelará la partida para todos.'
              : '¿Estás seguro de que deseas abandonar la sala?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCELAR'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              context.go('/');
            },
            child: Text('SALIR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        showParticles: false,
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildCodeCard()
                          .animate()
                          .fadeIn(duration: 500.ms)
                          .slideY(begin: -0.2, end: 0),

                      const SizedBox(height: 32),

                      _buildPlayersSection()
                          .animate()
                          .fadeIn(delay: 200.ms, duration: 500.ms),

                      const SizedBox(height: 32),

                      if (_isHost) _buildHostActions(),
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

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: _leaveGame,
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
          Expanded(
            child: Text(
              'SALA DE ESPERA',
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCodeCard() {
    return GlassCard(
      child: Column(
        children: [
          Text(
            'CÓDIGO DE SALA',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.fascistGold.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Text(
                  widget.gameCode,
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundDark,
                    letterSpacing: 8,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GlowIconButton(
                icon: Icons.copy_rounded,
                onPressed: _copyCode,
                color: AppColors.fascistGold,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Comparte este código con tus amigos',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'JUGADORES',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _canStart
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _canStart
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.warning.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                '${_players.length}/${GameConstants.maxPlayers}',
                style: TextStyle(
                  color: _canStart ? AppColors.success : AppColors.warning,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ..._players.asMap().entries.map((entry) {
                return _buildPlayerTile(entry.value, entry.key)
                    .animate()
                    .fadeIn(delay: (100 * entry.key).ms)
                    .slideX(begin: -0.1, end: 0);
              }),
              if (_players.length < GameConstants.minPlayers) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: AppColors.warning, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Se necesitan al menos ${GameConstants.minPlayers} jugadores para iniciar',
                          style: TextStyle(
                            color: AppColors.warning,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTile(_LobbyPlayer player, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: player.isHost
            ? AppColors.fascistGold.withValues(alpha: 0.1)
            : AppColors.backgroundDark.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: player.isHost
            ? Border.all(
                color: AppColors.fascistGold.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: player.isHost
                  ? AppColors.goldGradient
                  : LinearGradient(
                      colors: [
                        AppColors.republicanPrimary,
                        AppColors.republicanSecondary,
                      ],
                    ),
            ),
            child: Center(
              child: Text(
                player.name[0].toUpperCase(),
                style: TextStyle(
                  color: player.isHost
                      ? AppColors.backgroundDark
                      : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Nombre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player.name,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (player.isHost) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.fascistGold,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'HOST',
                          style: TextStyle(
                            color: AppColors.backgroundDark,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: player.isConnected
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      player.isConnected ? 'Conectado' : 'Desconectado',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Número de orden
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostActions() {
    return Column(
      children: [
        PrimaryButton(
          text: 'INICIAR PARTIDA',
          icon: Icons.play_arrow_rounded,
          isLoading: _isStarting,
          onPressed: _canStart ? _startGame : null,
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 500.ms),

        if (!_canStart) ...[
          const SizedBox(height: 12),
          Text(
            'Esperando más jugadores...',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn()
              .then()
              .shimmer(duration: 1500.ms),
        ],
      ],
    );
  }
}

class _LobbyPlayer {
  final String id;
  final String name;
  final bool isHost;
  final bool isConnected;

  _LobbyPlayer({
    required this.id,
    required this.name,
    required this.isHost,
    required this.isConnected,
  });
}
