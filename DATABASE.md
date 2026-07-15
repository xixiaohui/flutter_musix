# Musix — Database Design (Drift/SQLite)

## 1. 概述

使用 **Drift** (原 Moor) 作为 ORM 框架操作 SQLite，提供类型安全的数据库访问。所有表定义使用 Dart 编写，自动生成 SQL 和 DAO。

---

## 2. ER 图

```
┌──────────┐     ┌──────────┐     ┌──────────┐
│  albums  │     │  songs   │     │ artists  │
├──────────┤     ├──────────┤     ├──────────┤
│ id       │◄────│ album_id │     │ id       │◄┐
│ name     │     │ artist_id│────►│ name     │ │
│ cover    │     │ title    │     │ image    │ │
│ year     │     │ duration │     │ bio      │ │
└──────────┘     │ url      │     └──────────┘ │
                 │ localPath│                   │
                 │ lyrics_id│──┐                │
                 │ format   │  │                │
┌──────────────┐ │ size     │  │  ┌──────────┐  │
│playlist_songs│ │ cover    │  │  │  lyrics  │  │
├──────────────┤ │ fav      │  │  ├──────────┤  │
│ playlist_id  │─┤ isLocal  │  │  │ id       │  │
│ song_id      │ │ createdAt│  │  │ lrcText  │  │
│ position     │ └──────────┘  │  │ lrcType  │  │
│ added_at     │       │       │  │ language │  │
└──────────────┘       │       │  └──────────┘  │
                       │       │                │
┌──────────┐           │       │                │
│playlists │           │       │                │
├──────────┤    ┌──────┴───────┴──┐    ┌───────┴──┐
│ id       │    │    history      │    │downloads │
│ name     │    ├────────────────┤    ├──────────┤
│ cover    │    │ song_id ───────┼────│ song_id  │
│ desc     │    │ played_at      │    │ progress │
│ sortOrder│    │ play_duration  │    │ status   │
│ createdAt│    └────────────────┘    │ filePath │
└──────────┘                          └──────────┘

┌──────────┐    ┌──────────┐    ┌──────────┐
│ settings │    │  cache   │    │ recents  │
├──────────┤    ├──────────┤    ├──────────┤
│ key      │    │ key      │    │ song_id  │
│ value    │    │ data     │    │ accessed │
└──────────┘    │ expires  │    └──────────┘
                └──────────┘
```

---

## 3. 表定义

### 3.1 songs（歌曲）

```dart
class Songs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 500)();
  IntColumn get artistId => integer().references(Artists, #id)();
  IntColumn get albumId => integer().references(Albums, #id).nullable()();
  IntColumn get lyricsId => integer().references(Lyrics, #id).nullable()();
  TextColumn get url => text().nullable()();           // 在线 URL
  TextColumn get localPath => text().nullable()();      // 本地文件路径
  TextColumn get cover => text().nullable()();          // 封面 URL/路径
  TextColumn get format => text().withDefault(const Constant('mp3'))();
  IntColumn get duration => integer().nullable()();     // 毫秒
  IntColumn get size => integer().nullable()();         // 字节
  IntColumn get trackNumber => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isLocal => boolean().withDefault(const Constant(false))();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.2 albums（专辑）

```dart
class Albums extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 500)();
  IntColumn get artistId => integer().references(Artists, #id)();
  TextColumn get cover => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get songCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.3 artists（歌手）

```dart
class Artists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 500)();
  TextColumn get image => text().nullable()();
  TextColumn get bio => text().nullable()();
  TextColumn get genre => text().nullable()();
  IntColumn get albumCount => integer().withDefault(const Constant(0))();
  IntColumn get songCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.4 playlists（播放列表）

```dart
class Playlists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get cover => text().nullable()();
  TextColumn get description => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get songCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.5 playlist_songs（播放列表 ↔ 歌曲 多对多）

```dart
class PlaylistSongs extends Table {
  IntColumn get playlistId => integer().references(Playlists, #id, onDelete: KeyAction.cascade)();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();       // 排序位置
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {playlistId, songId};
}
```

### 3.6 history（播放历史）

```dart
class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get playedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get playDuration => integer().nullable()();   // 收听时长（毫秒）

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.7 downloads（下载管理）

```dart
class Downloads extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  IntColumn get progress => integer().withDefault(const Constant(0))();   // 0-100
  TextColumn get status => text().withDefault(const Constant('pending'))(); // pending|downloading|completed|failed
  TextColumn get filePath => text().nullable()();
  DateTimeColumn get startedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.8 lyrics（歌词）

```dart
class Lyrics extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  TextColumn get lrcText => text()();                    // 完整 LRC 文本
  TextColumn get lrcType => text().withDefault(const Constant('line'))(); // line|word|bilingual
  TextColumn get language => text().nullable()();        // zh/en/ja/ko...

  @override
  Set<Column> get primaryKey => {id};
}
```

### 3.9 settings（设置键值对）

```dart
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  TextColumn get type => text().withDefault(const Constant('string'))(); // string|int|bool|json

  @override
  Set<Column> get primaryKey => {key};
}
```

### 3.10 cache（缓存）

```dart
class Cache extends Table {
  TextColumn get key => text()();
  BlobColumn get data => blob()();                       // 二进制缓存数据
  DateTimeColumn get expires => dateTime().nullable()();  // null = 永不过期

  @override
  Set<Column> get primaryKey => {key};
}
```

### 3.11 recents（最近播放 — 独立表支持更复杂的最近逻辑）

```dart
class Recents extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get songId => integer().references(Songs, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get accessedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

## 4. 关系总览

| 关系 | 类型 | 外键 |
|------|------|------|
| Song → Artist | N:1 | `songs.artistId → artists.id` |
| Song → Album | N:1 | `songs.albumId → albums.id` |
| Song → Lyrics | 1:1 | `songs.lyricsId → lyrics.id` |
| Album → Artist | N:1 | `albums.artistId → artists.id` |
| Playlist ↔ Song | M:N | 通过 `playlist_songs` |
| History → Song | N:1 | `history.songId → songs.id` |
| Downloads → Song | N:1 | `downloads.songId → songs.id` |
| Recents → Song | N:1 | `recents.songId → songs.id` |

---

## 5. 索引策略

```sql
-- 高频查询加速
CREATE INDEX idx_songs_artist ON songs(artist_id);
CREATE INDEX idx_songs_album ON songs(album_id);
CREATE INDEX idx_songs_favorite ON songs(is_favorite);
CREATE INDEX idx_songs_local ON songs(is_local);
CREATE INDEX idx_songs_title ON songs(title COLLATE NOCASE);

-- 历史排序
CREATE INDEX idx_history_played ON history(played_at DESC);
CREATE INDEX idx_history_song ON history(song_id);

-- 最近播放
CREATE INDEX idx_recents_accessed ON recents(accessed_at DESC);
CREATE INDEX idx_recents_song ON recents(song_id);

-- 播放列表
CREATE INDEX idx_pl_songs_list ON playlist_songs(playlist_id, position);

-- 下载
CREATE INDEX idx_downloads_status ON downloads(status);
```

---

## 6. DAO 设计

```dart
// 示例核心查询
@DriftDatabase(tables: [Songs, Albums, Artists, Playlists, PlaylistSongs,
                         History, Downloads, Lyrics, Settings, Cache, Recents])
abstract class AppDatabase extends _$AppDatabase {
  // Songs
  Future<List<Song>> allSongs();
  Future<List<Song>> searchSongs(String query);
  Future<List<Song>> favoriteSongs();
  Future<List<Song>> localSongs();
  Stream<List<Song>> watchAllSongs();

  // Albums
  Future<List<AlbumWithSongs>> albumWithSongs(int albumId);
  Future<List<Album>> allAlbums();

  // Artists
  Future<List<ArtistWithSongs>> artistWithSongs(int artistId);
  Future<List<Artist>> allArtists();

  // Playlists
  Future<List<PlaylistWithSongs>> playlistWithSongs(int playlistId);
  Future<void> addSongToPlaylist(int playlistId, int songId);
  Future<void> reorderPlaylistSong(int playlistId, int songId, int newPosition);

  // History
  Future<void> addHistory(int songId);
  Future<List<HistoryWithSong>> recentHistory({int limit = 50});
  Stream<List<HistoryWithSong>> watchHistory();

  // Favorites
  Future<void> toggleFavorite(int songId);
  Stream<List<Song>> watchFavorites();

  // Downloads
  Future<void> addDownload(int songId);
  Future<void> updateDownloadProgress(int id, int progress);
  Stream<List<DownloadWithSong>> watchDownloads();

  // Recents
  Future<void> addRecent(int songId);
  Future<List<RecentWithSong>> recentSongs({int limit = 20});

  // Settings
  Future<String?> getSetting(String key);
  Future<void> setSetting(String key, String value);

  // Cache
  Future<Uint8List?> getCache(String key);
  Future<void> setCache(String key, Uint8List data, {DateTime? expires});
  Future<void> clearExpiredCache();
}
```

---

## 7. 数据库版本策略

```dart
// Migration 示例
@override
int get schemaVersion => 1;

@override
MigrationStrategy get migration => MigrationStrategy(
  onCreate: (Migrator m) async {
    await m.createAll();
  },
  onUpgrade: (Migrator m, int from, int to) async {
    // 未来版本升级逻辑
  },
  beforeOpen: (details) async {
    // 启用 WAL 模式提升并发性能
    await customStatement('PRAGMA journal_mode=WAL');
    await customStatement('PRAGMA foreign_keys=ON');
  },
);
```

---

## 8. Drift 文件组织

```
lib/database/
├── app_database.dart          # @DriftDatabase 注解入口
├── app_database.g.dart        # 自动生成
├── tables/
│   ├── songs.dart
│   ├── albums.dart
│   ├── artists.dart
│   ├── playlists.dart
│   ├── playlist_songs.dart
│   ├── history.dart
│   ├── downloads.dart
│   ├── lyrics.dart
│   ├── settings.dart
│   ├── cache.dart
│   └── recents.dart
├── daos/
│   ├── songs_dao.dart
│   ├── albums_dao.dart
│   ├── artists_dao.dart
│   ├── playlists_dao.dart
│   ├── history_dao.dart
│   ├── downloads_dao.dart
│   └── settings_dao.dart
└── converters/
    └── type_converters.dart
```

---

*下一步：UI_DESIGN.md — UI 设计系统*
