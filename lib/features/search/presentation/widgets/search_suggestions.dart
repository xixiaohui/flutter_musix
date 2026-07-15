import 'package:flutter/material.dart';

/// Shows search suggestions as the user types.
class SearchSuggestions extends StatelessWidget {
  const SearchSuggestions({super.key, required this.suggestions});
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: suggestions.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 56),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(suggestions[index]),
          onTap: () {},
        );
      },
    );
  }
}
