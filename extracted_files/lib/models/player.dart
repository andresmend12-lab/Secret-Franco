import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de jugador (datos públicos)
/// Esta información es visible para todos los jugadores de la partida
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

  /// Crear desde documento de Firestore
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

  /// Convertir a Map para Firestore
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

  /// Crear copia con modificaciones
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

  /// Si el jugador puede ser nominado como Jefe de Gobierno
  bool canBeNominatedChancellor({
    required String currentPresidentId,
    required String? previousPresidentId,
    required String? previousChancellorId,
    required int alivePlayerCount,
  }) {
    // No puede nominarse a sí mismo
    if (oderId == currentPresidentId) return false;
    
    // Debe estar vivo
    if (!isAlive) return false;
    
    // No puede ser el Jefe de Gobierno anterior
    if (oderId == previousChancellorId) return false;
    
    // Con 5 o menos jugadores vivos, el Presidente anterior SÍ puede ser nominado
    // Con 6+ jugadores vivos, el Presidente anterior NO puede ser nominado
    if (alivePlayerCount > 5 && oderId == previousPresidentId) return false;
    
    return true;
  }

  @override
  String toString() {
    return 'Player(oderId: $oderId, name: $name, isAlive: $isAlive, isConnected: $isConnected)';
  }
}
