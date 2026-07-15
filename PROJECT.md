# Musix — Project Overview

> **Feel Every Beat.**

## 1. 产品定位

Musix 是一款面向全球市场的现代音乐播放器，目标是对标 **Spotify**、**Apple Music** 和 **YouTube Music** 的产品体验。支持本地音乐播放与在线流媒体播放，具备完整的播放控制、歌词展示、均衡器、频谱动画等功能。

### 核心差异化

- **Material You 动态配色** — 跟随封面/壁纸自动调整主题
- **Apple Design Award 级 UI** — 玻璃拟态、流畅动画、大量留白
- **60FPS 频谱动画** — 基于 FFT 的实时音频可视化
- **离线优先架构** — Drift (SQLite) 本地数据库 + 缓存策略

---

## 2. 技术栈

| 类别 | 选型 | 版本要求 |
|------|------|----------|
| SDK | Flutter | 最新稳定版 |
| 语言 | Dart | 3.x |
| UI | Material Design 3 | — |
| 架构 | Clean Architecture | — |
| 状态管理 | Riverpod | latest |
| 路由 | go_router | latest |
| 数据库 | Drift (SQLite) | latest |
| 音频播放 | just_audio + audio_service | latest |
| 后台播放 | just_audio_background | latest |
| 动画 | flutter_animate | latest |
| 取色 | palette_generator | latest |
| 图片缓存 | cached_network_image | latest |
| 动态主题 | dynamic_color | latest |
| 代码生成 | freezed + json_serializable | latest |
| 网络 | Dio | latest |

---

## 3. 功能矩阵

### 核心播放
- [x] 播放 / 暂停 / Seek
- [x] 上一首 / 下一首
- [x] 随机播放 / 循环播放（单曲/列表）
- [x] 播放速度控制
- [x] Gapless / Crossfade / Fade In-Out
- [x] Buffer 显示
- [x] 后台播放 + 通知栏控制
- [x] 锁屏控制 + Media Session
- [x] 蓝牙 / 耳机线控

### 音乐管理
- [x] 本地音乐扫描与播放
- [x] 在线流媒体播放
- [x] 播放列表（创建/编辑/删除/拖拽排序/封面）
- [x] 收藏 / 喜欢
- [x] 播放历史
- [x] 下载管理
- [x] 最近播放 / 继续收听

### 发现
- [x] 推荐 / 热门 / 猜你喜欢
- [x] 搜索（歌曲/专辑/歌手/播放列表）
- [x] 搜索建议 + 即时搜索
- [x] 热门搜索
- [x] 分类浏览（流派/心情）

### 歌词
- [x] LRC 解析
- [x] 逐行 + 逐字歌词
- [x] 双语歌词
- [x] 滚动歌词 + 自动高亮
- [x] 点击歌词跳转播放
- [x] Apple Music 风格歌词页

### 音频调节
- [x] 10 段均衡器
- [x] 预设 + 自定义
- [x] Bass Boost / Virtualizer / Reverb
- [x] 左右声道平衡

### 可视化
- [x] FFT 频谱（Bar / Circular / Waveform）
- [x] 粒子 / 波纹 / 辉光效果
- [x] Canvas CustomPainter + Shader
- [x] 实时跟随音乐（Amplitude / Peak / RMS）

### 体验
- [x] Material You 动态配色
- [x] Dark Mode
- [x] Mini Player（滑动展开 / Hero / 模糊背景）
- [x] Car Mode（大按钮 UI）
- [x] Sleep Timer
- [x] 分享
- [x] AirPlay / Cast（预留）

### 平台
- [x] Android（手机 + 平板 + 折叠屏）
- [x] iOS（手机 + 平板）
- [x] Android Auto
- [x] CarPlay（预留）
- [x] Desktop（预留）

---

## 4. 数据架构

```
┌─────────────────────────────────────────────┐
│                  UI Layer                    │
│  Pages → Widgets → Riverpod Providers       │
├─────────────────────────────────────────────┤
│               Domain Layer                   │
│  Entities → Use Cases → Repository Interface│
├─────────────────────────────────────────────┤
│                Data Layer                    │
│  Repository Impl → Data Sources             │
│  ┌──────────┐ ┌───────────┐ ┌────────────┐  │
│  │ Remote   │ │ Local     │ │ Memory     │  │
│  │ (JSON/   │ │ (Drift    │ │ Cache      │  │
│  │  API)    │ │  SQLite)  │ │            │  │
│  └──────────┘ └───────────┘ └────────────┘  │
└─────────────────────────────────────────────┘
```

### 数据源策略

| 层级 | 当前方案 | 未来升级路径 |
|------|---------|-------------|
| Remote | `json/musics.json` 本地 JSON | REST API / Spotify API |
| Local | Drift SQLite | 不变 |
| Memory | Riverpod State / LRU Cache | 不变 |

Repository Pattern 确保数据源切换时 UI 层零改动。

---

## 5. 项目结构

```
lib/
├── core/               # 核心基础设施
│   ├── config/         # App 配置
│   ├── error/          # 错误处理
│   ├── network/        # Dio 网络层
│   ├── storage/        # 本地存储
│   ├── utils/          # 工具函数
│   └── extensions/     # Dart 扩展
├── common/             # 共享
│   ├── theme/          # 主题
│   ├── router/         # 路由
│   └── widgets/        # 通用组件
├── models/             # 数据模型 (freezed)
├── services/           # 服务层
│   ├── audio/          # 音频播放服务
│   ├── lyric/          # 歌词解析服务
│   └── media/          # 媒体扫描服务
├── repositories/       # 仓库层
├── database/           # Drift 数据库
│   ├── tables/         # 表定义
│   └── daos/           # 数据访问对象
├── features/           # 功能模块
│   ├── splash/
│   ├── home/
│   ├── search/
│   ├── player/
│   ├── lyrics/
│   ├── playlist/
│   ├── library/
│   ├── download/
│   ├── favorite/
│   ├── history/
│   ├── equalizer/
│   ├── settings/
│   └── profile/
├── widgets/            # 业务组件
│   ├── mini_player/
│   ├── visualizer/
│   └── animations/
└── shared/             # 共享工具
```

---

## 6. 页面清单（20 页）

| # | 页面 | 路由 | 状态覆盖 |
|---|------|------|----------|
| 1 | Splash | `/splash` | — |
| 2 | Home | `/home` | loading / empty / error / skeleton / data |
| 3 | Library | `/library` | loading / empty / error / skeleton / data |
| 4 | Playlist | `/playlist/:id` | loading / empty / error / data |
| 5 | Album | `/album/:id` | loading / empty / error / data |
| 6 | Artist | `/artist/:id` | loading / empty / error / data |
| 7 | Song Detail | `/song/:id` | loading / empty / error / data |
| 8 | Now Playing | `/now-playing` | expanded / collapsed |
| 9 | Queue | `/queue` | empty / data |
| 10 | Search | `/search` | initial / searching / results |
| 11 | Search Result | `/search/result` | loading / empty / error / data |
| 12 | Lyrics | `/lyrics` | loading / empty / error / data |
| 13 | Equalizer | `/equalizer` | data |
| 14 | Profile | `/profile` | loading / error / data |
| 15 | History | `/history` | loading / empty / data |
| 16 | Favorite | `/favorite` | loading / empty / data |
| 17 | Settings | `/settings` | data |
| 18 | Download | `/download` | loading / empty / data |
| 19 | Local Music | `/local-music` | loading / empty / data |
| 20 | About | `/about` | data |

---

## 7. 开发阶段

### Phase 1 — 基础架构
- Flutter 项目初始化
- 核心依赖配置
- 目录结构搭建
- 主题系统
- 路由系统
- 数据库 Schema + Drift 配置

### Phase 2 — 核心播放
- 音频服务 (just_audio + audio_service)
- 播放控制 (播放/暂停/Seek/队列)
- 通知栏 + 锁屏控制
- Mini Player

### Phase 3 — 功能模块
- Home 页面
- Library + 本地音乐扫描
- 播放列表 CRUD
- 搜索
- 歌词
- 收藏 / 历史
- 均衡器
- 频谱可视化

### Phase 4 — 体验打磨
- 动画优化
- Hero / Shared Element 转场
- Material You 动态配色
- 性能优化 (60FPS)
- Car Mode
- Sleep Timer

### Phase 5 — 测试与发布
- Widget Test / Unit Test / Golden Test
- 多平台适配
- 打包配置

---

## 8. 性能目标

| 指标 | 目标 |
|------|------|
| UI 帧率 | 60 FPS（零掉帧） |
| 列表滚动 | 虚拟化，smooth scroll |
| 图片加载 | 磁盘缓存 + 内存 LRU |
| 频谱动画 | Canvas CustomPainter，60FPS |
| 启动时间 | < 2s（冷启动） |
| 内存占用 | < 200MB（含图片缓存） |

---

## 9. 代码规范

- **NO** God Class / 巨大 Widget（>300 行拆分）
- **NO** Magic Number（提取为常量）
- **NO** 硬编码字符串（使用 i18n）
- **YES** 完整注释
- **YES** const constructor 优先
- **YES** freezed 数据模型
- **YES** Repository Pattern 接口隔离

---

*本文档是 Musix 项目的纲领性文件，后续 ARCHITECTURE.md → DATABASE.md → UI_DESIGN.md → ROUTER.md → THEME.md → FEATURES.md → TASKS.md 将逐一展开。*
