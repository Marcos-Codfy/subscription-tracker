// Definição do tema visual do aplicativo.
// Baseado na paleta dark com acentos em azul elétrico (#2979FF / #00B0FF)
// retirada do design de referência.

import 'package:flutter/material.dart';

/// Classe responsável por centralizar todas as definições visuais do app.
/// Seguindo o princípio de Single Responsibility, o tema fica isolado aqui.
class AppTheme {
  // Construtor privado: impede instanciação (classe utilitária)
  AppTheme._();

  // ── Paleta de Cores ──────────────────────────────────────────────────────────

  /// Cor de fundo principal — cinza escuro quase preto
  static const Color backgroundDark = Color(0xFF0D0F14);

  /// Cor de superfície dos cards — cinza médio com leve transparência
  static const Color surfaceCard = Color(0xFF1A1D27);

  /// Cor de superfície elevada — um tom mais claro para diferenciar camadas
  static const Color surfaceElevated = Color(0xFF22263A);

  /// Azul elétrico primário — cor de destaque principal (botões, ícones ativos)
  static const Color accentBlue = Color(0xFF2979FF);

  /// Azul claro secundário — usado em gradientes e destaques suaves
  static const Color accentCyan = Color(0xFF00B0FF);

  /// Roxo/índigo para ícones de categoria secundários
  static const Color accentPurple = Color(0xFF7C4DFF);

  /// Cor de texto principal — branco puro
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Cor de texto secundário — cinza claro para subtítulos
  static const Color textSecondary = Color(0xFF8A8FA8);

  /// Cor de texto desabilitado — cinza mais escuro
  static const Color textDisabled = Color(0xFF4A4F6A);

  /// Cor de erro — vermelho suave
  static const Color errorColor = Color(0xFFFF5252);

  // ── Gradientes ───────────────────────────────────────────────────────────────

  /// Gradiente azul usado nos cards de destaque e header
  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentBlue, accentCyan],
  );

  /// Gradiente de fundo sutil para cards normais
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surfaceCard, surfaceElevated],
  );

  // ── Tema Principal ───────────────────────────────────────────────────────────

  /// Retorna o [ThemeData] completo do aplicativo no modo dark.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,

      // Esquema de cores principal
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: accentCyan,
        tertiary: accentPurple,
        surface: surfaceCard,
        error: errorColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onError: textPrimary,
      ),

      // Tipografia — usando fonte do sistema mas com pesos bem definidos
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: 0.5,
        ),
      ),

      // Tema de AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Tema de BottomNavigationBar — estilo do design de referência
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceCard,
        selectedItemColor: accentBlue,
        unselectedItemColor: textDisabled,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Tema de FloatingActionButton — azul elétrico
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentBlue,
        foregroundColor: textPrimary,
        elevation: 8,
      ),

      // Tema de campos de texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: textDisabled, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        labelStyle: const TextStyle(color: textSecondary),
        hintStyle: const TextStyle(color: textDisabled),
        prefixIconColor: textSecondary,
      ),

      // Tema de SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceElevated,
        contentTextStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
