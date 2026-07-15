import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/widgets/cover_art.dart';
import '../../../../common/widgets/empty_view.dart';
import '../../../../core/utils/album_art_helper.dart';
import '../../../../data/datasources/remote/music_json_data_source.dart';
import '../../../player/presentation/providers/playback_state_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/hot_searches.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() => ref.read(searchProvider.notifier).search(_ctrl.text));
  }

  @override
  void dispose() {
    _ctrl.removeListener(() {});
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final state = ref.watch(searchProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          // ── Search Bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _ctrl,
              focusNode: _focus,
              autofocus: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'What do you want to listen to?',
                hintStyle: t.textTheme.bodyLarge?.copyWith(color: t.colorScheme.onSurfaceVariant),
                prefixIcon: const Icon(Icons.search, size: 22),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () { _ctrl.clear(); _focus.unfocus(); })
                    : null,
                filled: true,
                fillColor: t.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          // ── Body ──
          Expanded(child: _buildBody(state)),
        ]),
      ),
    );
  }

  Widget _buildBody(SearchState state) {
    // Initial — browse state
    if (state.query.isEmpty) {
      return ListView(padding: const EdgeInsets.only(bottom: 128), children: [
        _buildBrowseGrid(),
        const HotSearches(),
        _buildRecentSearches(),
      ]);
    }

    // Loading
    if (state.isLoading) {
      return ListView(padding: const EdgeInsets.all(16), children: List.generate(6, (_) =>
        Padding(padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).colorScheme.surfaceContainerHighest)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 14, width: 150, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).colorScheme.surfaceContainerHighest)),
              const SizedBox(height: 6),
              Container(height: 12, width: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Theme.of(context).colorScheme.surfaceContainerHighest)),
            ])),
          ]),
        ),
      ));
    }

    // Results
    if (state.results.isNotEmpty) {
      return _SearchResults(results: state.results, query: state.query);
    }

    // No results
    if (!state.isLoading && state.query.isNotEmpty) {
      return const AppEmptyView(title: 'No results found', subtitle: 'Try a different search term', icon: Icons.search_off);
    }

    return const SizedBox.shrink();
  }

  // ── Browse Grid ──
  Widget _buildBrowseGrid() {
    final t = Theme.of(context);
    final categories = [
      {'icon': Icons.music_note, 'label': 'Songs', 'color': Colors.deepPurple},
      {'icon': Icons.album, 'label': 'Albums', 'color': Colors.orange},
      {'icon': Icons.person, 'label': 'Artists', 'color': Colors.teal},
      {'icon': Icons.queue_music, 'label': 'Playlists', 'color': Colors.pink},
    ];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Text('Browse', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: categories.map((c) => Expanded(
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                _ctrl.text = c['label'] as String;
                ref.read(searchProvider.notifier).search(_ctrl.text);
              },
              child: Card(
                child: Padding(padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Container(width: 44, height: 44,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: (c['color'] as Color).withValues(alpha: 0.12)),
                      child: Icon(c['icon'] as IconData, color: c['color'] as Color, size: 24)),
                    const SizedBox(height: 8),
                    Text(c['label'] as String, style: t.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500)),
                  ])),
              ),
            ),
          ),
        )).toList()),
      ),
      const SizedBox(height: 8),
    ]);
  }

  // ── Recent Searches ──
  Widget _buildRecentSearches() {
    final t = Theme.of(context);
    final history = ref.watch(searchProvider).history;
    if (history.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Recent', style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          TextButton(onPressed: () => ref.read(searchProvider.notifier).clearHistory(), child: const Text('Clear All')),
        ]),
      ),
      Wrap(spacing: 0, runSpacing: 0,
        children: history.take(8).map((term) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: InputChip(
            label: Text(term, style: const TextStyle(fontSize: 13)),
            avatar: const Icon(Icons.history, size: 16),
            deleteIcon: const Icon(Icons.close, size: 16),
            onDeleted: () => ref.read(searchProvider.notifier).removeFromHistory(term),
            onPressed: () {
              _ctrl.text = term;
              ref.read(searchProvider.notifier).search(term);
            },
          ),
        )).toList(),
      ),
      const SizedBox(height: 8),
    ]);
  }
}

// ── Search Results ──
class _SearchResults extends ConsumerWidget {
  const _SearchResults({required this.results, required this.query});
  final List<MusicJsonEntry> results;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final ctrl = ref.read(playbackControllerProvider.notifier);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: RichText(text: TextSpan(
          text: '${results.length} ', style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          children: [TextSpan(text: 'results for ', style: t.textTheme.bodyMedium),
            TextSpan(text: '"$query"', style: t.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, fontStyle: FontStyle.italic))],
        )),
      ),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 128),
          itemCount: results.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
          itemBuilder: (_, i) {
            final entry = results[i];
            return ListTile(
              leading: CoverArt(size: 48, borderRadius: 8, fallbackSeed: AlbumArtHelper.songCover(entry.title, entry.author)),
              title: _highlightMatch(context, entry.title, query),
              subtitle: Text(entry.author, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.more_horiz, size: 20),
              onTap: () => ctrl.playSong(entry, allSongs: results),
            );
          },
        ),
      ),
    ]);
  }

  Widget _highlightMatch(BuildContext ctx, String text, String q) {
    if (q.isEmpty) return Text(text);
    final idx = text.toLowerCase().indexOf(q.toLowerCase());
    if (idx < 0) return Text(text);
    return RichText(maxLines: 1, overflow: TextOverflow.ellipsis,
      text: TextSpan(style: DefaultTextStyle.of(ctx).style, children: [
        TextSpan(text: text.substring(0, idx)),
        TextSpan(text: text.substring(idx, idx + q.length), style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(ctx).colorScheme.primary)),
        TextSpan(text: text.substring(idx + q.length)),
      ]),
    );
  }
}
