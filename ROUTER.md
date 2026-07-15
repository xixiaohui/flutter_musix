# Musix — Router Design (go_router)

## 1. 概述

使用 **go_router** 实现声明式路由，支持：
- 嵌套导航（ShellRoute 底部 Tab）
- 深度链接
- Hero / Shared Element 转场
- 重定向守卫
- 状态保持（StatefulShellRoute）

---

## 2. 路由拓扑图

```
/splash
    │
    ▼
ShellRoute (BottomNavigationBar)
├── /home                    ── Tab 0
├── /library                 ── Tab 1
├── /search                  ── Tab 2
├── /profile                 ── Tab 3
│
├── /playlist/:id
├── /playlist/:id/song/:sid
├── /album/:id
├── /album/:id/song/:sid
├── /artist/:id
├── /song/:id
│
├── /search/result?q=xxx&type=song
│
├── /favorite
├── /history
├── /download
├── /local-music
├── /equalizer
├── /settings
├── /about
│
└── (full screen overlay)
    ├── /now-playing
    ├── /lyrics
    └── /queue
```

---

## 3. 路由实现

### 3.1 AppRouter 入口

```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(
          navigationShell: navigationShell,
        ),
        branches: [
          // ── Home Tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          // ── Library Tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                name: 'library',
                builder: (context, state) => const LibraryPage(),
              ),
            ],
          ),
          // ── Search Tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchPage(),
                routes: [
                  GoRoute(
                    path: 'result',
                    name: 'searchResult',
                    builder: (context, state) => SearchResultPage(
                      query: state.uri.queryParameters['q'] ?? '',
                      type: state.uri.queryParameters['type'] ?? 'song',
                    ),
                  ),
                ],
              ),
            ],
          ),
          // ── Profile Tab ──
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // ── Detail Routes ──
      GoRoute(
        path: '/playlist/:id',
        name: 'playlist',
        builder: (context, state) => PlaylistPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/album/:id',
        name: 'album',
        builder: (context, state) => AlbumPage(
          id: int.parse(state.pathParameters['id']!),
        ),
        routes: [
          GoRoute(
            path: 'song/:sid',
            name: 'albumSong',
            builder: (context, state) => SongDetailPage(
              songId: int.parse(state.pathParameters['sid']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/artist/:id',
        name: 'artist',
        builder: (context, state) => ArtistPage(
          id: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/song/:id',
        name: 'song',
        builder: (context, state) => SongDetailPage(
          songId: int.parse(state.pathParameters['id']!),
        ),
      ),

      // ── Feature Routes ──
      GoRoute(path: '/favorite', name: 'favorite',
        builder: (_, __) => const FavoritePage()),
      GoRoute(path: '/history', name: 'history',
        builder: (_, __) => const HistoryPage()),
      GoRoute(path: '/download', name: 'download',
        builder: (_, __) => const DownloadPage()),
      GoRoute(path: '/local-music', name: 'localMusic',
        builder: (_, __) => const LocalMusicPage()),
      GoRoute(path: '/equalizer', name: 'equalizer',
        builder: (_, __) => const EqualizerPage()),
      GoRoute(path: '/settings', name: 'settings',
        builder: (_, __) => const SettingsPage()),
      GoRoute(path: '/about', name: 'about',
        builder: (_, __) => const AboutPage()),

      // ── Full Screen Overlays ──
      GoRoute(
        path: '/now-playing',
        name: 'nowPlaying',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide up + fade transition
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: const NowPlayingPage(),
        ),
      ),
      GoRoute(
        path: '/lyrics',
        name: 'lyrics',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          fullscreenDialog: true,
          transitionsBuilder: _sharedAxisTransition,
          child: const LyricsPage(),
        ),
      ),
      GoRoute(
        path: '/queue',
        name: 'queue',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          child: const QueuePage(),
        ),
      ),
    ],

    // ── Redirect Guard ──
    redirect: (context, state) {
      // 未来可添加登录检查、权限检查等
      return null;
    },
  );
});
```

---

## 4. 转场动画

### 4.1 标准 Push/Pop

```dart
// SharedAxis (X) — Material Design 标准转场
Widget _sharedAxisTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SharedAxisTransition(
    animation: animation,
    secondaryAnimation: secondaryAnimation,
    transitionType: SharedAxisTransitionType.scaled,
    child: child,
  );
}
```

### 4.2 Now Playing — Slide Up

```dart
// 从底部滑入，带弹性效果
SlideTransition(
  position: Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
  )),
  child: FadeTransition(opacity: animation, child: child),
);
```

### 4.3 Container Transform（列表 → Now Playing）

通过 `Hero` widget 实现封面从列表到全屏的过渡：

```dart
// 列表页
Hero(
  tag: 'cover-${song.id}',
  child: CoverArt(url: song.cover),
)

// Now Playing 页
Hero(
  tag: 'cover-${song.id}',
  child: LargeCoverArt(url: song.cover),
)
```

---

## 5. AppShell 结构

```dart
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 主内容
          navigationShell,

          // Mini Player（全局悬浮）
          const Positioned(
            left: 0,
            right: 0,
            bottom: 64, // BottomNav 高度
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
```

---

## 6. 路由常量

```dart
class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const library = '/library';
  static const search = '/search';
  static const profile = '/profile';
  static const nowPlaying = '/now-playing';
  static const lyrics = '/lyrics';
  static const queue = '/queue';
  static const equalizer = '/equalizer';
  static const settings = '/settings';
  static const about = '/about';
  static const favorite = '/favorite';
  static const history = '/history';
  static const download = '/download';
  static const localMusic = '/local-music';

  static String playlist(int id) => '/playlist/$id';
  static String album(int id) => '/album/$id';
  static String artist(int id) => '/artist/$id';
  static String song(int id) => '/song/$id';
  static String searchResult({required String query, String type = 'song'}) =>
      '/search/result?q=$query&type=$type';
}
```

---

## 7. 深度链接配置

```dart
// go_router 自动处理 Android/iOS 深度链接
// 无需额外配置，route path 即深度链接路径

// 示例：
// musix://home
// musix://playlist/1
// musix://song/42
// musix://search/result?q=hello
```

---

## 8. Navigator Key 策略

| Navigator | 用途 |
|-----------|------|
| `rootNavigatorKey` | 全屏页面 (Now Playing, Lyrics, Queue) |
| `shellNavigatorKey` | 底部 Tab 导航 |
| `_tabHomeKey` / `_tabLibraryKey` 等 | Tab 内部独立导航栈（可选） |

---

## 9. 文件组织

```
lib/common/router/
├── app_router.dart          # GoRouter 配置
├── app_routes.dart          # 路由常量
├── app_shell.dart           # Shell 布局
├── transitions.dart         # 转场动画
└── router_provider.dart     # Riverpod Provider
```

---

*下一步：THEME.md — 主题系统设计*
