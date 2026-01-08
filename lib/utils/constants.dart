import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Constantes del juego Secret Franco
class GameConstants {
  static const int minPlayers = 5;
  static const int maxPlayers = 10;
  static const int totalRepublicanPolicies = 6;
  static const int totalFascistPolicies = 11;
  static const int totalPolicies = totalRepublicanPolicies + totalFascistPolicies;
  static const int republicanPoliciesToWin = 5;
  static const int fascistPoliciesToWin = 6;
  static const int fascistPoliciesForFrancoWin = 3;
  static const int maxElectionTracker = 3;
  static const int gameCodeLength = 6;
  static const int voteTimeout = 60;
  static const int nominationTimeout = 90;
  static const int policySelectionTimeout = 30;
}

/// Colores del tema - Diseño moderno y elegante
class AppColors {
  // Gradientes principales
  static const Color republicanPrimary = Color(0xFF4A148C);
  static const Color republicanSecondary = Color(0xFF7B1FA2);
  static const Color republicanAccent = Color(0xFFE040FB);
  static const Color republicanGold = Color(0xFFFFD700);

  static const Color fascistPrimary = Color(0xFF8B0000);
  static const Color fascistSecondary = Color(0xFFB71C1C);
  static const Color fascistDark = Color(0xFF1A1A1A);
  static const Color fascistGold = Color(0xFFD4AF37);

  // Colores de fondo
  static const Color backgroundDark = Color(0xFF0D0D0D);
  static const Color backgroundMedium = Color(0xFF1A1A1A);
  static const Color backgroundLight = Color(0xFF2D2D2D);
  static const Color surface = Color(0xFF252525);
  static const Color surfaceLight = Color(0xFF3D3D3D);

  // Colores de texto
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF707070);

  // Estados
  static const Color success = Color(0xFF4CAF50);
  static const Color successDark = Color(0xFF2E7D32);
  static const Color error = Color(0xFFEF5350);
  static const Color errorDark = Color(0xFFC62828);
  static const Color warning = Color(0xFFFFB300);
  static const Color info = Color(0xFF29B6F6);

  // Votos
  static const Color voteYes = Color(0xFF4CAF50);
  static const Color voteNo = Color(0xFFEF5350);

  // Jugadores
  static const Color playerAlive = Color(0xFF4CAF50);
  static const Color playerDead = Color(0xFF616161);
  static const Color playerPresident = Color(0xFFFFD700);
  static const Color playerChancellor = Color(0xFFE040FB);

  // Gradientes
  static const LinearGradient republicanGradient = LinearGradient(
    colors: [republicanPrimary, republicanSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient fascistGradient = LinearGradient(
    colors: [fascistPrimary, fascistSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [backgroundDark, backgroundMedium],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFD4AF37), Color(0xFFB8860B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [fascistPrimary, Color(0xFFAD1457)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

/// Tema de la aplicación - Diseño oscuro elegante
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.fascistPrimary,
        secondary: AppColors.republicanPrimary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar moderno
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textPrimary,
          size: 28,
        ),
      ),

      // Cards con glassmorphism
      cardTheme: CardTheme(
        color: AppColors.surface.withValues(alpha: 0.8),
        elevation: 8,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.textMuted.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),

      // Botones elevados modernos
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fascistPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          elevation: 8,
          shadowColor: AppColors.fascistPrimary.withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      // Botones outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          side: BorderSide(
            color: AppColors.fascistPrimary.withValues(alpha: 0.8),
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.republicanAccent,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Tipografía elegante
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cinzel(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 4,
        ),
        displayMedium: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 3,
        ),
        displaySmall: GoogleFonts.cinzel(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 2,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textMuted,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),

      // Input fields modernos
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.textMuted.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.fascistPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        hintStyle: GoogleFonts.poppins(
          color: AppColors.textMuted,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.poppins(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),

      // Dialogs
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.surface,
        elevation: 24,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.cinzel(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: GoogleFonts.poppins(
          color: AppColors.textPrimary,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.textMuted.withValues(alpha: 0.2),
        thickness: 1,
        space: 24,
      ),

      // Iconos
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),

      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.fascistPrimary,
        linearTrackColor: AppColors.surfaceLight,
        circularTrackColor: AppColors.surfaceLight,
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.fascistPrimary,
        labelStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.textPrimary,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(
          color: AppColors.textMuted.withValues(alpha: 0.3),
        ),
      ),

      // Bottom sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
  static const String logoText = '$_images/logo_text.png';

  // Backgrounds
  static const String bgPattern = '$_images/bg_pattern.png';

  // Audio
  static const String soundCardFlip = '$_audio/card_flip.mp3';
  static const String soundVote = '$_audio/vote.mp3';
  static const String soundPolicy = '$_audio/policy.mp3';
  static const String soundExecution = '$_audio/execution.mp3';
  static const String soundVictory = '$_audio/victory.mp3';
  static const String soundDefeat = '$_audio/defeat.mp3';
  static const String soundTick = '$_audio/tick.mp3';
}

/// Espaciado consistente
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// Bordes redondeados consistentes
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 100;
}

/// Animaciones
class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);
}
