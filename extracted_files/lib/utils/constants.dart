import 'package:flutter/material.dart';

/// Constantes del juego Secret Franco
class GameConstants {
  // Límites de jugadores
  static const int minPlayers = 5;
  static const int maxPlayers = 10;

  // Cartas de política
  static const int totalRepublicanPolicies = 6;
  static const int totalFascistPolicies = 11;
  static const int totalPolicies = totalRepublicanPolicies + totalFascistPolicies;

  // Condiciones de victoria
  static const int republicanPoliciesToWin = 5;
  static const int fascistPoliciesToWin = 6;
  static const int fascistPoliciesForFrancoWin = 3;

  // Election tracker
  static const int maxElectionTracker = 3;

  // Código de sala
  static const int gameCodeLength = 6;

  // Tiempos (en segundos)
  static const int voteTimeout = 60;
  static const int nominationTimeout = 90;
  static const int policySelectionTimeout = 30;
}

/// Colores del tema
class AppColors {
  // Colores principales
  static const Color republicanPrimary = Color(0xFF4A0E4E);    // Morado republicano
  static const Color republicanSecondary = Color(0xFFD4AF37);  // Dorado
  static const Color republicanRed = Color(0xFFCC0000);        // Rojo
  static const Color republicanYellow = Color(0xFFFFD700);     // Amarillo

  static const Color fascistPrimary = Color(0xFF8B0000);       // Rojo oscuro franquista
  static const Color fascistSecondary = Color(0xFF2C2C2C);     // Negro/gris oscuro
  static const Color fascistGreen = Color(0xFF355E3B);         // Verde militar

  // Colores de UI
  static const Color background = Color(0xFFF5F5DC);           // Beige pergamino
  static const Color cardBackground = Color(0xFFE8DCC8);       // Beige carta
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF666666);

  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Votos
  static const Color voteYes = Color(0xFF8B0000);
  static const Color voteNo = Color(0xFF355E3B);
}

/// Tema de la aplicación
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.republicanPrimary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      
      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.fascistPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fascistPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.fascistPrimary,
          side: const BorderSide(color: AppColors.fascistPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.fascistPrimary, width: 2),
        ),
      ),
    );
  }
}

/// Rutas de assets
class AssetPaths {
  static const String _images = 'assets/images';
  static const String _audio = 'assets/audio';

  // Cartas de rol
  static const String roleRepublican = '$_images/role_republican.png';
  static const String roleFascist = '$_images/role_fascist.png';
  static const String roleFranco = '$_images/role_franco.png';
  static const String roleFascistHidden = '$_images/role_fascist_hidden.png';

  // Cartas de política
  static const String policyRepublican = '$_images/policy_republican.png';
  static const String policyFascist = '$_images/policy_fascist.png';
  static const String cardBack = '$_images/card_back.png';

  // Tableros
  static const String boardRepublican = '$_images/board_republican.png';
  static const String boardFascist = '$_images/board_fascist.png';

  // Votos
  static const String voteYes = '$_images/vote_yes.png';
  static const String voteNo = '$_images/vote_no.png';

  // Logo
  static const String logo = '$_images/logo.png';

  // Audio
  static const String soundCardFlip = '$_audio/card_flip.mp3';
  static const String soundVote = '$_audio/vote.mp3';
  static const String soundPolicy = '$_audio/policy.mp3';
  static const String soundExecution = '$_audio/execution.mp3';
  static const String soundVictory = '$_audio/victory.mp3';
  static const String soundDefeat = '$_audio/defeat.mp3';
}
