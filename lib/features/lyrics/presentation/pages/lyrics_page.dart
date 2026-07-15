import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/empty_view.dart';
import '../../../../common/widgets/loading_view.dart';
import '../providers/lyrics_provider.dart';

/// Apple Music-style lyrics page with auto-scrolling and tap-to-seek.
class LyricsPage extends ConsumerStatefulWidget {
  const LyricsPage({super.key});

  @override
  ConsumerState<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends ConsumerState<LyricsPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLine(int index) {
    if (!_scrollController.hasClients) return;
    final offset = index * 56.0 - 200; // Center the current line
    _scrollController.animateTo(
      offset.clamp(0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(lyricsProvider);
    final currentIndex = state.currentLineIndex;

    // Auto-scroll when current line changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToLine(currentIndex);
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Lyrics'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: state.isLoading
            ? const AppLoadingView(message: 'Loading lyrics...')
            : state.errorMessage != null
                ? Center(child: Text(state.errorMessage!))
                : state.lines.isEmpty
                    ? const AppEmptyView(title: 'No lyrics available', icon: Icons.lyrics_outlined)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 200),
                        itemCount: state.lines.length,
                        itemBuilder: (context, index) {
                          final line = state.lines[index];
                          final isCurrent = index == currentIndex;

                          return GestureDetector(
                            onTap: () {
                              final position = ref.read(lyricsProvider.notifier).seekToLine(index);
                              if (position != null) {
                                // TODO: seek audio to position
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              child: AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 300),
                                style: theme.textTheme.bodyLarge!.copyWith(
                                  color: isCurrent
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                                  fontSize: isCurrent ? 20 : 16,
                                ),
                                child: Text(
                                  line.text,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
