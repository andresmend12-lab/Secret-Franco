import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Avatar de jugador con estados visuales
class PlayerAvatar extends StatelessWidget {
  final String name;
  final bool isAlive;
  final bool isPresident;
  final bool isChancellor;
  final bool isConnected;
  final bool hasVoted;
  final bool isSelected;
  final bool isSelectable;
  final VoidCallback? onTap;
  final double size;

  const PlayerAvatar({
    super.key,
    required this.name,
    this.isAlive = true,
    this.isPresident = false,
    this.isChancellor = false,
    this.isConnected = true,
    this.hasVoted = false,
    this.isSelected = false,
    this.isSelectable = false,
    this.onTap,
    this.size = 80,
  });

  Color get _borderColor {
    if (!isAlive) return AppColors.playerDead;
    if (isPresident) return AppColors.playerPresident;
    if (isChancellor) return AppColors.playerChancellor;
    if (isSelected) return AppColors.success;
    return AppColors.textMuted.withValues(alpha: 0.5);
  }

  Color get _backgroundColor {
    if (!isAlive) return AppColors.backgroundDark;
    if (isPresident) return AppColors.playerPresident.withValues(alpha: 0.2);
    if (isChancellor) return AppColors.playerChancellor.withValues(alpha: 0.2);
    return AppColors.surface;
  }

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar = GestureDetector(
      onTap: isSelectable ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar circular
          Stack(
            children: [
              // Glow effect for special roles
              if ((isPresident || isChancellor) && isAlive)
                Container(
                  width: size + 8,
                  height: size + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _borderColor.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

              // Main avatar
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _backgroundColor,
                  border: Border.all(
                    color: _borderColor,
                    width: isPresident || isChancellor ? 3 : 2,
                  ),
                  boxShadow: isSelectable
                      ? [
                          BoxShadow(
                            color: AppColors.success.withValues(alpha: 0.3),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: isAlive
                      ? Text(
                          _initials,
                          style: TextStyle(
                            color: _borderColor,
                            fontSize: size * 0.35,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : Icon(
                          Icons.close,
                          color: AppColors.playerDead,
                          size: size * 0.4,
                        ),
                ),
              ),

              // Connection indicator
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isConnected
                        ? AppColors.success
                        : AppColors.error,
                    border: Border.all(
                      color: AppColors.backgroundDark,
                      width: 2,
                    ),
                  ),
                ),
              ),

              // Vote indicator
              if (hasVoted)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: size * 0.3,
                    height: size * 0.3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.info,
                      border: Border.all(
                        color: AppColors.backgroundDark,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: size * 0.18,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 8),

          // Name
          SizedBox(
            width: size + 20,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isAlive
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Role badge
          if (isPresident || isChancellor) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: _borderColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _borderColor.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                isPresident ? 'PRESIDENTE' : 'CANCILLER',
                style: TextStyle(
                  color: _borderColor,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (isSelectable) {
      return avatar
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 1.seconds,
          );
    }

    return avatar;
  }
}

/// Grid de jugadores
class PlayersGrid extends StatelessWidget {
  final List<PlayerAvatarData> players;
  final String? selectableForUserId;
  final Function(String oderId)? onPlayerSelected;
  final int crossAxisCount;

  const PlayersGrid({
    super.key,
    required this.players,
    this.selectableForUserId,
    this.onPlayerSelected,
    this.crossAxisCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: players.map((player) {
        final isSelectable = selectableForUserId != null &&
            player.oderId != selectableForUserId &&
            player.isAlive;

        return PlayerAvatar(
          name: player.name,
          isAlive: player.isAlive,
          isPresident: player.isPresident,
          isChancellor: player.isChancellor,
          isConnected: player.isConnected,
          hasVoted: player.hasVoted,
          isSelectable: isSelectable,
          onTap: isSelectable ? () => onPlayerSelected?.call(player.oderId) : null,
        );
      }).toList(),
    );
  }
}

/// Datos para el avatar del jugador
class PlayerAvatarData {
  final String oderId;
  final String name;
  final bool isAlive;
  final bool isPresident;
  final bool isChancellor;
  final bool isConnected;
  final bool hasVoted;

  const PlayerAvatarData({
    required this.oderId,
    required this.name,
    this.isAlive = true,
    this.isPresident = false,
    this.isChancellor = false,
    this.isConnected = true,
    this.hasVoted = false,
  });
}
