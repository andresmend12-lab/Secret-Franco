import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de jugador (datos públicos)
class Player {
  final String oderId;
  final String oderId;
  final String name;
  final bool isAlive;
  final bool hasVoted;
  final bool? vote;
  final bool wasPresident;
  final bool wasChancellor;
  final bool isConnected;
  final int orderIndex;

  Player({
    required this.oderId,
    required this.oderId,
    required this.name,
    required this.isAlive,
    required this.hasVoted,
    this.vote,
    required this.wasPresident,
    required this.wasChancellor,
    required this.isConnected,
    required this.orderIndex,
  });

  factory Player.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Player(
      oderId: doc.id,
      oderId: data['oderId'] ?? '',
      name: data['name'] ?? 'Jugador',
      isAlive: data['isAlive'] ?? true,
      hasVoted: data['hasVoted'] ?? false,
      vote: data['vote'],
      wasPresident: data['wasPresident'] ?? false,
      wasChancellor: data['wasChancellor'] ?? false,
      isConnected: data['isConnected'] ?? true,
      orderIndex: data['orderIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'oderId': oderId,
      'name': name,
      'isAlive': isAlive,
      'hasVoted': hasVoted,
      'vote': vote,
      'wasPresident': wasPresident,
      'wasChancellor': wasChancellor,
      'isConnected': isConnected,
      'orderIndex': orderIndex,
    };
  }

  Player copyWith({
    String? oderId,
    String? oderId,
    String? name,
    bool? isAlive,
    bool? hasVoted,
    bool? vote,
    bool? wasPresident,
    bool? wasChancellor,
    bool? isConnected,
    int? orderIndex,
  }) {
    return Player(
      oderId: oderId ?? this.oderId,
      oderId: oderId ?? this.oderId,
      name: name ?? this.name,
      isAlive: isAlive ?? this.isAlive,
      hasVoted: hasVoted ?? this.hasVoted,
      vote: vote ?? this.vote,
      wasPresident: wasPresident ?? this.wasPresident,
      wasChancellor: wasChancellor ?? this.wasChancellor,
      isConnected: isConnected ?? this.isConnected,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  bool canBeNominatedChancellor({
    required String currentPresidentId,
    required String? previousPresidentId,
    required String? previousChancellorId,
    required int alivePlayerCount,
  }) {
    if (oderId == currentPresidentId) return false;
    if (!isAlive) return false;
    if (oderId == previousChancellorId) return false;
    if (alivePlayerCount > 5 && oderId == previousPresidentId) return false;
    return true;
  }
}
