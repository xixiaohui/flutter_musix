# Musix — Theme System

## 1. 概述

基于 **Material Design 3** + **dynamic_color** + **palette_generator** 的三层主题系统：

```
Layer 1: dynamic_color   →  系统级 Material You 取色（壁纸驱动）
Layer 2: palette_generator → 封面级动态取色（当前播放歌曲驱动）
Layer 3: 手动模式          → 用户自定义主色 / 纯 Dark Mode
```

---

## 2. 主题架构

```dart
// 核心 ThemeNotifier
@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required ThemeMode themeMode,              // system / light / dark
    required Color? seedColor,                 // 用户自定义主色 (null = 系统取色)
    required Color? dynamicPrimary,            // 当前封面取色
    required bool useDynamicColor,             // 是否启用 Material You
    required bool useAlbumColor,               // 是否让封面颜色影响 UI
    required double backgroundOpacity,         // 背景透明度 (0.0-1.0)
    required LyricsBackgroundStyle lyricsBg,   // 歌词背景风格
  }) = _ThemeState;
}
```

---

## 3. Light / Dark 色板

### 3.1 Light Scheme

```dart
ColorScheme _lightScheme(Color primary) {
  return ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: primary.withOpacity(0.12),
    onPrimaryContainer: primary,
    secondary: _complementary(primary),
    onSecondary: Colors.white,
    secondaryContainer: _complementary(primary).withOpacity(0.12),
    tertiary: _analogous(primary),
    surface: const Color(0xFFFEFBFF),
    surfaceVariant: const Color(0xFFF0F0F3),
    background: const Color(0xFFFAFAFA),
    onBackground: const Color(0xFF1C1B1F),
    error: const Color(0xFFB3261E),
    outline: const Color(0xFF79747E),
    outlineVariant: const Color(0xFFC4C0CA),
  );
}
```

### 3.2 Dark Scheme

```dart
ColorScheme _darkScheme(Color primary) {
  return ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    onPrimary: const Color(0xFF1C1B1F),
    primaryContainer: primary.withOpacity(0.24),
    onPrimaryContainer: primary,
    secondary: _complementary(primary),
    onSecondary: const Color(0xFF1C1B1F),
    secondaryContainer: _complementary(primary).withOpacity(0.24),
    tertiary: _analogous(primary),
    surface: const Color(0xFF1C1B1F),
    surfaceVariant: const Color(0xFF2B2930),
    background: const Color(0xFF121212),
    onBackground: const Color(0xFFE6E1E5),
    error: const Color(0xFFF2B8B5),
    outline: const Color(0xFF938F99),
    outlineVariant: const Color(0xFF49454F),
  );
}
```

---

## 4. Dynamic Color 集成

```dart
final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    // 从数据库读取用户设置
    final savedMode = ref.watch(settingsProvider).themeMode;
    return ThemeState(
      themeMode: savedMode,
      useDynamicColor: true,
      useAlbumColor: true,
      backgroundOpacity: 0.85,
      lyricsBg: LyricsBackgroundStyle.blur,
    );
  }

  // 获取动态亮色方案
  ThemeData get lightTheme {
    final base = seedColor != null
        ? ColorScheme.fromSeed(seedColor: seedColor!, brightness: Brightness.light)
        : ColorScheme.fromSeed(
            seedColor: dynamicPrimary ?? const Color(0xFF6750A4),
            brightness: Brightness.light,
          );

    return _buildTheme(base);
  }

  // 获取动态暗色方案
  ThemeData get darkTheme {
    final base = seedColor != null
        ? ColorScheme.fromSeed(seedColor: seedColor!, brightness: Brightness.dark)
        : ColorScheme.fromSeed(
            seedColor: dynamicPrimary ?? const Color(0xFFD0BCFF),
            brightness: Brightness.dark,
          );

    return _buildTheme(base);
  }

  ThemeData _buildTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      // 字体
      textTheme: _buildTextTheme(colorScheme),
      // 组件主题
      appBarTheme: _appBarTheme(colorScheme),
      cardTheme: _cardTheme(),
      navigationBarTheme: _navBarTheme(colorScheme),
      sliderTheme: _sliderTheme(colorScheme),
      iconButtonTheme: _iconButtonTheme(colorScheme),
      inputDecorationTheme: _inputTheme(colorScheme),
      bottomSheetTheme: _bottomSheetTheme(colorScheme),
      dividerTheme: _dividerTheme(colorScheme),
      snackBarTheme: _snackBarTheme(),
      // 转场
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
```

---

## 5. 封面取色集成

```dart
// Now Playing 页面通过 palette_generator 实时取色
class NowPlayingThemeNotifier extends Notifier<NowPlayingThemeState> {
  Future<void> updateFromCover(String coverUrl) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      CachedNetworkImageProvider(coverUrl),
      size: const Size(200, 200),
      maximumColorCount: 6,
    );

    state = NowPlayingThemeState(
      dominant: paletteGenerator.dominantColor?.color,
      vibrant: paletteGenerator.vibrantColor?.color,
      lightVibrant: paletteGenerator.lightVibrantColor?.color,
      darkVibrant: paletteGenerator.darkVibrantColor?.color,
      muted: paletteGenerator.mutedColor?.color,
      lightMuted: paletteGenerator.lightMutedColor?.color,
      darkMuted: paletteGenerator.darkMutedColor?.color,
      backgroundColor: paletteGenerator.backgroundColor,
      gradients: _generateGradients(paletteGenerator),
    );
  }
}
```

---

## 6. 组件主题定制

### 6.1 Slider（进度条）

```dart
SliderThemeData _sliderTheme(ColorScheme cs) {
  return SliderThemeData(
    trackHeight: 4,
    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
    activeTrackColor: cs.primary,
    inactiveTrackColor: cs.primary.withOpacity(0.24),
    thumbColor: cs.primary,
    overlayColor: cs.primary.withOpacity(0.12),
  );
}
```

### 6.2 Card

```dart
CardTheme _cardTheme() {
  return CardTheme(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  );
}
```

### 6.3 NavigationBar

```dart
NavigationBarThemeData _navBarTheme(ColorScheme cs) {
  return NavigationBarThemeData(
    height: 64,
    elevation: 0,
    backgroundColor: cs.surface.withOpacity(0.85),
    indicatorColor: cs.secondaryContainer,
    surfaceTintColor: Colors.transparent,
    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    // 使用 BackdropFilter 实现模糊
  );
}
```

### 6.4 BottomSheet

```dart
BottomSheetThemeData _bottomSheetTheme(ColorScheme cs) {
  return BottomSheetThemeData(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: cs.surface,
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.antiAlias,
  );
}
```

---

## 7. 文本主题

```dart
TextTheme _buildTextTheme(ColorScheme cs) {
  return GoogleFonts.interTextTheme(
    Typography.material2021().black.copyWith(
      displayLarge:  TextStyle(fontSize: 57, fontWeight: FontWeight.w700, color: cs.onSurface),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w600, color: cs.onSurface),
      displaySmall:  TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: cs.onSurface),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: cs.onSurface),
      headlineMedium:TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: cs.onSurface),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: cs.onSurface),
      titleLarge:    TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: cs.onSurface),
      titleMedium:   TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: cs.onSurface),
      titleSmall:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface),
      bodyLarge:     TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: cs.onSurface),
      bodyMedium:    TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: cs.onSurface),
      bodySmall:     TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: cs.onSurfaceVariant),
      labelLarge:    TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: cs.onSurface),
      labelMedium:   TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: cs.onSurfaceVariant),
      labelSmall:    TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: cs.onSurfaceVariant),
    ),
  );
}
```

---

## 8. 自定义扩展主题

```dart
// 通过 extension 扩展 ThemeData
extension MusixTheme on ThemeData {
  // 玻璃拟态背景
  Decoration get glassDecoration => BoxDecoration(
    color: colorScheme.surface.withOpacity(0.3),
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.white.withOpacity(0.1)),
  );

  // 渐变背景
  Gradient albumGradient(List<Color> colors) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: colors,
  );

  // 阴影样式
  List<BoxShadow> get softShadow => [
    BoxShadow(
      color: colorScheme.shadow.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
```

---

## 9. 动画主题值

```dart
// 全局动画时长常量
class AppDurations {
  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 300);
  static const slow = Duration(milliseconds: 500);
  static const pageTransition = Duration(milliseconds: 400);
  static const heroAnimation = Duration(milliseconds: 500);
  static const springBounce = Duration(milliseconds: 600);
}
```

---

## 10. 文件组织

```
lib/common/theme/
├── theme.dart                # ThemeData 构建入口
├── theme_notifier.dart       # ThemeState + ThemeNotifier
├── color_schemes.dart        # Light/Dark ColorScheme 工厂
├── text_theme.dart           # TextTheme 配置
├── component_themes.dart     # 组件主题 (Slider, Card, NavBar...)
├── album_color.dart          # 封面取色逻辑
├── theme_extensions.dart     # MusixTheme extension
├── app_durations.dart        # 动画时长常量
└── theme_provider.dart       # Riverpod Provider
```

---

*下一步：FEATURES.md — 功能模块详细设计*
