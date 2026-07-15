# Musix — Architecture

## 1. 架构概览

采用 **Clean Architecture** 三层分离 + **Riverpod** 状态管理 + **Repository Pattern** 数据隔离。

```
┌──────────────────────────────────────────────────────┐
│                   PRESENTATION                        │
│  Pages / Widgets / Riverpod Consumers                 │
│  → 只依赖 Domain 层，不感知数据来源                      │
├──────────────────────────────────────────────────────┤
│                     DOMAIN                            │
│  Entities / Use Cases / Repository Interfaces         │
│  → 纯 Dart，零依赖 Flutter，可单元测试                   │
├──────────────────────────────────────────────────────┤
│                      DATA                             │
│  Repository Impl / Data Sources / DTOs / Mappers      │
│  → 实现 Domain 接口，管理 Remote/Local/Cache 数据源       │
└──────────────────────────────────────────────────────┘
```

---

## 2. 层级职责

### 2.1 Presentation 层

```
features/<feature>/
├── presentation/
│   ├── pages/           # 页面入口 (Scaffold + Provider)
│   ├── widgets/         # 页面专属组件
│   └── providers/       # Riverpod Provider 定义
```

**规则**：
- Page 负责组装布局，不写业务逻辑
- Widget 接收数据通过构造函数，不直接读 Provider
- Provider 调用 Domain 层 Use Case

### 2.2 Domain 层

```
domain/
├── entities/            # 核心实体 (freezed)
├── use_cases/           # 业务用例
├── repositories/        # 仓库接口 (抽象)
└── failures/            # 业务错误类型
```

**规则**：
- Entity 是纯数据对象，不包含数据库/网络注解
- Use Case 一个类一个方法，单一职责
- Repository 接口只定义契约，不实现

```dart
// 示例：播放用例
class PlaySongUseCase {
  final AudioRepository _audioRepository;
  final HistoryRepository _historyRepository;

  Future<void> call(Song song) async {
    await _audioRepository.play(song);
    await _historyRepository.addEntry(song);
  }
}
```

### 2.3 Data 层

```
data/
├── repositories/        # 接口实现
├── datasources/
│   ├── remote/          # JSON/API 数据源
│   └── local/           # Drift 数据库
├── dtos/                # 数据传输对象
└── mappers/             # DTO ↔ Entity 映射
```

**规则**：
- Repository Impl 协调多数据源
- DTO 负责序列化/反序列化，与 Entity 分离
- Mapper 负责 DTO ↔ Entity 转换

---

## 3. 依赖注入

使用 Riverpod 的 `Provider` 体系实现依赖注入，不引入额外 DI 框架。

```dart
// 数据源
final musicDataSourceProvider = Provider<MusicDataSource>((ref) {
  return MusicDataSourceImpl(dio: ref.watch(dioProvider));
});

// Repository
final musicRepositoryProvider = Provider<MusicRepository>((ref) {
  return MusicRepositoryImpl(
    remote: ref.watch(musicDataSourceProvider),
    local: ref.watch(databaseProvider),
  );
});

// Use Case
final playSongUseCaseProvider = Provider<PlaySongUseCase>((ref) {
  return PlaySongUseCase(ref.watch(audioRepositoryProvider));
});

// State (AsyncNotifier)
final homeDataProvider = AsyncNotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
```

### 依赖层级图

```
Dio → DataSource → Repository → UseCase → Notifier → Widget
                                          ↑
                                    Drift Database
```

---

## 4. 数据流

### 4.1 读取流程（以 Home 为例）

```
HomePage
  → ref.watch(homeDataProvider)
    → HomeNotifier.build()
      → getHomeDataUseCase()
        → musicRepository.getRecommended()
          → remoteDataSource.fetchRecommended()  // 读 json/musics.json
          → localDataSource.getFavorites()       // 读 Drift
        → merge + cache in memory
      → return HomeState
  → 渲染 UI
```

### 4.2 写入流程（以"收藏歌曲"为例）

```
FavoriteButton(onTap)
  → ref.read(favoriteNotifierProvider.notifier).toggle(song)
    → toggleFavoriteUseCase(song)
      → favoriteRepository.toggle(song)
        → localDataSource.upsertFavorite(song)   // 写 Drift
      → memoryCache.invalidate(['favorites'])    // 失效缓存
    → 更新 state
  → UI 自动重建
```

### 4.3 流式数据（音频播放状态）

```
AudioService (just_audio)
  → AudioStreamNotifier (StreamProvider)
    → NowPlayingPage (ref.watch)
    → MiniPlayer (ref.watch)
    → NotificationService
    → LockScreenService
```

---

## 5. 状态管理策略

| 状态类型 | Provider 类型 | 用途 |
|----------|-------------|------|
| 异步请求数据 | `AsyncNotifierProvider` | Home 数据、搜索、列表 |
| 流式状态 | `StreamProvider` | 播放状态、进度、频谱 |
| 同步状态 | `StateNotifierProvider` | 主题、语言、设置 |
| 衍生数据 | `Provider` (computed) | 筛选、排序、搜索建议 |
| 参数化 | `.family` 变体 | Playlist(id)、Album(id) |
| 全局单例 | `Provider.autoDispose(false)` | AudioService、Database |

---

## 6. 模块依赖图

```
                    ┌─────────┐
                    │  App    │
                    └────┬────┘
                         │
          ┌──────────────┼──────────────┐
          │              │              │
     ┌────┴────┐   ┌────┴────┐   ┌────┴────┐
     │ Theme   │   │ Router  │   │ i18n    │
     └─────────┘   └─────────┘   └─────────┘
                         │
    ┌────────────────────┼────────────────────┐
    │                    │                    │
┌───┴───┐          ┌────┴────┐          ┌────┴────┐
│ Home  │          │ Player  │          │ Library │
└───┬───┘          └────┬────┘          └────┬────┘
    │                   │                    │
    └───────────────────┼────────────────────┘
                        │
              ┌─────────┼─────────┐
              │         │         │
        ┌─────┴──┐ ┌───┴────┐ ┌──┴──────┐
        │ Search │ │Lyrics  │ │Playlist │
        └────────┘ └────────┘ └─────────┘
                        │
              ┌─────────┼─────────┐
              │         │         │
        ┌─────┴──┐ ┌───┴────┐ ┌──┴──────┐
        │Favorite│ │History │ │Settings │
        └────────┘ └────────┘ └─────────┘
```

**核心规则**：Feature 之间不直接依赖，通过 Domain 层的 Repository 接口通信。

---

## 7. 核心服务架构

### 7.1 AudioService

```
AudioService (Singleton)
├── AudioPlayer (just_audio)
│   ├── AudioSource (ConcatenatingAudioSource)
│   ├── queue
│   ├── playbackState
│   └── position / duration
├── AudioHandler (audio_service)
│   ├── MediaControl (通知栏)
│   ├── MediaSession (锁屏)
│   └── Bluetooth / Headset
└── Streams
    ├── positionStream → SeekBar
    ├── playbackStateStream → PlayButton
    └── sequenceStateStream → Queue UI
```

### 7.2 VisualizerService

```
VisualizerService
├── FFT Analyzer (Isolate)
│   ├── Waveform data (uint8)
│   ├── Frequency bins
│   └── Amplitude / Peak / RMS
├── Canvas Renderer (CustomPainter)
│   ├── Bar Spectrum
│   ├── Circular Spectrum
│   ├── Waveform
│   └── Particle System
└── Synchronized to AudioPlayer.positionStream
```

### 7.3 LyricService

```
LyricService
├── LRC Parser
│   ├── Line-based LRC
│   ├── Word-based (逐字)
│   └── Bilingual (双语)
├── LyricScrollController
│   ├── Auto-scroll synced to position
│   └── Tap-to-seek
└── LyricHighlightNotifier
```

---

## 8. 路由架构

```
go_router
├── ShellRoute (AppShell — 底部导航)
│   ├── /home
│   ├── /library
│   ├── /search
│   └── /profile
├── /now-playing (全屏覆盖)
├── /playlist/:id
├── /album/:id
├── /artist/:id
├── /song/:id
├── /lyrics
├── /queue
├── /equalizer
├── /settings
├── /download
├── /history
├── /favorite
├── /local-music
└── /about
```

---

## 9. 错误处理策略

```dart
sealed class AppFailure {
  const AppFailure();
}

class NetworkFailure extends AppFailure {
  final String message;
  final int? statusCode;
}

class DatabaseFailure extends AppFailure {
  final String message;
}

class AudioFailure extends AppFailure {
  final String message;
}

class PermissionFailure extends AppFailure {
  final String message;
}
```

- Data 层捕获异常 → 转为 `AppFailure` → 通过 `AsyncNotifier` 的 error 状态传递给 UI
- UI 层根据 `AppFailure` 类型展示不同 Error Widget（重试/跳转设置/忽略）

---

## 10. 测试策略

| 层级 | 测试类型 | 覆盖目标 |
|------|---------|---------|
| Domain | Unit Test | Use Cases, Entities |
| Data | Unit Test | Repository Impl, Mapper, DataSource (Mock) |
| Presentation | Widget Test | Page 状态覆盖 (loading/error/empty/data) |
| UI | Golden Test | 关键页面视觉回归 |
| Integration | Integration Test | E2E 播放流程 |

---

*下一步：DATABASE.md — Drift 数据库设计*
