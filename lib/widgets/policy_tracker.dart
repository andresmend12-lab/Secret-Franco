import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/constants.dart';

/// Tracker de políticas republicanas
class RepublicanPolicyTracker extends StatelessWidget {
  final int policiesEnacted;
  final int totalSlots;

  const RepublicanPolicyTracker({
    super.key,
    required this.policiesEnacted,
    this.totalSlots = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.republicanPrimary.withValues(alpha: 0.3),
            AppColors.republicanSecondary.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.republicanPrimary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups,
                color: AppColors.republicanAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'REPUBLICANOS',
                style: TextStyle(
                  color: AppColors.republicanAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSlots, (index) {
              final isEnacted = index < policiesEnacted;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _PolicySlot(
                  isEnacted: isEnacted,
                  color: AppColors.republicanPrimary,
                  index: index,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '$policiesEnacted / $totalSlots',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Tracker de políticas franquistas
class FascistPolicyTracker extends StatelessWidget {
  final int policiesEnacted;
  final int totalSlots;
  final List<String> powers;

  const FascistPolicyTracker({
    super.key,
    required this.policiesEnacted,
    this.totalSlots = 6,
    this.powers = const ['', '', 'Examinar', 'Especial', 'Fusilar', 'Fusilar'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.fascistPrimary.withValues(alpha: 0.3),
            AppColors.fascistDark.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.fascistPrimary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.fascistGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'FRANQUISTAS',
                style: TextStyle(
                  color: AppColors.fascistGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSlots, (index) {
              final isEnacted = index < policiesEnacted;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _PolicySlot(
                  isEnacted: isEnacted,
                  color: AppColors.fascistPrimary,
                  index: index,
                  powerLabel: powers.length > index ? powers[index] : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            '$policiesEnacted / $totalSlots',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Slot individual de política
class _PolicySlot extends StatelessWidget {
  final bool isEnacted;
  final Color color;
  final int index;
  final String? powerLabel;

  const _PolicySlot({
    required this.isEnacted,
    required this.color,
    required this.index,
    this.powerLabel,
  });

  @override
  Widget build(BuildContext context) {
    Widget slot = Column(
      children: [
        Container(
          width: 40,
          height: 56,
          decoration: BoxDecoration(
            color: isEnacted
                ? color
                : AppColors.backgroundDark.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isEnacted
                  ? color
                  : AppColors.textMuted.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: isEnacted
                ? [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isEnacted
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 24,
                  )
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        if (powerLabel != null && powerLabel!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            powerLabel!,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );

    if (isEnacted) {
      return slot.animate().scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1, 1),
            duration: 300.ms,
            curve: Curves.elasticOut,
          );
    }

    return slot;
  }
}

/// Election tracker
class ElectionTracker extends StatelessWidget {
  final int failedElections;
  final int maxFailures;

  const ElectionTracker({
    super.key,
    required this.failedElections,
    this.maxFailures = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: failedElections >= 2
              ? AppColors.warning.withValues(alpha: 0.5)
              : AppColors.textMuted.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.how_to_vote,
            color: failedElections >= 2
                ? AppColors.warning
                : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Elecciones fallidas:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(maxFailures, (index) {
              final isFailed = index < failedElections;
              return Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFailed
                        ? AppColors.warning
                        : AppColors.backgroundDark,
                    border: Border.all(
                      color: isFailed
                          ? AppColors.warning
                          : AppColors.textMuted.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: isFailed
                      ? Icon(
                          Icons.close,
                          color: AppColors.backgroundDark,
                          size: 14,
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
