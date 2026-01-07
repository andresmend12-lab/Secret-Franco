import 'package:cloud_firestore/cloud_firestore.dart';
import 'enums.dart';

/// Modelo de datos privados del jugador
/// CRÍTICO: Esta información solo es visible para el propio jugador
/// Las reglas de Firestore protegen estos datos
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

  /// Si es republicano
  bool get isRepublican => role == Role.republican;

  /// Si es franquista (incluye Franco)
  bool get isFascist => role == Role.fascist || role == Role.franco;

  /// Si es Franco
  bool get isFranco => role == Role.franco;

  /// Crear desde documento de Firestore
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

  /// Convertir a Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'role': role.name,
      'party': party.name,
      'knowsFranco': knowsFranco,
      'knownFascists': knownFascists,
    };
  }

  @override
  String toString() {
    return 'PrivateData(oderId: $oderId, role: $role, party: $party)';
  }
}

/// Lógica de asignación de roles basada en número de jugadores
class RoleDistribution {
  final int republicans;
  final int fascists;
  final int franco; // Siempre 1

  const RoleDistribution({
    required this.republicans,
    required this.fascists,
    this.franco = 1,
  });

  int get total => republicans + fascists + franco;

  /// Obtener distribución según número de jugadores
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

  /// En partidas de 5-6 jugadores, Franco sabe quiénes son los franquistas
  /// En partidas de 7+ jugadores, Franco NO conoce a los franquistas
  static bool francoKnowsFascists(int playerCount) {
    return playerCount <= 6;
  }

  /// Los franquistas siempre conocen a Franco y entre ellos
  /// (excepto Franco en partidas de 7+)
  static bool fascistsKnowEachOther(int playerCount) {
    return true; // Los franquistas siempre se conocen entre sí
  }

  @override
  String toString() {
    return 'RoleDistribution(republicans: $republicans, fascists: $fascists, franco: $franco)';
  }
}
