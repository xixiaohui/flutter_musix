import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../widgets/hot_searches.dart';
import '../widgets/search_history_widget.dart';
import '../widgets/search_result_list.dart';
import '../widgets/search_suggestions.dart';

/// Search page with instant search, history, and hot searches.
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onQueryChanged);
  }

  void _onQueryChanged() {
    ref.read(searchProvider.notifier).search(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          focusNode: _focusNode,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search songs, albums, artists...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _focusNode.unfocus();
                    },
                  )
                : null,
            border: InputBorder.none,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerHighest,
          ),
          style: theme.textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.query.isEmpty) {
      return ListView(
        children: [
          const HotSearches(),
          const SearchHistoryWidget(),
        ],
      );
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.suggestions.isNotEmpty && state.results.isEmpty) {
      return SearchSuggestions(suggestions: state.suggestions);
    }

    if (state.results.isNotEmpty) {
      return SearchResultList(results: state.results);
    }

    return const Center(
      child: Text('No results found'),
    );
  }
}
