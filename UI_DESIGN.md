# Musix — UI Design System

## 1. 设计哲学

**"Less, but better."** — Dieter Rams

Musix 的 UI 追求 **Apple Design Award** 级别的品质：克制、优雅、流畅。融合 **Spotify 的沉浸感** + **Apple Music 的精致排版** + **Material You 的个性表达**。

---

## 2. 视觉语言

### 2.1 色彩系统

采用 **dynamic_color** 实现 Material You 动态取色，自动从用户壁纸/封面提取主色调。

```
Primary       → 封面取色 / 壁纸取色（dynamic_color）
Secondary     → Primary 的互补色
Tertiary      → Primary 的类似色
Surface       → 深色: #1C1B1F, 浅色: #FFFBFE
Background    → 深色: #121212, 浅色: #FAFAFA
Error         → #B3261E
```

**规则**：
- 封面取色用 `palette_generator`，异步计算 Dominant / Vibrant / Muted 色板
- 背景渐变从封面取 3-4 个颜色，线性/径向渐变
- Now Playing 页面颜色随歌曲切换 **动画过渡**（`AnimatedContainer` / `ColorTween`）

### 2.2 字体

| 用途 | 字体 | 权重 |
|------|------|------|
| Display (标题) | System / Google Sans | Bold 700 |
| Headline | System / Google Sans | SemiBold 600 |
| Body | System / Roboto | Regular 400 |
| Caption | System / Roboto | Light 300 |
| Lyrics | System / Noto Sans | Regular 400 |
| Mono (时间码) | Roboto Mono | Regular 400 |

### 2.3 间距

采用 **8dp 基准网格**：

```
xs  = 4dp
sm  = 8dp
md  = 16dp
lg  = 24dp
xl  = 32dp
2xl = 48dp
3xl = 64dp
```

### 2.4 圆角

```
sm  = 8dp    (卡片内元素、标签)
md  = 16dp   (卡片、按钮)
lg  = 24dp   (大卡片、Modal)
xl  = 32dp   (Sheet 顶部)
full = 999dp (药丸形状、头像)
```

---

## 3. 组件库

### 3.1 通用组件

| 组件 | 用途 | 动画 |
|------|------|------|
| `AppCard` | 通用卡片容器 | scale on tap, elevation on hover |
| `AppButton` | 主/次/文字按钮 | ink ripple, scale animation |
| `AppChip` | 标签/分类 | fade in/out |
| `AppTextField` | 搜索/输入 | focus border animation |
| `AppSheet` | 底部弹出 | slide up + fade backdrop |
| `AppDialog` | 确认弹窗 | scale + fade |
| `SkeletonBox` | 骨架屏占位 | shimmer animation |
| `ErrorView` | 错误状态 | fade in + retry button |
| `EmptyView` | 空状态 | illustration + fade in |
| `LoadingView` | 加载状态 | spinning indicator |
| `AppBar` | 顶部导航栏 | scroll-aware elevation |
| `AnimatedGradient` | 动态渐变背景 | color transition |

### 3.2 音乐专有组件

| 组件 | 用途 |
|------|------|
| `CoverArt` | 专辑封面（带 Hero tag） |
| `CoverArtRotating` | 旋转唱片封面 |
| `SeekBar` | 可拖动进度条 + buffer 显示 |
| `PlayButton` | 弹性动画播放按钮 |
| `LikeButton` | 心形收藏（Lottie/自定义） |
| `MiniPlayer` | 底部迷你播放条 |
| `LyricLine` | 单行歌词 |
| `SpectrumBar` | 频谱柱状图 |
| `CircularSpectrum` | 圆形频谱 |
| `WaveformDisplay` | 波形显示 |
| `PlaylistTile` | 播放列表行（拖拽手柄 + 封面） |
| `SongTile` | 歌曲行（封面 + 歌名 + 歌手 + 时长 + 更多） |
| `AlbumTile` | 专辑卡片 |
| `ArtistTile` | 歌手头像 + 名称 |
| `EqualizerCurve` | 均衡器曲线图表 |
| `SleepTimerPicker` | 睡眠定时选择器 |

---

## 4. 页面布局

### 4.1 全局布局

```
┌─────────────────────────────┐
│  AppBar / SearchBar         │  ← 可滚动隐藏
├─────────────────────────────┤
│                             │
│  [Page Content]             │  ← Expanded
│                             │
│                             │
├─────────────────────────────┤
│  Mini Player (60dp)         │  ← 固定在底部
├─────────────────────────────┤
│  Bottom Navigation (64dp)   │
└─────────────────────────────┘
```

### 4.2 Home 页面

```
┌─────────────────────────────┐
│  ☰ Good Morning     👤 🔔  │  ← AppBar
│        🔍 搜索              │  ← 可收缩搜索栏
├─────────────────────────────┤
│  Recently Played            │
│  ┌───┐ ┌───┐ ┌───┐        │  ← 横向滚动
│  │   │ │   │ │   │        │
│  └───┘ └───┘ └───┘        │
│                             │
│  Continue Listening         │
│  ┌──────────┐              │
│  │ Large    │              │  ← 大卡片
│  │ Card     │              │
│  └──────────┘              │
│                             │
│  Recommended                │
│  ┌───┐ ┌───┐ ┌───┐        │
│  │   │ │   │ │   │        │
│  └───┘ └───┘ └───┘        │
│                             │
│  Trending ───────────────   │
│  Albums ────────────────    │
│  Artists ───────────────    │
│  Genres ────────────────    │
│  Mood ──────────────────    │
│                             │
├─────────────────────────────┤
│  Now Playing — Mini Player  │
├─────────────────────────────┤
│  🏠 Home  📚 Library  🔍  👤 │
└─────────────────────────────┘
```

### 4.3 Now Playing 全屏

```
┌─────────────────────────────┐
│  ↓ 收起   专辑名    ⋮ 更多  │  ← 透明 AppBar
│                             │
│        ┌───────────┐        │
│        │           │        │
│        │  Album    │        │  ← 旋转唱片 + Hero
│        │  Cover    │        │     带有阴影/辉光
│        │           │        │
│        └───────────┘        │
│                             │
│  Song Title                 │
│  Artist Name           ❤️   │
│                             │
│  ──●─────────────────────── │  ← SeekBar + Buffer
│  1:23              -3:45    │
│                             │
│  ⏪  ▶️/⏸  ⏩               │  ← 大播放按钮（弹性动画）
│                             │
│  🔀  🔁  🎵  ⏱️  📋        │  ← 辅助控制栏
│                             │
│  ───────────────────────    │
│  歌词预览（2行）             │  ← 模糊渐隐
├─────────────────────────────┤
│  ↑ 展开歌词                 │  ← 上拉手势
└─────────────────────────────┘
```

### 4.4 歌词页

```
┌─────────────────────────────┐
│  ↓ 封面模式  歌词  双语 🔍   │
├─────────────────────────────┤
│        [模糊背景 + 封面]     │  ← 模糊的封面背景
│                             │
│     line 1                  │
│     line 2                  │
│   ▶ line 3 ◀               │  ← 当前行：高亮 + 放大
│     line 4                  │
│     line 5                  │
│     line 6                  │
│                             │
└─────────────────────────────┘
```

---

## 5. 动画规范

### 5.1 转场动画

| 转场 | 动画类型 | 时长 | 缓动 |
|------|---------|------|------|
| 列表 → 详情 | Container Transform | 400ms | FastOutSlowIn |
| Tab 切换 | Fade Through | 300ms | FastOutSlowIn |
| 封面 → Now Playing | Hero (Shared Element) | 500ms | EaseInOutCubic |
| Page Push | SharedAxis (X) | 300ms | FastOutSlowIn |
| Sheet 弹出 | Slide Up | 300ms | FastOutSlowIn |
| Mini Player 展开 | Physics (Spring) | 600ms | Spring(0.4, 8.0) |

### 5.2 微交互

- **播放按钮**：按下 scale(0.9) → 回弹 scale(1.05) → settle scale(1.0)，使用 `flutter_animate` 的 `.animate().scale(duration: 200ms, curve: Curves.elasticOut)`
- **收藏按钮**：点击时 scale + rotate + color 同时动画，使用 `.animate().scale().rotate().tint()`
- **列表项**：hover 时轻微抬起 + 阴影，使用 `AnimatedContainer`
- **SeekBar thumb**：拖动时放大，使用 `AnimatedScale`
- **标签切换**：`AnimatedSwitcher` + FadeThrough

### 5.3 持续动画

- **唱片旋转**：`RotationTransition` + `AnimationController(∞ repeat)`，播放时旋转，暂停时停止
- **频谱**：`CustomPainter` + `AnimationController`，60FPS，从 FFT 数据驱动
- **背景渐变**：`AnimatedContainer` / `TweenAnimationBuilder`，颜色随封面切换平滑过渡

---

## 6. 状态覆盖标准

每个页面必须实现 5 种状态：

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│ Loading  │   │ Skeleton │   │  Empty   │   │  Error   │   │   Data   │
│ ┌──────┐ │   │ ┌──────┐ │   │  ┌────┐  │   │ ┌──────┐ │   │ [content]│
│ │ ◌    │ │   │ │ ░░░░ │ │   │  │ 🎵 │  │   │ │ ⚠️   │ │   │          │
│ │      │ │   │ │ ░░░░ │ │   │  No  │  │   │ │Retry │ │   │          │
│ └──────┘ │   │ │ ░░░░ │ │   │ Music│  │   │ └──────┘ │   │          │
└──────────┘   └──────────┘   └──────────┘   └──────────┘   └──────────┘
```

### 通用 ErrorView 组件

```dart
class AppErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  // 显示错误图标 + 信息 + 重试按钮
  // 使用 flutter_animate 的 fadeIn 动画
}
```

### 通用 EmptyView 组件

```dart
class AppEmptyView extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;

  // 显示插图 + 标题 + 副标题 + 操作按钮
}
```

### 通用 Skeleton 组件

```dart
class AppSkeleton extends StatelessWidget {
  // 使用 shimmer 动画模拟内容加载
  // 支持：card / list / grid / text 多种骨架模板
}
```

---

## 7. 玻璃拟态 (Glassmorphism) 规范

用于 Mini Player、Now Playing、Lyrics 背景等：

```dart
class GlassContainer extends StatelessWidget {
  // ClipRRect + BackdropFilter + BoxDecoration
  // blurSigma: 10-30 (根据场景)
  // opacity: 0.15-0.3
  // border: 1px white10
  // gradient: 顶部浅色 → 底部深色
}
```

---

## 8. 响应式断点

| 设备 | 宽度 | 布局 |
|------|------|------|
| Phone Portrait | < 600dp | 单列 |
| Phone Landscape | < 840dp | 双列 |
| Tablet Portrait | 600-840dp | 双列 |
| Tablet Landscape | 840-1200dp | 三列 |
| Desktop | > 1200dp | 侧栏 + 内容 + 播放栏 |

---

## 9. Car Mode

当检测到 Android Auto 或手动切换时：

- 最小触摸目标：**48dp × 48dp**
- 字体放大 1.5x
- 播放按钮最大化
- 只保留核心控制：播放/暂停、上/下一首、喜欢
- 背景纯色高对比度
- 移除复杂动画

---

*下一步：ROUTER.md — 路由系统设计*
