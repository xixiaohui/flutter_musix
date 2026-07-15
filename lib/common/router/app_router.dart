import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/about/presentation/pages/about_page.dart';
import '../../features/download/presentation/pages/download_page.dart';
import '../../features/equalizer/presentation/pages/equalizer_page.dart';
import '../../features/favorite/presentation/pages/favorite_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/library/presentation/pages/library_page.dart';
import '../../features/local_music/presentation/pages/local_music_page.dart';
import '../../features/lyrics/presentation/pages/lyrics_page.dart';
import '../../features/player/presentation/pages/now_playing_page.dart';
import '../../features/playlist/presentation/pages/playlist_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(path: '/splash', name: 'splash', builder: (_, __) => const SplashPage()),

      // Main Shell with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/home', name: 'home', builder: (_, __) => const HomePage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/library', name: 'library', builder: (_, __) => const LibraryPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/search', name: 'search', builder: (_, __) => const SearchPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/profile', name: 'profile', builder: (_, __) => const ProfilePage()),
          ]),
        ],
      ),

      // Detail & Feature Routes
      GoRoute(path: '/playlist/:id', name: 'playlist', builder: (_, state) => PlaylistPage(playlistId: state.pathParameters['id'])),
      GoRoute(path: '/playlist', builder: (_, __) => const PlaylistPage()),
      GoRoute(path: '/equalizer', name: 'equalizer', builder: (_, __) => const EqualizerPage()),
      GoRoute(path: '/settings', name: 'settings', builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/about', name: 'about', builder: (_, __) => const AboutPage()),
      GoRoute(path: '/favorite', name: 'favorite', builder: (_, __) => const FavoritePage()),
      GoRoute(path: '/history', name: 'history', builder: (_, __) => const HistoryPage()),
      GoRoute(path: '/download', name: 'download', builder: (_, __) => const DownloadPage()),
      GoRoute(path: '/local-music', name: 'localMusic', builder: (_, __) => const LocalMusicPage()),

      // Full-screen Overlays
      GoRoute(
        path: '/now-playing', name: 'nowPlaying',
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey, fullscreenDialog: true,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: const NowPlayingPage(),
        ),
      ),
      GoRoute(
        path: '/lyrics', name: 'lyrics',
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey, fullscreenDialog: true,
          transitionsBuilder: (_, animation, __, child) => SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: FadeTransition(opacity: animation, child: child),
          ),
          child: const LyricsPage(),
        ),
      ),
    ],
  );
});
