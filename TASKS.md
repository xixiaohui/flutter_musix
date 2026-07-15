# Musix — Implementation Tasks

## Task 执行规则

1. **严格按顺序执行**：每个 Task 完成并验证后，再进入下一个
2. **每完成一个文件 → 验证编译通过**
3. **每完成一个页面 → 5 种状态检查 (loading/skeleton/empty/error/data)**
4. **每完成一个模块 → 截图对比 UI_DESIGN.md**

---

## Phase 1 — 项目脚手架

### T1.1 初始化项目
- [ ] `flutter create musix` 或直接在当前目录初始化
- [ ] 配置 `pubspec.yaml`：添加所有依赖
- [ ] 配置 `analysis_options.yaml`：strict lint
- [ ] `flutter pub get` 验证

### T1.2 目录结构
- [ ] 创建 `lib/` 下所有目录（core/common/models/services/repositories/database/features/widgets/shared）
- [ ] 创建 `json/` 目录，确认 `musics.json` 在正确位置
- [ ] 创建 `test/` 目录结构

### T1.3 入口文件
- [ ] `main.dart` — App 入口，ProviderScope + MaterialApp.router
- [ ] 引入 `flutter_animate` 全局初始化

---

## Phase 2 — 核心基础设施

### T2.1 主题系统
- [ ] `lib/common/theme/theme.dart` — ThemeData 构建
- [ ] `lib/common/theme/color_schemes.dart` — Light/Dark
- [ ] `lib/common/theme/text_theme.dart`
- [ ] `lib/common/theme/component_themes.dart`
- [ ] `lib/common/theme/theme_notifier.dart` — ThemeNotifier + ThemeState
- [ ] `lib/common/theme/theme_extensions.dart` — MusixTheme extension
- [ ] `lib/common/theme/app_durations.dart`

### T2.2 路由系统
- [ ] `lib/common/router/app_routes.dart` — 路由常量
- [ ] `lib/common/router/app_router.dart` — GoRouter 配置
- [ ] `lib/common/router/app_shell.dart` — Shell 布局 + BottomNav + MiniPlayer 占位
- [ ] `lib/common/router/transitions.dart` — 转场动画

### T2.3 数据库
- [ ] `lib/database/tables/` — 11 张表定义
- [ ] `lib/database/daos/` — DAO 实现
- [ ] `lib/database/app_database.dart` — @DriftDatabase 入口
- [ ] 运行 `dart run build_runner build` 生成代码
- [ ] 编写数据库初始化测试

### T2.4 网络层
- [ ] `lib/core/network/dio_client.dart` — Dio 实例配置
- [ ] `lib/core/network/interceptors/` — Logger / Retry / Cache interceptor
- [ ] `lib/core/network/api_endpoints.dart` — API 常量

### T2.5 数据模型
- [ ] `lib/models/song.dart` (freezed)
- [ ] `lib/models/album.dart` (freezed)
- [ ] `lib/models/artist.dart` (freezed)
- [ ] `lib/models/playlist.dart` (freezed)
- [ ] `lib/models/lyric_line.dart` (freezed)
- [ ] `lib/models/search_result.dart` (freezed)
- [ ] 运行 build_runner 生成 freezed/json 代码

### T2.6 通用组件
- [ ] `lib/common/widgets/app_card.dart`
- [ ] `lib/common/widgets/app_button.dart`
- [ ] `lib/common/widgets/app_chip.dart`
- [ ] `lib/common/widgets/app_text_field.dart`
- [ ] `lib/common/widgets/error_view.dart`
- [ ] `lib/common/widgets/empty_view.dart`
- [ ] `lib/common/widgets/loading_view.dart`
- [ ] `lib/common/widgets/skeleton_box.dart`
- [ ] `lib/common/widgets/glass_container.dart`
- [ ] `lib/common/widgets/cover_art.dart`

### T2.7 错误处理
- [ ] `lib/core/error/app_failure.dart` — sealed class
- [ ] `lib/core/error/error_handler.dart` — 全局错误处理

---

## Phase 3 — 音频播放核心

### T3.1 音频引擎
- [ ] `lib/services/audio/audio_player_manager.dart` — just_audio 封装
- [ ] `lib/services/audio/audio_service_handler.dart` — audio_service BaseAudioHandler

### T3.2 播放状态管理
- [ ] `lib/features/player/presentation/providers/audio_player_provider.dart`
- [ ] `lib/features/player/presentation/providers/playback_state_provider.dart`
- [ ] `lib/features/player/presentation/providers/queue_provider.dart`

### T3.3 Now Playing 页面
- [ ] `lib/features/player/presentation/pages/now_playing_page.dart`
- [ ] `lib/features/player/presentation/widgets/album_art_rotating.dart`
- [ ] `lib/features/player/presentation/widgets/seek_bar.dart`
- [ ] `lib/features/player/presentation/widgets/playback_controls.dart`
- [ ] `lib/features/player/presentation/widgets/control_buttons.dart`
- [ ] `lib/features/player/presentation/widgets/now_playing_background.dart`

### T3.4 Mini Player
- [ ] `lib/widgets/mini_player/mini_player.dart`
- [ ] `lib/widgets/mini_player/mini_player_provider.dart`
- [ ] `lib/widgets/mini_player/mini_player_animation.dart`

---

## Phase 4 — 数据仓库

### T4.1 Repository 实现
- [ ] `lib/repositories/music_repository.dart` — 接口
- [ ] `lib/repositories/music_repository_impl.dart` — 实现（JSON + Drift）
- [ ] `lib/repositories/playlist_repository.dart`
- [ ] `lib/repositories/playlist_repository_impl.dart`
- [ ] `lib/repositories/history_repository.dart`
- [ ] `lib/repositories/history_repository_impl.dart`
- [ ] `lib/repositories/favorite_repository.dart`
- [ ] `lib/repositories/favorite_repository_impl.dart`
- [ ] `lib/repositories/download_repository.dart`
- [ ] `lib/repositories/download_repository_impl.dart`
- [ ] `lib/repositories/settings_repository.dart`
- [ ] `lib/repositories/settings_repository_impl.dart`

### T4.2 JSON 数据源
- [ ] `lib/data/datasources/remote/music_json_data_source.dart` — 读取 json/musics.json
- [ ] 数据解析 + 模型映射

---

## Phase 5 — Feature 模块

### T5.1 Splash
- [ ] 页面 + 动画 widget

### T5.2 Home
- [ ] HomePage + HomeProvider
- [ ] 所有 Section Widget（8 个）

### T5.3 Search
- [ ] SearchPage (initial / searching / results)
- [ ] SearchResultPage
- [ ] SearchProvider + 即时搜索 debounce
- [ ] Hot searches / History / Suggestions

### T5.4 Library
- [ ] LibraryPage + TabBar + 8 个 Tab
- [ ] LibraryProvider

### T5.5 Playlist
- [ ] PlaylistPage (header + song list)
- [ ] Create / Edit / Delete dialog
- [ ] ReorderableListView 拖拽排序
- [ ] AddSongSheet

### T5.6 Lyrics
- [ ] LRC Parser (line / word / bilingual)
- [ ] LyricsPage + LyricsProvider
- [ ] Auto-scroll + tap-to-seek

### T5.7 Equalizer
- [ ] EqualizerPage + EqualizerProvider
- [ ] 10-band sliders + curve chart
- [ ] Presets + BassBoost + Virtualizer + Balance

### T5.8 Visualizer (频谱)
- [ ] FFT Analyzer (Isolate)
- [ ] Bar Spectrum
- [ ] Circular Spectrum
- [ ] Waveform
- [ ] Particles / Ripple / Glow

### T5.9 Download
- [ ] DownloadPage + DownloadProvider
- [ ] DownloadService (并发队列)
- [ ] Storage management

### T5.10 Favorite
- [ ] FavoritePage + FavoriteProvider

### T5.11 History
- [ ] HistoryPage + HistoryProvider + Timeline

### T5.12 Local Music
- [ ] LocalMusicPage + Scanner
- [ ] 元数据提取
- [ ] Folder browser

### T5.13 Settings
- [ ] SettingsPage + 各设置项

### T5.14 Profile
- [ ] ProfilePage + Stats

### T5.15 Sleep Timer
- [ ] SleepTimerSheet + Timer logic

### T5.16 About
- [ ] AboutPage

### T5.17 Album / Artist / Song Detail
- [ ] AlbumPage
- [ ] ArtistPage
- [ ] SongDetailPage

### T5.18 Queue
- [ ] QueuePage + reorder

---

## Phase 6 — 体验打磨

### T6.1 动画全面检查
- [ ] 所有页面转场动画
- [ ] Hero/SharedElement 验证
- [ ] flutter_animate 微交互
- [ ] 60FPS profile 检查

### T6.2 主题
- [ ] dynamic_color 验证
- [ ] 封面取色验证
- [ ] Dark/Light 切换流畅

### T6.3 响应式
- [ ] Phone portrait / landscape
- [ ] Tablet
- [ ] Fold

### T6.4 Car Mode
- [ ] CarModeLayout 大按钮 UI

### T6.5 后台 & 通知
- [ ] 通知栏控制
- [ ] 锁屏控制
- [ ] 蓝牙/耳机控制

---

## Phase 7 — 测试

### T7.1 Unit Test
- [ ] Domain Use Cases
- [ ] Repository Impl (Mock)
- [ ] LRC Parser
- [ ] FFT Analyzer
- [ ] Data Mapper

### T7.2 Widget Test
- [ ] 每个页面的 5 种状态
- [ ] Mini Player 交互
- [ ] Playlist 拖拽

### T7.3 Golden Test
- [ ] 关键页面截图
- [ ] Dark/Light 双模式

---

## Phase 8 — 打包 & 发布

### T8.1 Android
- [ ] AndroidManifest 配置
- [ ] ProGuard 规则
- [ ] App signing
- [ ] AAB 构建

### T8.2 iOS
- [ ] Info.plist 配置
- [ ] Audio background mode
- [ ] CarPlay（预留）
- [ ] IPA 构建

---

## 进度追踪

| Phase | 任务数 | 状态 |
|-------|--------|------|
| Phase 1: 脚手架 | 3 | ⬜ Pending |
| Phase 2: 核心基础设施 | 7 | ⬜ Pending |
| Phase 3: 音频核心 | 4 | ⬜ Pending |
| Phase 4: 数据仓库 | 2 | ⬜ Pending |
| Phase 5: Feature 模块 | 18 | ⬜ Pending |
| Phase 6: 体验打磨 | 5 | ⬜ Pending |
| Phase 7: 测试 | 3 | ⬜ Pending |
| Phase 8: 打包发布 | 2 | ⬜ Pending |
| **总计** | **44** | |

---

*文档输出阶段完成。下一步：开始 Phase 1 代码实现。*
