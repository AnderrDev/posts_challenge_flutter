import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_challenge/core/utils/debouncer.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts/posts_event.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  late final Debouncer _debouncer;

  static const int _maxLength = 200;
  static const Duration _debounceDelay = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _debouncer = Debouncer(delay: _debounceDelay);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    // Sanitize input: trim whitespace and limit special characters
    final sanitized = value.trim();

    // Use debouncer to avoid excessive rebuilds
    _debouncer.run(() {
      if (mounted) {
        context.read<PostsBloc>().add(SearchChanged(sanitized));
      }
    });
  }

  void _clearSearch() {
    _controller.clear();
    context.read<PostsBloc>().add(const SearchChanged(''));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _controller,
        maxLength: _maxLength,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Buscar por título o contenido...',
          border: const OutlineInputBorder(),
          counterText: '', // Hide character counter
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
                tooltip: 'Limpiar búsqueda',
              );
            },
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }
}
