# Role

你是一位世界级 Flutter 架构师、UI 设计师、Android/iOS 音频开发专家。

你的目标不是写 Demo，而是开发一款可以上线 App Store / Google Play 的现代音乐播放器。

要求：

- Flutter 最新稳定版
- Dart 3
- Material Design 3
- Clean Architecture
- Riverpod
- go_router
- Drift(SQLite)
- audio_service
- just_audio
- just_audio_background
- flutter_animate
- palette_generator
- cached_network_image
- dynamic_color
- freezed
- json_serializable

整个项目要求：

高性能

动画流畅

Apple Design Award 级 UI

Spotify + Apple Music + 汽水音乐 风格

禁止生成低质量 Flutter Demo。


---

# 产品名称

Melodify

Slogan：

Feel Every Beat.

---

# 产品定位

现代音乐播放器

支持：

本地音乐

在线播放

歌词

播放列表

收藏

搜索

推荐

均衡器

频谱动画

Material You

Car Mode

Dark Mode

Mini Player

锁屏控制

通知栏控制

后台播放

Android Auto

CarPlay（预留）

---

# 页面

需要完整实现：

Splash

Home

Library

Playlist

Album

Artist

Song Detail

Now Playing

Queue

Search

Search Result

Lyrics

Equalizer

Profile

History

Favorite

Settings

Download

Local Music

Sleep Timer

About

每个页面必须拥有：

状态

动画

交互

空页面

Loading

Error

Skeleton

---

# Home

顶部：

Good Morning

头像

搜索

通知

中间：

Recently Played

Continue Listening

Recommended

Trending

Albums

Artists

Genres

Mood

底部：

Mini Player

Bottom Navigation

---

# Now Playing

现代化全屏播放器

包含：

大封面

背景毛玻璃

动态渐变

专辑旋转

播放按钮

上一首

下一首

喜欢

收藏

分享

歌词按钮

列表按钮

随机播放

循环播放

播放速度

Sleep Timer

AirPlay

Cast

更多菜单

拖动进度条

Buffer

缓存显示

动画要求：

封面缩放

Hero Animation

Shared Element

播放按钮弹性动画

歌词渐隐

背景颜色跟随封面变化

---

# 歌词

支持：

LRC

逐字歌词

逐行歌词

双语歌词

滚动歌词

点击歌词跳转播放

自动高亮

动态缩放

歌词模糊背景

Apple Music 风格

---

# 搜索

搜索：

歌曲

专辑

歌手

播放列表

历史记录

热门搜索

猜你想听

搜索建议

即时搜索

---

# 播放列表

支持：

创建

删除

修改

封面

排序

拖拽排序

收藏

分享

---

# Library

分类：

Songs

Albums

Artists

Folders

Downloads

Favorites

History

Recently Added

---

# Equalizer

支持：

Preset

Custom

10 Band

Bass Boost

Virtualizer

Reverb

Balance

动态图表

---

# 频谱动画

需要实现：

FFT

Waveform

Circular Spectrum

Bars

Particles

Ripple

Glow

要求：

跟随音乐实时变化

60FPS

Canvas

CustomPainter

Shader

支持：

Audio FFT

Visualizer

Amplitude

Peak

RMS

---

# Mini Player

支持：

滑动展开

Hero

背景模糊

歌词滚动

播放控制

长按菜单

---

# 音乐详情

包含：

封面

歌词

评论（预留）

MV（预留）

相关推荐

相似歌曲

艺人信息

专辑信息

---

# 数据库

Drift

包含：

Songs

Albums

Artists

Playlist

PlaylistSong

History

Favorite

Download

Recent

Lyric

Setting

Cache

完整关系设计。

---

# Repository

采用：

Repository Pattern

Remote

Local

Memory Cache

---

# 状态管理

Riverpod

AsyncNotifier

StateNotifier

Provider

Family

---

# 网络层

Dio

Interceptor

Retry

Cache

Logger

Token

Refresh

---

# 文件结构

lib/

core/

common/

theme/

router/

models/

services/

repositories/

database/

features/

home/

search/

player/

lyrics/

playlist/

library/

download/

favorite/

history/

settings/

widgets/

animations/

shared/

---

# UI 风格

要求：

大量留白

圆角

玻璃拟态

动态颜色

Material You

Blur

Hero

渐变

阴影

Motion

流畅动画

不卡顿

---

# 动画

flutter_animate

Hero

Implicit Animation

AnimatedContainer

AnimatedSwitcher

AnimatedPositioned

Shared Axis

Fade Through

Container Transform

Physics Animation

---

# 音乐播放

使用：

just_audio

支持：

播放

暂停

Seek

Buffer

Shuffle

Repeat

Queue

Gapless

Crossfade

Fade In

Fade Out

Background

Notification

Bluetooth

Headset

Lock Screen

Media Session

---

# 图片

cached_network_image

PaletteGenerator

动态背景颜色

BlurHash

占位图

---

# 性能

要求：

60FPS

列表虚拟化

图片缓存

分页

对象池

懒加载

Isolate

避免 rebuild

Const Widget

---

# 平台支持

Android

iOS

Tablet

Fold

Desktop（预留）

---

# 测试

Widget Test

Unit Test

Golden Test

---

# 代码要求

所有代码：

高可读性

高扩展性

完整注释

符合 Flutter 官方最佳实践。

禁止：

巨大 Widget

God Class

重复代码

Magic Number

硬编码

---

# 输出要求

不要一次生成整个项目。

按照以下顺序逐步输出：

第一步：

PROJECT.md

第二步：

ARCHITECTURE.md

第三步：

DATABASE.md

第四步：

UI_DESIGN.md

第五步：

ROUTER.md

第六步：

THEME.md

第七步：

FEATURES.md

第八步：

TASKS.md

之后：

每完成一个模块，再继续生成下一个模块。

任何时候都不要为了省略而降低代码质量。

最终目标：

开发一款达到 Spotify、Apple Music、YouTube Music 产品质量的 Flutter 音乐播放器，可直接用于商业项目。