import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// Datos privados del jugador (rol secreto)
class PrivateData {
  final String oderId;
  final Role role;
  final Party party;
  final bool knowsFranco;
  final List<String> knownFascists;

  PrivateData({
    required this.oderId,
    required this.role,
    required this.party,
    required this.knowsFranco,
    required this.knownFascists,
  });

  bool get isRepublican => role == Role.republican;
  bool get isFascist => role == Role.fascist;
  bool get isFranco => role == Role.franco;

  factory PrivateData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrivateData(
      oderId: doc.id,
      role: Role.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => Role.republican,
      ),
      party: Party.values.firstWhere(
        (e) => e.name == data['party'],
        orElse: () => Party.republican,
      ),
      knowsFranco: data['knowsFranco'] ?? false,
      knownFascists: List<String>.from(data['knownFascists'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'role': role.name,
      'party': party.name,
      'knowsFranco': knowsFranco,
      'knownFascists': knownFascists,
    };
  }
}

/// Distribución de roles según número de jugadores
class RoleDistribution {
  final int republicans;
  final int fascists;
  final int franco;

  const RoleDistribution({
    required this.republicans,
    required this.fascists,
    this.franco = 1,
  });

  int get total => republicans + fascists + franco;

  static RoleDistribution forPlayerCount(int playerCount) {
    switch (playerCount) {
      case 5:
        return const RoleDistribution(republicans: 3, fascists: 1);
      case 6:
        return const RoleDistribution(republicans: 4, fascists: 1);
      case 7:
        return const RoleDistribution(republicans: 4, fascists: 2);
      case 8:
        return const RoleDistribution(republicans: 5, fascists: 2);
      case 9:
        return const RoleDistribution(republicans: 5, fascists: 3);
      case 10:
        return const RoleDistribution(republicans: 6, fascists: 3);
      default:
        throw ArgumentError('El juego requiere entre 5 y 10 jugadores');
    }
  }

  static bool francoKnowsFascists(int playerCount) {
    return playerCount <= 6;
  }
}
