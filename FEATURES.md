# Musix — Features Design

## 模块概览

```
features/
├── splash/         # 启动页
├── home/           # 首页
├── player/         # 播放器核心
├── lyrics/         # 歌词系统
├── search/         # 搜索
├── playlist/       # 播放列表
├── library/        # 音乐库
├── download/       # 下载管理
├── favorite/       # 收藏
├── history/        # 播放历史
├── equalizer/      # 均衡器
├── visualizer/     # 频谱可视化
├── settings/       # 设置
├── profile/        # 个人中心
├── local_music/    # 本地音乐
├── sleep_timer/    # 睡眠定时
└── about/          # 关于
```

---

## 1. Splash（启动页）

### 功能
- 品牌 Logo 动画（缩放 + 渐变出现）
- 背景渐变动画
- Slogan "Feel Every Beat." 打字机效果
- 3 秒后自动跳转 Home
- 首次启动显示引导页

### 状态
- 正常播放动画 → 跳转

### 文件
```
features/splash/
└── presentation/
    ├── pages/
    │   └── splash_page.dart
    └── widgets/
        └── splash_animation.dart
```

---

## 2. Home（首页）

### 功能
- **顶部**：Greeting（根据时间变化）+ 头像 + 搜索入口 + 通知
- **Horizontal Scroll Sections**：
  - Recently Played（小卡片）
  - Continue Listening（大卡片，带进度条）
  - Recommended（中等卡片）
  - Trending（列表）
  - Albums（横向滚动）
  - Artists（圆形头像）
  - Genres（彩色芯片）
  - Mood（情绪标签）
- **底部**：Mini Player + BottomNav

### 数据来源
- `json/musics.json` 解析后随机分配分类
- 本地音乐扫描结果
- 播放历史 / 收藏（Drift）

### 状态
| 状态 | 展示 |
|------|------|
| Loading | 全页 Skeleton（各 section 骨架） |
| Empty | 引导用户扫描本地音乐或连接网络 |
| Error | 错误信息 + 重试按钮 |
| Data | 正常展示 |

### 文件
```
features/home/
├── domain/
│   ├── entities/home_section.dart
│   └── use_cases/get_home_data.dart
├── data/
│   ├── repositories/home_repository_impl.dart
│   └── datasources/home_data_source.dart
└── presentation/
    ├── pages/home_page.dart
    ├── providers/home_provider.dart
    └── widgets/
        ├── greeting_header.dart
        ├── recently_played_section.dart
        ├── continue_listening_card.dart
        ├── recommended_section.dart
        ├── trending_section.dart
        ├── albums_section.dart
        ├── artists_section.dart
        ├── genres_section.dart
        └── mood_section.dart
```

---

## 3. Player — 播放器核心

### 3.1 音频引擎

```dart
// 基于 just_audio + audio_service
class MusixAudioService extends BaseAudioHandler {
  final AudioPlayer _player;

  // 播放控制
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<void> skipToNext();
  Future<void> skipToPrevious();

  // 队列管理
  Future<void> setQueue(List<Song> songs, {int startIndex = 0});
  Future<void> addToQueue(Song song);
  Future<void> removeFromQueue(int index);
  Future<void> reorderQueue(int oldIndex, int newIndex);

  // 播放模式
  void setShuffleMode(bool enabled);
  void setRepeatMode(RepeatMode mode); // off / one / all

  // 速度
  void setSpeed(double speed); // 0.5x - 2.0x

  // Gapless / Crossfade
  void setCrossfade(Duration duration);

  // Streams
  Stream<Duration> get positionStream;
  Stream<Duration> get bufferedPositionStream;
  Stream<PlaybackState> get playbackStateStream;
  Stream<SequenceState> get sequenceStateStream;
}
```

### 3.2 Now Playing 页面

- 全屏沉浸式播放器
- 封面旋转（播放时）/ 静止（暂停时）
- 背景毛玻璃 + 动态渐变（封面取色）
- Hero Animation（封面从列表/卡片过渡）
- 播放按钮弹性动画
- SeekBar 拖动 + Buffer 显示
- 辅助控制：随机/循环/速度/定时/分享
- 上拉展开歌词 / 队列
- 下滑手势收起（Dismissible + 弹性）

### 3.3 Mini Player

- 底部 60dp 播放条
- 封面缩略图 + 歌名滚动 + 播放/暂停 + 下一首
- 点击展开 Now Playing
- 上拉手势展开
- 长按弹出快捷菜单
- 背景模糊
- 歌词单行滚动

### 3.4 后台 & 通知

```
Notification (Android) / Now Playing (iOS)
┌──────────────────────────────┐
│  🎵 Song Title               │
│  Artist Name                 │
│                              │
│  ⏪  ▶️  ⏩  ❤️             │
│  ──●─────────────────────    │
└──────────────────────────────┘
```

### 文件
```
features/player/
├── domain/
│   ├── entities/playback_state.dart
│   └── use_cases/
│       ├── play_song.dart
│       ├── manage_queue.dart
│       └── control_playback.dart
├── data/
│   └── services/
│       ├── audio_service.dart       # audio_service handler
│       └── audio_player_manager.dart # just_audio wrapper
└── presentation/
    ├── pages/
    │   └── now_playing_page.dart
    ├── providers/
    │   ├── audio_player_provider.dart
    │   ├── playback_state_provider.dart
    │   └── queue_provider.dart
    └── widgets/
        ├── album_art_rotating.dart
        ├── seek_bar.dart
        ├── playback_controls.dart
        ├── control_buttons.dart
        └── now_playing_background.dart

widgets/mini_player/
├── mini_player.dart
├── mini_player_provider.dart
└── mini_player_animation.dart
```

---

## 4. Lyrics（歌词）

### 功能
- **LRC 解析**：标准 LRC 格式 `[mm:ss.xx]text`
- **逐行模式**：整行高亮
- **逐字模式**：`[mm:ss.xx]<mm:ss.xx>word` 格式
- **双语模式**：中/英/日/韩双语对照
- **滚动同步**：自动跟随播放进度
- **点击跳转**：点击歌词行 seek 到对应时间
- **Apple Music 风格**：模糊封面背景 + 歌词居中
- **API 预留**：未来接入 Musixmatch / QQ 音乐 歌词 API

### 状态
| 状态 | 展示 |
|------|------|
| Loading | 骨架行 |
| Empty | "暂无歌词" + 封面展示 |
| Error | 错误提示 + 重试 |
| Data | 歌词滚动 |

### 算法
```dart
// 歌词自动滚动
int currentLineIndex = _binarySearch(timestamps, playerPosition);

// 使用 ScrollController.animateTo() 平滑滚动
// 当前行保持屏幕中央偏上 1/3 位置
```

### 文件
```
features/lyrics/
├── domain/
│   ├── entities/lyric_line.dart
│   ├── entities/lyric_word.dart
│   └── use_cases/parse_lyrics.dart
├── data/
│   └── services/
│       ├── lrc_parser.dart       # LRC 文本解析
│       └── lyric_api_service.dart # 远程歌词 API（预留）
└── presentation/
    ├── pages/lyrics_page.dart
    ├── providers/lyrics_provider.dart
    └── widgets/
        ├── lyric_scroll_view.dart
        ├── lyric_line_widget.dart
        ├── lyric_word_widget.dart
        └── lyrics_background.dart
```

---

## 5. Search（搜索）

### 功能
- **搜索范围**：歌曲 / 专辑 / 歌手 / 播放列表
- **即时搜索**：输入时实时过滤（debounce 300ms）
- **搜索建议**：下拉自动补全
- **历史记录**：保存最近 20 条本地搜索
- **热门搜索**：基于播放次数排序
- **猜你想听**：基于历史推荐

### 状态
| 状态 | 展示 |
|------|------|
| Initial | 热门搜索 + 历史 + 猜你喜欢 |
| Searching | 输入中... loading spinner |
| Results | 搜索结果分类展示 |
| Empty | "未找到相关结果" |

### 文件
```
features/search/
├── domain/
│   ├── entities/search_result.dart
│   └── use_cases/search_music.dart
├── data/
│   └── repositories/search_repository_impl.dart
└── presentation/
    ├── pages/
    │   ├── search_page.dart
    │   └── search_result_page.dart
    ├── providers/search_provider.dart
    └── widgets/
        ├── search_bar.dart
        ├── search_suggestions.dart
        ├── hot_searches.dart
        ├── search_history.dart
        └── search_result_list.dart
```

---

## 6. Playlist（播放列表）

### 功能
- **CRUD**：创建 / 删除 / 重命名 / 修改描述
- **封面**：自定义或自动生成（取前 4 首歌封面拼贴）
- **排序**：手动拖拽 / 按名称 / 按日期 / 按歌手
- **添加**：从歌曲列表选择 / 从其他播放列表导入
- **分享**：生成分享图片 / 链接（预留）
- **收藏**：收藏其他用户的播放列表（预留）

### 空状态
- "还没有播放列表" → "创建你的第一个播放列表"

### 文件
```
features/playlist/
├── domain/
│   ├── entities/playlist.dart
│   └── use_cases/
│       ├── create_playlist.dart
│       ├── delete_playlist.dart
│       ├── update_playlist.dart
│       └── reorder_playlist.dart
├── data/
│   └── repositories/playlist_repository_impl.dart
└── presentation/
    ├── pages/playlist_page.dart
    ├── providers/playlist_provider.dart
    └── widgets/
        ├── playlist_header.dart
        ├── playlist_song_list.dart
        ├── add_to_playlist_sheet.dart
        ├── create_playlist_dialog.dart
        └── playlist_cover.dart
```

---

## 7. Library（音乐库）

### 分类 Tab

| Tab | 数据源 | 排序 |
|-----|--------|------|
| Songs | 本地 + 在线 | A-Z / 最近 / 时长 |
| Albums | 自动聚合 songs | 最近 / A-Z |
| Artists | 自动聚合 songs | A-Z / 歌曲数 |
| Folders | 本地文件系统 | 文件夹结构 |
| Downloads | 已下载 | 最近 |
| Favorites | 收藏 | 最近 |
| History | 播放记录 | 时间倒序 |
| Recently Added | 创建时间 | 倒序 |

### 文件
```
features/library/
├── domain/
│   ├── entities/library_category.dart
│   └── use_cases/get_library_data.dart
├── data/
│   └── repositories/library_repository_impl.dart
└── presentation/
    ├── pages/library_page.dart
    ├── providers/library_provider.dart
    └── widgets/
        ├── songs_tab.dart
        ├── albums_tab.dart
        ├── artists_tab.dart
        ├── folders_tab.dart
        └── library_tab_bar.dart
```

---

## 8. Download（下载管理）

### 功能
- 下载队列（并发 2 个）
- 进度显示
- 暂停 / 恢复 / 取消
- 下载完成后自动更新 `songs.localPath`
- 存储空间管理（显示占用 / 清理）

### 状态
| 状态 | 图标 | 操作 |
|------|------|------|
| pending | ◌ | — |
| downloading | ↓ + 百分比 | 暂停 |
| paused | ⏸ | 恢复 / 取消 |
| completed | ✓ | 删除 |
| failed | ⚠ | 重试 |

### 文件
```
features/download/
├── domain/
│   ├── entities/download_task.dart
│   └── use_cases/manage_downloads.dart
├── data/
│   └── services/download_service.dart
└── presentation/
    ├── pages/download_page.dart
    ├── providers/download_provider.dart
    └── widgets/
        ├── download_tile.dart
        └── storage_info.dart
```

---

## 9. Favorite（收藏）

### 功能
- 收藏/取消收藏歌曲
- 收藏列表（支持搜索 + 排序）
- 收藏专辑 / 歌手（预留）
- 从任意页面快速收藏（Now Playing, Mini Player, 列表）

### 文件
```
features/favorite/
└── presentation/
    ├── pages/favorite_page.dart
    ├── providers/favorite_provider.dart
    └── widgets/favorite_list.dart
```

---

## 10. History（播放历史）

### 功能
- 按天分组显示
- 显示播放时间 + 收听时长
- 清除单条 / 全部
- 从历史直接播放

### 文件
```
features/history/
└── presentation/
    ├── pages/history_page.dart
    ├── providers/history_provider.dart
    └── widgets/history_timeline.dart
```

---

## 11. Equalizer（均衡器）

### 功能
- **10 段均衡器** (31Hz - 16kHz)
- **预设**：Normal / Rock / Pop / Jazz / Classical / Hip-Hop / Electronic / Bass Boost / Vocal / Custom
- **自定义**：手动拖拽滑块
- **Bass Boost**：单独低音增强（+3/+6/+9/+12dB）
- **Virtualizer**：立体声宽度
- **Reverb**：混响预设（Small Room / Large Hall / Plate / Spring）
- **Balance**：左右声道平衡 (-1.0 ~ 1.0)
- **实时曲线图**：EqualizerCurve CustomPainter

### 文件
```
features/equalizer/
├── domain/
│   ├── entities/eq_preset.dart
│   └── use_cases/apply_equalizer.dart
├── data/
│   └── services/equalizer_service.dart
└── presentation/
    ├── pages/equalizer_page.dart
    ├── providers/equalizer_provider.dart
    └── widgets/
        ├── eq_band_slider.dart
        ├── eq_curve_chart.dart
        ├── eq_preset_list.dart
        └── virtualizer_control.dart
```

---

## 12. Visualizer（频谱动画）

### 类型
| 类型 | 描述 | 难度 |
|------|------|------|
| Bar Spectrum | 经典柱状频谱 | ★★ |
| Circular Spectrum | 环绕频谱 | ★★★ |
| Waveform | 波形显示 | ★★ |
| Particles | 粒子随音乐舞动 | ★★★★ |
| Ripple | 波纹扩散 | ★★★ |
| Glow | 辉光呼吸 | ★★ |

### 技术实现
```dart
// FFT 分析在 Isolate 中运行
class VisualizerService {
  // 从 AudioPlayer 读取音频数据
  // 执行 FFT 变换
  // 返回频率 / 振幅 / 峰值 / RMS 数据

  Stream<VisualizerData> get dataStream;
}

// CustomPainter 渲染
class SpectrumPainter extends CustomPainter {
  // 接收 VisualizerData
  // 60FPS，使用 AnimationController 驱动重绘
  // WillChange / SaveLayer 优化
}
```

### 文件
```
features/visualizer/
├── domain/
│   └── entities/visualizer_data.dart
├── data/
│   └── services/
│       ├── fft_analyzer.dart       # FFT 变换 (Isolate)
│       └── visualizer_service.dart
└── presentation/
    ├── providers/visualizer_provider.dart
    └── widgets/
        ├── bar_spectrum.dart
        ├── circular_spectrum.dart
        ├── waveform_display.dart
        ├── particle_field.dart
        ├── ripple_effect.dart
        └── glow_effect.dart
```

---

## 13. Settings（设置）

### 项目

| 分类 | 设置项 |
|------|--------|
| Appearance | Theme (System/Light/Dark), Dynamic Color, Album Color |
| Playback | Crossfade, Gapless, Default Speed, Resume on Start |
| Audio Quality | Streaming Quality, Download Quality |
| Equalizer | 快捷入口 |
| Storage | 缓存大小, 清除缓存, 下载路径 |
| Sleep Timer | 快速设置 |
| Notifications | 通知开关 |
| Language | 多语言（预留） |
| About | 版本, 开源许可 |

### 文件
```
features/settings/
└── presentation/
    ├── pages/settings_page.dart
    ├── providers/settings_provider.dart
    └── widgets/
        ├── settings_section.dart
        ├── settings_tile.dart
        ├── theme_selector.dart
        └── language_selector.dart
```

---

## 14. Local Music（本地音乐扫描）

### 功能
- 扫描设备存储中的音频文件
- 自动提取元数据（标题 / 歌手 / 专辑 / 封面 / 时长）
- 按文件夹浏览
- 批量导入
- 排除指定文件夹
- 监控文件变化（自动刷新）

### 文件
```
features/local_music/
├── domain/
│   ├── entities/local_song.dart
│   └── use_cases/scan_local_music.dart
├── data/
│   └── services/media_scanner_service.dart
└── presentation/
    ├── pages/local_music_page.dart
    ├── providers/local_music_provider.dart
    └── widgets/
        ├── scan_progress.dart
        └── folder_browser.dart
```

---

## 15. Sleep Timer（睡眠定时器）

### 功能
- 快速预设：15min / 30min / 45min / 60min / 90min
- 自定义时间
- 倒计时显示
- "播放完当前歌曲后停止"模式
- 音量渐弱到最后
- 到时间后：暂停播放 + 关闭通知

### 文件
```
features/sleep_timer/
└── presentation/
    ├── pages/sleep_timer_sheet.dart
    ├── providers/sleep_timer_provider.dart
    └── widgets/timer_picker.dart
```

---

## 16. Profile（个人中心）

### 功能
- 头像 + 用户名
- 统计数据：总播放次数 / 总时长 / 收藏数
- 快捷入口：收藏 / 历史 / 下载 / 设置
- 播放趋势图（本周/本月）

### 文件
```
features/profile/
└── presentation/
    ├── pages/profile_page.dart
    ├── providers/profile_provider.dart
    └── widgets/
        ├── profile_header.dart
        ├── stats_card.dart
        └── quick_actions.dart
```

---

## 17. About（关于）

### 功能
- 品牌 Logo + Slogan
- 版本号
- 开源许可
- GitHub 链接
- 反馈渠道

### 文件
```
features/about/
└── presentation/
    └── pages/about_page.dart
```

---

*下一步：TASKS.md — 可执行任务拆分*
