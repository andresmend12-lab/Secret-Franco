# Secret Franco - Guía de Desarrollo con Claude Code

## 🎮 Descripción del Proyecto

Secret Franco es un juego de deducción social para móviles (iOS y Android), inspirado en Secret Hitler pero ambientado en la España de los años 30. Los jugadores se dividen entre Republicanos y Franquistas, con un jugador secreto siendo Franco.

## 🛠️ Stack Tecnológico

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Auth, Cloud Functions)
- **Estado:** Riverpod
- **Navegación:** GoRouter

---

## 📋 Instrucciones para Claude Code

### Paso 1: Crear el proyecto Flutter

```bash
flutter create secret_franco --org com.tudominio
cd secret_franco
```

### Paso 2: Configurar dependencias

Reemplaza el contenido de `pubspec.yaml`:

```yaml
name: secret_franco
description: Juego de deducción social - Secret Franco

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.14.0
  cloud_functions: ^4.6.0
  
  # Estado y navegación
  flutter_riverpod: ^2.4.9
  go_router: ^13.0.0
  
  # Utilidades
  uuid: ^4.2.2
  
  # UI
  flip_card: ^0.7.0
  audioplayers: ^5.2.1
  cached_network_image: ^3.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/audio/
```

### Paso 3: Instalar dependencias

```bash
flutter pub get
```

### Paso 4: Configurar Firebase

```bash
# Instalar Firebase CLI si no lo tienes
npm install -g firebase-tools

# Login
firebase login

# Instalar FlutterFire CLI
dart pub global activate flutterfire_cli

# Configurar Firebase (sigue las instrucciones)
flutterfire configure --project=tu-proyecto-firebase
```

### Paso 5: Crear estructura de carpetas

```bash
mkdir -p lib/models
mkdir -p lib/services
mkdir -p lib/providers
mkdir -p lib/screens
mkdir -p lib/widgets
mkdir -p lib/utils
mkdir -p assets/images
mkdir -p assets/audio
mkdir -p functions/src
```

### Paso 6: Copiar los archivos base

Copia los siguientes archivos de este paquete a tu proyecto:

- `lib/models/enums.dart`
- `lib/models/game.dart`
- `lib/models/player.dart`
- `lib/models/private_data.dart`
- `lib/utils/constants.dart`
- `firestore.rules`
- `functions/src/index.ts`

### Paso 7: Configurar Cloud Functions

```bash
cd functions
npm init -y
npm install firebase-functions firebase-admin typescript
npm install -D typescript @types/node
```

Crea `functions/tsconfig.json`:

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "noImplicitReturns": true,
    "noUnusedLocals": true,
    "outDir": "lib",
    "sourceMap": true,
    "strict": true,
    "target": "es2017"
  },
  "compileOnSave": true,
  "include": ["src"]
}
```

### Paso 8: Desplegar reglas y funciones

```bash
# Desde la raíz del proyecto
firebase deploy --only firestore:rules
firebase deploy --only functions
```

---

## 🎯 Orden de Desarrollo Sugerido

### Sprint 1: Configuración inicial
1. ✅ Crear proyecto Flutter
2. ✅ Configurar Firebase
3. Crear `main.dart` con inicialización de Firebase
4. Implementar `AuthService` con login anónimo
5. Crear `HomeScreen` básica

### Sprint 2: Lobby
1. Implementar `GameService.createGame()`
2. Implementar `GameService.joinGame()`
3. Crear `LobbyScreen` con lista de jugadores en tiempo real
4. Añadir funcionalidad de compartir código

### Sprint 3: Motor del juego
1. Implementar Cloud Functions restantes
2. Crear `GameProvider` con streams de Firestore
3. Implementar lógica de turnos
4. Crear `GameScreen` básica

### Sprint 4: UI del juego
1. Crear `BoardWidget` (tableros)
2. Crear `CardWidget` con animaciones
3. Crear `PlayerAvatar`
4. Implementar flujo visual de cada fase

### Sprint 5: Poderes y final
1. Implementar poderes ejecutivos
2. Crear pantalla de resultados
3. Añadir verificación de victoria

### Sprint 6: Pulido
1. Añadir sonidos
2. Mejorar animaciones
3. Crear tutorial
4. Testing

---

## 📁 Archivos Incluidos

```
secret_franco_docs/
├── Secret_Franco_GDD_Tecnico.docx    # Documento de diseño completo
├── firestore.rules                    # Reglas de seguridad
├── lib/
│   ├── models/
│   │   ├── enums.dart                # Enumeraciones
│   │   ├── game.dart                 # Modelo Game
│   │   ├── player.dart               # Modelo Player
│   │   └── private_data.dart         # Modelo PrivateData (roles)
│   └── utils/
│       └── constants.dart            # Constantes y tema
└── functions/
    └── src/
        └── index.ts                  # Cloud Functions principales
```

---

## 🖼️ Assets Necesarios

Exporta tus diseños a la carpeta `assets/images/`:

| Archivo | Descripción |
|---------|-------------|
| `role_republican.png` | Carta de rol republicano |
| `role_fascist.png` | Carta de rol franquista |
| `role_franco.png` | Carta de Franco |
| `role_fascist_hidden.png` | Silueta franquista |
| `policy_republican.png` | Política republicana |
| `policy_fascist.png` | Política franquista |
| `board_republican.png` | Tablero republicano |
| `board_fascist.png` | Tablero franquista |
| `vote_yes.png` | Carta de voto Sí |
| `vote_no.png` | Carta de voto No |
| `logo.png` | Logo del juego |
| `card_back.png` | Dorso de carta |

**Resoluciones recomendadas:**
- Cartas: 600x900 px (2x)
- Tableros: 1200x800 px (2x)
- Logo: 800x800 px (2x)

---

## 🚀 Comandos Útiles

```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en dispositivo específico
flutter run -d <device_id>

# Build para Android
flutter build apk --release

# Build para iOS
flutter build ios --release

# Ver logs de Firebase Functions
firebase functions:log

# Emulador local de Firestore
firebase emulators:start
```

---

## 📝 Prompts Útiles para Claude Code

### Crear el main.dart inicial:
```
Crea el archivo main.dart para Secret Franco con:
- Inicialización de Firebase
- ProviderScope de Riverpod
- GoRouter con rutas para home, lobby y game
- Tema personalizado de AppTheme
```

### Crear el AuthService:
```
Crea lib/services/auth_service.dart con:
- Método signInAnonymously()
- Método signOut()
- Stream de authStateChanges
- Getter para currentUser
```

### Crear el HomeScreen:
```
Crea lib/screens/home_screen.dart con:
- Logo del juego centrado
- Campo de texto para nombre
- Botón "Crear Partida"
- Campo para código + botón "Unirse"
- Usa el tema de AppColors
```

### Crear el GameService:
```
Crea lib/services/game_service.dart con:
- Método createGame() que llama a la Cloud Function
- Método joinGame(code) que llama a la Cloud Function
- Método startGame() que llama a la Cloud Function
- Stream gameStream(gameId) que escucha cambios en Firestore
- Stream playersStream(gameId) para la subcolección de jugadores
```

---

## ⚠️ Notas Importantes

1. **Seguridad:** Los roles NUNCA se envían al cliente directamente. Solo a través de `privateData` con reglas de Firestore.

2. **Tiempo real:** Usa `StreamBuilder` o `ref.watch()` de Riverpod para escuchar cambios de Firestore.

3. **Validación:** Toda la lógica crítica del juego está en Cloud Functions para prevenir trampas.

4. **Desconexiones:** Implementa presencia con `onDisconnect` de Firebase para manejar jugadores que se desconectan.

---

¡Buena suerte con el desarrollo! 🎲
