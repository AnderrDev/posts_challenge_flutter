import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:posts_challenge/features/posts/presentation/bloc/posts_event.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: 'Buscar por título o contenido...',
          border: OutlineInputBorder(),
        ),
        onChanged:
            (value) => context.read<PostsBloc>().add(SearchChanged(value)),
      ),
    );
  }
}
