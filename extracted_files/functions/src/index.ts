import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

// Tipos
interface RoleDistribution {
  republicans: number;
  fascists: number;
  franco: number;
}

type Role = 'republican' | 'fascist' | 'franco';
type Party = 'republican' | 'fascist';

/**
 * Genera un código de sala único de 6 caracteres
 */
function generateGameCode(): string {
  const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Sin I, O, 0, 1 para evitar confusión
  let code = '';
  for (let i = 0; i < 6; i++) {
    code += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return code;
}

/**
 * Obtiene la distribución de roles según el número de jugadores
 */
function getRoleDistribution(playerCount: number): RoleDistribution {
  const distributions: { [key: number]: RoleDistribution } = {
    5: { republicans: 3, fascists: 1, franco: 1 },
    6: { republicans: 4, fascists: 1, franco: 1 },
    7: { republicans: 4, fascists: 2, franco: 1 },
    8: { republicans: 5, fascists: 2, franco: 1 },
    9: { republicans: 5, fascists: 3, franco: 1 },
    10: { republicans: 6, fascists: 3, franco: 1 },
  };
  
  if (!distributions[playerCount]) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'El juego requiere entre 5 y 10 jugadores'
    );
  }
  
  return distributions[playerCount];
}

/**
 * Mezcla un array (Fisher-Yates shuffle)
 */
function shuffle<T>(array: T[]): T[] {
  const result = [...array];
  for (let i = result.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

/**
 * Crea el mazo de políticas inicial
 */
function createDeck(): string[] {
  const deck: string[] = [];
  // 6 políticas republicanas
  for (let i = 0; i < 6; i++) {
    deck.push('republican');
  }
  // 11 políticas franquistas
  for (let i = 0; i < 11; i++) {
    deck.push('fascist');
  }
  return shuffle(deck);
}

// ============================================
// CLOUD FUNCTIONS
// ============================================

/**
 * Crear una nueva partida
 */
export const createGame = functions.https.onCall(async (data, context) => {
  // Verificar autenticación
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Debes iniciar sesión para crear una partida'
    );
  }

  const userId = context.auth.uid;
  const playerName = data.playerName || 'Anfitrión';

  // Generar código único
  let code = generateGameCode();
  let attempts = 0;
  while (attempts < 10) {
    const existing = await db.collection('games').where('code', '==', code).get();
    if (existing.empty) break;
    code = generateGameCode();
    attempts++;
  }

  // Crear documento de partida
  const gameRef = db.collection('games').doc();
  const now = admin.firestore.FieldValue.serverTimestamp();

  await gameRef.set({
    code,
    hostId: userId,
    status: 'waiting',
    phase: 'nomination',
    playerOrder: [],
    presidentIndex: 0,
    chancellorId: null,
    previousPresidentId: null,
    previousChancellorId: null,
    republicanPolicies: 0,
    fascistPolicies: 0,
    electionTracker: 0,
    deck: [],
    discard: [],
    vetoEnabled: false,
    winner: null,
    winReason: null,
    currentPower: null,
    createdAt: now,
    updatedAt: now,
  });

  // Añadir al host como primer jugador
  await gameRef.collection('players').doc(userId).set({
    oderId: oderId,
    name: playerName,
    isAlive: true,
    hasVoted: false,
    vote: null,
    wasPresident: false,
    wasChancellor: false,
    isConnected: true,
    orderIndex: 0,
  });

  return {
    gameId: gameRef.id,
    code,
  };
});

/**
 * Unirse a una partida existente
 */
export const joinGame = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'Debes iniciar sesión para unirte'
    );
  }

  const userId = context.auth.uid;
  const { code, playerName } = data;

  if (!code || typeof code !== 'string') {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Código de sala inválido'
    );
  }

  // Buscar partida por código
  const gamesSnapshot = await db
    .collection('games')
    .where('code', '==', code.toUpperCase())
    .where('status', '==', 'waiting')
    .limit(1)
    .get();

  if (gamesSnapshot.empty) {
    throw new functions.https.HttpsError(
      'not-found',
      'No se encontró una partida con ese código'
    );
  }

  const gameDoc = gamesSnapshot.docs[0];
  const gameRef = gameDoc.ref;

  // Verificar si ya está en la partida
  const existingPlayer = await gameRef.collection('players').doc(userId).get();
  if (existingPlayer.exists) {
    return { gameId: gameDoc.id, alreadyJoined: true };
  }

  // Contar jugadores actuales
  const playersSnapshot = await gameRef.collection('players').get();
  if (playersSnapshot.size >= 10) {
    throw new functions.https.HttpsError(
      'resource-exhausted',
      'La partida está llena (máximo 10 jugadores)'
    );
  }

  // Añadir jugador
  await gameRef.collection('players').doc(userId).set({
    oderId: oderId,
    name: playerName || `Jugador ${playersSnapshot.size + 1}`,
    isAlive: true,
    hasVoted: false,
    vote: null,
    wasPresident: false,
    wasChancellor: false,
    isConnected: true,
    orderIndex: playersSnapshot.size,
  });

  return { gameId: gameDoc.id, alreadyJoined: false };
});

/**
 * Iniciar la partida (solo el host)
 */
export const startGame = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'No autenticado');
  }

  const userId = context.auth.uid;
  const { gameId } = data;

  const gameRef = db.collection('games').doc(gameId);
  const gameDoc = await gameRef.get();

  if (!gameDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Partida no encontrada');
  }

  const gameData = gameDoc.data()!;

  // Verificar que es el host
  if (gameData.hostId !== userId) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Solo el anfitrión puede iniciar la partida'
    );
  }

  // Verificar estado
  if (gameData.status !== 'waiting') {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'La partida ya ha comenzado'
    );
  }

  // Obtener jugadores
  const playersSnapshot = await gameRef.collection('players').get();
  const playerCount = playersSnapshot.size;

  if (playerCount < 5) {
    throw new functions.https.HttpsError(
      'failed-precondition',
      `Se necesitan al menos 5 jugadores (hay ${playerCount})`
    );
  }

  // Crear lista de jugadores y mezclar orden
  const playerIds = playersSnapshot.docs.map(doc => doc.id);
  const shuffledPlayerIds = shuffle(playerIds);

  // Obtener distribución de roles
  const distribution = getRoleDistribution(playerCount);

  // Crear array de roles y mezclarlo
  const roles: Role[] = [];
  for (let i = 0; i < distribution.republicans; i++) {
    roles.push('republican');
  }
  for (let i = 0; i < distribution.fascists; i++) {
    roles.push('fascist');
  }
  roles.push('franco');
  const shuffledRoles = shuffle(roles);

  // Identificar quién es Franco y quiénes son franquistas
  let francoId: string | null = null;
  const fascistIds: string[] = [];

  shuffledPlayerIds.forEach((oderId, index) => {
    const role = shuffledRoles[index];
    if (role === 'franco') {
      francoId = oderId;
      fascistIds.push(oderId);
    } else if (role === 'fascist') {
      fascistIds.push(oderId);
    }
  });

  // Determinar si Franco conoce a los franquistas (solo en partidas de 5-6)
  const francoKnowsFascists = playerCount <= 6;

  // Asignar roles a cada jugador (en privateData)
  const batch = db.batch();

  shuffledPlayerIds.forEach((oderId, index) => {
    const role = shuffledRoles[index];
    const party: Party = role === 'republican' ? 'republican' : 'fascist';
    
    // Determinar qué información conoce este jugador
    let knowsFranco = false;
    let knownFascists: string[] = [];

    if (role === 'fascist') {
      // Los franquistas conocen a Franco y entre ellos
      knowsFranco = true;
      knownFascists = fascistIds;
    } else if (role === 'franco') {
      // Franco conoce a los franquistas solo en partidas pequeñas
      knowsFranco = true; // Se conoce a sí mismo
      knownFascists = francoKnowsFascists ? fascistIds : [oderId];
    }
    // Los republicanos no conocen a nadie

    const privateDataRef = gameRef.collection('privateData').doc(oderId);
    batch.set(privateDataRef, {
      role,
      party,
      knowsFranco,
      knownFascists,
    });

    // Actualizar orderIndex del jugador
    const playerRef = gameRef.collection('players').doc(oderId);
    batch.update(playerRef, { orderIndex: index });
  });

  // Actualizar el documento de la partida
  const deck = createDeck();
  batch.update(gameRef, {
    status: 'playing',
    phase: 'nomination',
    playerOrder: shuffledPlayerIds,
    presidentIndex: 0,
    deck,
    discard: [],
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();

  return {
    success: true,
    playerCount,
    firstPresidentId: shuffledPlayerIds[0],
  };
});

/**
 * Nominar Jefe de Gobierno
 */
export const nominateChancellor = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'No autenticado');
  }

  const userId = context.auth.uid;
  const { gameId, nomineeId } = data;

  const gameRef = db.collection('games').doc(gameId);
  const gameDoc = await gameRef.get();

  if (!gameDoc.exists) {
    throw new functions.https.HttpsError('not-found', 'Partida no encontrada');
  }

  const gameData = gameDoc.data()!;

  // Verificar que es el presidente actual
  const currentPresidentId = gameData.playerOrder[gameData.presidentIndex];
  if (currentPresidentId !== userId) {
    throw new functions.https.HttpsError(
      'permission-denied',
      'Solo el Presidente puede nominar'
    );
  }

  // Verificar fase
  if (gameData.phase !== 'nomination') {
    throw new functions.https.HttpsError(
      'failed-precondition',
      'No es momento de nominar'
    );
  }

  // Verificar que el nominado puede ser elegido
  if (nomineeId === userId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'No puedes nominarte a ti mismo'
    );
  }

  if (nomineeId === gameData.previousChancellorId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'No puedes nominar al Jefe de Gobierno anterior'
    );
  }

  // Contar jugadores vivos
  const playersSnapshot = await gameRef.collection('players').get();
  const alivePlayers = playersSnapshot.docs.filter(doc => doc.data().isAlive);
  
  if (alivePlayers.length > 5 && nomineeId === gameData.previousPresidentId) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'No puedes nominar al Presidente anterior (con 6+ jugadores)'
    );
  }

  // Verificar que el nominado está vivo
  const nomineeDoc = await gameRef.collection('players').doc(nomineeId).get();
  if (!nomineeDoc.exists || !nomineeDoc.data()?.isAlive) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'El jugador nominado no está disponible'
    );
  }

  // Resetear votos de todos los jugadores
  const batch = db.batch();
  playersSnapshot.docs.forEach(doc => {
    batch.update(doc.ref, { hasVoted: false, vote: null });
  });

  // Actualizar partida
  batch.update(gameRef, {
    chancellorId: nomineeId,
    phase: 'voting',
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  await batch.commit();

  return { success: true, nomineeId };
});

/**
 * Registrar voto
 */
export const castVote = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'No autenticado');
  }

  const userId = context.auth.uid;
  const { gameId, vote } = data; // vote: boolean (true = Sí, false = No)

  const gameRef = db.collection('games').doc(gameId);
  
  return db.runTransaction(async (transaction) => {
    const gameDoc = await transaction.get(gameRef);
    
    if (!gameDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Partida no encontrada');
    }

    const gameData = gameDoc.data()!;

    if (gameData.phase !== 'voting') {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'No es momento de votar'
      );
    }

    // Verificar que el jugador está en la partida y vivo
    const playerRef = gameRef.collection('players').doc(userId);
    const playerDoc = await transaction.get(playerRef);

    if (!playerDoc.exists) {
      throw new functions.https.HttpsError(
        'not-found',
        'No eres parte de esta partida'
      );
    }

    const playerData = playerDoc.data()!;

    if (!playerData.isAlive) {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Los jugadores muertos no pueden votar'
      );
    }

    if (playerData.hasVoted) {
      throw new functions.https.HttpsError(
        'already-exists',
        'Ya has votado'
      );
    }

    // Registrar voto
    transaction.update(playerRef, {
      hasVoted: true,
      vote: vote,
    });

    // Verificar si todos han votado
    const playersSnapshot = await gameRef.collection('players').get();
    const alivePlayers = playersSnapshot.docs.filter(doc => doc.data().isAlive);
    const votedCount = alivePlayers.filter(doc => doc.data().hasVoted).length + 1; // +1 por el voto actual

    if (votedCount >= alivePlayers.length) {
      // Contar votos (necesitamos obtenerlos de nuevo en la transacción)
      let yesVotes = vote ? 1 : 0;
      let noVotes = vote ? 0 : 1;
      
      alivePlayers.forEach(doc => {
        if (doc.id !== userId && doc.data().hasVoted) {
          if (doc.data().vote) yesVotes++;
          else noVotes++;
        }
      });

      if (yesVotes > noVotes) {
        // Gobierno aprobado
        // Verificar si Franco fue elegido Jefe de Gobierno con 3+ políticas franquistas
        const francoDataRef = gameRef.collection('privateData').doc(gameData.chancellorId);
        const francoData = await transaction.get(francoDataRef);
        
        if (francoData.exists && 
            francoData.data()?.role === 'franco' && 
            gameData.fascistPolicies >= 3) {
          // ¡Victoria franquista!
          transaction.update(gameRef, {
            phase: 'gameOver',
            winner: 'fascists',
            winReason: 'francoElectedChancellor',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        } else {
          // Continuar al siguiente paso
          transaction.update(gameRef, {
            phase: 'presidentDiscard',
            electionTracker: 0,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      } else {
        // Gobierno rechazado
        const newElectionTracker = gameData.electionTracker + 1;
        
        if (newElectionTracker >= 3) {
          // Caos: promulgar carta superior automáticamente
          const deck = gameData.deck as string[];
          const topCard = deck.shift();
          
          let republicanPolicies = gameData.republicanPolicies;
          let fascistPolicies = gameData.fascistPolicies;
          
          if (topCard === 'republican') {
            republicanPolicies++;
          } else {
            fascistPolicies++;
          }
          
          // Verificar victoria
          let phase = 'nomination';
          let winner = null;
          let winReason = null;
          
          if (republicanPolicies >= 5) {
            phase = 'gameOver';
            winner = 'republicans';
            winReason = 'republicanPolicies';
          } else if (fascistPolicies >= 6) {
            phase = 'gameOver';
            winner = 'fascists';
            winReason = 'fascistPolicies';
          }
          
          // Siguiente presidente
          const nextPresidentIndex = (gameData.presidentIndex + 1) % gameData.playerOrder.length;
          
          transaction.update(gameRef, {
            phase,
            winner,
            winReason,
            republicanPolicies,
            fascistPolicies,
            electionTracker: 0,
            deck,
            presidentIndex: nextPresidentIndex,
            chancellorId: null,
            previousPresidentId: null,
            previousChancellorId: null,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        } else {
          // Siguiente presidente
          const nextPresidentIndex = (gameData.presidentIndex + 1) % gameData.playerOrder.length;
          
          transaction.update(gameRef, {
            phase: 'nomination',
            electionTracker: newElectionTracker,
            presidentIndex: nextPresidentIndex,
            chancellorId: null,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
          });
        }
      }
    }

    return { success: true, voteRegistered: vote };
  });
});

// Exportar más funciones según sea necesario...
// - discardPolicy (presidente descarta)
// - enactPolicy (jefe de gobierno promulga)
// - executePolicy (acciones ejecutivas)
// - etc.
