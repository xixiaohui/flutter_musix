import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Theme Mode Provider ──
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

// ── Seed Color Provider ──
final seedColorProvider = StateProvider<Color?>((ref) => null);

// ── Light Theme ──
ThemeData buildLightTheme(ColorScheme? dynamicScheme, Color? seedColor) {
  final colorScheme = dynamicScheme ??
      ColorScheme.fromSeed(
        seedColor: seedColor ?? const Color(0xFF6750A4),
        brightness: Brightness.light,
      );

  return _buildTheme(colorScheme);
}

// ── Dark Theme ──
ThemeData buildDarkTheme(ColorScheme? dynamicScheme, Color? seedColor) {
  final colorScheme = dynamicScheme != null
      ? ColorScheme.fromSeed(
          seedColor: dynamicScheme.primary,
          brightness: Brightness.dark,
        )
      : ColorScheme.fromSeed(
          seedColor: seedColor ?? const Color(0xFFD0BCFF),
          brightness: Brightness.dark,
        );

  return _buildTheme(colorScheme);
}

// ── Shared Theme Builder ──
ThemeData _buildTheme(ColorScheme colorScheme) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    brightness: colorScheme.brightness,

    // ── AppBar ──
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),

    // ── Card ──
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
    ),

    // ── Navigation Bar ──
    navigationBarTheme: NavigationBarThemeData(
      height: 64,
      elevation: 0,
      backgroundColor: colorScheme.surface.withOpacity(0.85),
      indicatorColor: colorScheme.secondaryContainer,
      surfaceTintColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // ── Slider ──
    sliderTheme: SliderThemeData(
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.primary.withOpacity(0.24),
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withOpacity(0.12),
    ),

    // ── Icon Button ──
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
      ),
    ),

    // ── Input Decoration ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),

    // ── Bottom Sheet ──
    bottomSheetTheme: BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.antiAlias,
    ),

    // ── Divider ──
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: 0.5,
      space: 0,
    ),

    // ── Snack Bar ──
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // ── Page Transitions ──
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}

// ── App Animation Durations ──
class AppDurations {
  const AppDurations._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const pageTransition = Duration(milliseconds: 400);
  static const heroAnimation = Duration(milliseconds: 500);
  static const springBounce = Duration(milliseconds: 600);
}
