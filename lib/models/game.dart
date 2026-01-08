import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// Modelo principal del juego
class Game {
  final String id;
  final String code;
  final String hostId;
  final GameStatus status;
  final GamePhase phase;
  final List<String> playerOrder;
  final int presidentIndex;
  final String? chancellorId;
  final String? previousPresidentId;
  final String? previousChancellorId;
  final int republicanPolicies;
  final int fascistPolicies;
  final int electionTracker;
  final bool vetoEnabled;
  final Winner? winner;
  final WinReason? winReason;
  final ExecutivePower? currentPower;
  final DateTime createdAt;
  final DateTime updatedAt;

  Game({
    required this.id,
    required this.code,
    required this.hostId,
    required this.status,
    required this.phase,
    required this.playerOrder,
    required this.presidentIndex,
    this.chancellorId,
    this.previousPresidentId,
    this.previousChancellorId,
    required this.republicanPolicies,
    required this.fascistPolicies,
    required this.electionTracker,
    required this.vetoEnabled,
    this.winner,
    this.winReason,
    this.currentPower,
    required this.createdAt,
    required this.updatedAt,
  });

  String get currentPresidentId {
    if (playerOrder.isEmpty) return '';
    return playerOrder[presidentIndex % playerOrder.length];
  }

  int get playerCount => playerOrder.length;

  bool get isPlaying => status == GameStatus.playing;

  bool get isFinished => status == GameStatus.finished;

  bool get canVeto => vetoEnabled && fascistPolicies >= 5;

  factory Game.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      code: data['code'] ?? '',
      hostId: data['hostId'] ?? '',
      status: GameStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => GameStatus.waiting,
      ),
      phase: GamePhase.values.firstWhere(
        (e) => e.name == data['phase'],
        orElse: () => GamePhase.nomination,
      ),
      playerOrder: List<String>.from(data['playerOrder'] ?? []),
      presidentIndex: data['presidentIndex'] ?? 0,
      chancellorId: data['chancellorId'],
      previousPresidentId: data['previousPresidentId'],
      previousChancellorId: data['previousChancellorId'],
      republicanPolicies: data['republicanPolicies'] ?? 0,
      fascistPolicies: data['fascistPolicies'] ?? 0,
      electionTracker: data['electionTracker'] ?? 0,
      vetoEnabled: data['vetoEnabled'] ?? false,
      winner: data['winner'] != null
          ? Winner.values.firstWhere((e) => e.name == data['winner'])
          : null,
      winReason: data['winReason'] != null
          ? WinReason.values.firstWhere((e) => e.name == data['winReason'])
          : null,
      currentPower: data['currentPower'] != null
          ? ExecutivePower.values.firstWhere((e) => e.name == data['currentPower'])
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'hostId': hostId,
      'status': status.name,
      'phase': phase.name,
      'playerOrder': playerOrder,
      'presidentIndex': presidentIndex,
      'chancellorId': chancellorId,
      'previousPresidentId': previousPresidentId,
      'previousChancellorId': previousChancellorId,
      'republicanPolicies': republicanPolicies,
      'fascistPolicies': fascistPolicies,
      'electionTracker': electionTracker,
      'vetoEnabled': vetoEnabled,
      'winner': winner?.name,
      'winReason': winReason?.name,
      'currentPower': currentPower?.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Game copyWith({
    String? id,
    String? code,
    String? hostId,
    GameStatus? status,
    GamePhase? phase,
    List<String>? playerOrder,
    int? presidentIndex,
    String? chancellorId,
    String? previousPresidentId,
    String? previousChancellorId,
    int? republicanPolicies,
    int? fascistPolicies,
    int? electionTracker,
    bool? vetoEnabled,
    Winner? winner,
    WinReason? winReason,
    ExecutivePower? currentPower,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Game(
      id: id ?? this.id,
      code: code ?? this.code,
      hostId: hostId ?? this.hostId,
      status: status ?? this.status,
      phase: phase ?? this.phase,
      playerOrder: playerOrder ?? this.playerOrder,
      presidentIndex: presidentIndex ?? this.presidentIndex,
      chancellorId: chancellorId ?? this.chancellorId,
      previousPresidentId: previousPresidentId ?? this.previousPresidentId,
      previousChancellorId: previousChancellorId ?? this.previousChancellorId,
      republicanPolicies: republicanPolicies ?? this.republicanPolicies,
      fascistPolicies: fascistPolicies ?? this.fascistPolicies,
      electionTracker: electionTracker ?? this.electionTracker,
      vetoEnabled: vetoEnabled ?? this.vetoEnabled,
      winner: winner ?? this.winner,
      winReason: winReason ?? this.winReason,
      currentPower: currentPower ?? this.currentPower,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
