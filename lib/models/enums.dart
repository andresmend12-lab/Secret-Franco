/// Enumeraciones para Secret Franco
/// Estos enums definen los estados y tipos usados en todo el juego.

/// Estado general de la partida
enum GameStatus {
  waiting,
  playing,
  finished,
}

/// Fases dentro de un turno de juego
enum GamePhase {
  nomination,
  voting,
  presidentDiscard,
  chancellorDiscard,
  policyReveal,
  executiveAction,
  gameOver,
}

/// Tipos de poderes ejecutivos
enum ExecutivePower {
  none,
  policyPeek,
  investigateLoyalty,
  specialElection,
  execution,
  vetoUnlocked,
}

/// Roles secretos de los jugadores
enum Role {
  republican,
  fascist,
  franco,
}

/// Afiliación de partido (lo que ve el investigador)
enum Party {
  republican,
  fascist,
}

/// Tipo de carta de política
enum PolicyType {
  republican,
  fascist,
}

/// Tipo de voto
enum VoteType {
  yes,
  no,
}

/// Equipo ganador
enum Winner {
  republicans,
  fascists,
}

/// Razón de victoria
enum WinReason {
  republicanPolicies,
  francoExecuted,
  fascistPolicies,
  francoElectedChancellor,
}

// Extensiones útiles para los enums

extension GameStatusX on GameStatus {
  String get displayName {
    switch (this) {
      case GameStatus.waiting:
        return 'Esperando jugadores';
      case GameStatus.playing:
        return 'En partida';
      case GameStatus.finished:
        return 'Finalizada';
    }
  }

  String get icon {
    switch (this) {
      case GameStatus.waiting:
        return '⏳';
      case GameStatus.playing:
        return '🎮';
      case GameStatus.finished:
        return '🏁';
    }
  }
}

extension GamePhaseX on GamePhase {
  String get displayName {
    switch (this) {
      case GamePhase.nomination:
        return 'Nominación';
      case GamePhase.voting:
        return 'Votación';
      case GamePhase.presidentDiscard:
        return 'Turno del Presidente';
      case GamePhase.chancellorDiscard:
        return 'Turno del Canciller';
      case GamePhase.policyReveal:
        return 'Revelando política';
      case GamePhase.executiveAction:
        return 'Poder ejecutivo';
      case GamePhase.gameOver:
        return 'Fin de la partida';
    }
  }

  String get instruction {
    switch (this) {
      case GamePhase.nomination:
        return 'El Presidente debe nominar un Canciller';
      case GamePhase.voting:
        return 'Vota Sí o No al gobierno propuesto';
      case GamePhase.presidentDiscard:
        return 'Elige una carta para descartar';
      case GamePhase.chancellorDiscard:
        return 'Elige una política para promulgar';
      case GamePhase.policyReveal:
        return 'Se ha promulgado una nueva política';
      case GamePhase.executiveAction:
        return 'El Presidente debe usar su poder ejecutivo';
      case GamePhase.gameOver:
        return 'La partida ha terminado';
    }
  }
}

extension RoleX on Role {
  String get displayName {
    switch (this) {
      case Role.republican:
        return 'Republicano';
      case Role.fascist:
        return 'Franquista';
      case Role.franco:
        return 'Franco';
    }
  }

  String get description {
    switch (this) {
      case Role.republican:
        return 'Eres un miembro leal del Partido Republicano. Aprueba 5 políticas republicanas o identifica y fusila a Franco para ganar.';
      case Role.fascist:
        return 'Eres un miembro del Partido Franquista. Ayuda a Franco a llegar al poder o aprueba 6 políticas franquistas.';
      case Role.franco:
        return 'Eres Franco, el Caudillo. Hazte elegir Canciller después de 3 políticas franquistas o aprueba 6 para ganar.';
    }
  }

  Party get party {
    switch (this) {
      case Role.republican:
        return Party.republican;
      case Role.fascist:
      case Role.franco:
        return Party.fascist;
    }
  }
}

extension ExecutivePowerX on ExecutivePower {
  String get displayName {
    switch (this) {
      case ExecutivePower.none:
        return 'Ninguno';
      case ExecutivePower.policyPeek:
        return 'Examinar cartas';
      case ExecutivePower.investigateLoyalty:
        return 'Investigar lealtad';
      case ExecutivePower.specialElection:
        return 'Elección especial';
      case ExecutivePower.execution:
        return 'Fusilamiento';
      case ExecutivePower.vetoUnlocked:
        return 'Veto desbloqueado';
    }
  }

  String get description {
    switch (this) {
      case ExecutivePower.none:
        return '';
      case ExecutivePower.policyPeek:
        return 'El Presidente examina las próximas 3 cartas del mazo.';
      case ExecutivePower.investigateLoyalty:
        return 'El Presidente investiga la afiliación de partido de un jugador.';
      case ExecutivePower.specialElection:
        return 'El Presidente elige quién será el próximo Presidente.';
      case ExecutivePower.execution:
        return 'El Presidente debe fusilar a un jugador.';
      case ExecutivePower.vetoUnlocked:
        return 'El gobierno ahora puede vetar la legislación.';
    }
  }

  String get icon {
    switch (this) {
      case ExecutivePower.none:
        return '';
      case ExecutivePower.policyPeek:
        return '👁️';
      case ExecutivePower.investigateLoyalty:
        return '🔍';
      case ExecutivePower.specialElection:
        return '🗳️';
      case ExecutivePower.execution:
        return '💀';
      case ExecutivePower.vetoUnlocked:
        return '🚫';
    }
  }
}

extension WinnerX on Winner {
  String get displayName {
    switch (this) {
      case Winner.republicans:
        return 'Republicanos';
      case Winner.fascists:
        return 'Franquistas';
    }
  }
}

extension WinReasonX on WinReason {
  String get displayName {
    switch (this) {
      case WinReason.republicanPolicies:
        return '5 políticas republicanas aprobadas';
      case WinReason.francoExecuted:
        return 'Franco ha sido fusilado';
      case WinReason.fascistPolicies:
        return '6 políticas franquistas aprobadas';
      case WinReason.francoElectedChancellor:
        return 'Franco elegido Canciller';
    }
  }
}
