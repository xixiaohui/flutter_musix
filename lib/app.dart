import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'common/theme/theme.dart';
import 'common/router/app_router.dart';

/// The root widget of Musix.
class MelodifyApp extends ConsumerWidget {
  const MelodifyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final seedColor = ref.watch(seedColorProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp.router(
          title: 'Melodify',
          debugShowCheckedModeBanner: false,

          // Theme
          theme: buildLightTheme(lightDynamic, seedColor),
          darkTheme: buildDarkTheme(darkDynamic, seedColor),
          themeMode: themeMode,
          highContrastTheme: buildLightTheme(lightDynamic, seedColor),
          highContrastDarkTheme: buildDarkTheme(darkDynamic, seedColor),

          // Router
          routerConfig: router,

          // Localization (placeholder)
          // locale: ref.watch(localeProvider),
          // supportedLocales: AppLocalizations.supportedLocales,
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
        );
      },
    );
  }
}
