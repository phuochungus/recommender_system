import 'package:flutter/material.dart';

class RecommendedMoviesList extends StatelessWidget {
  final List<String> movies;
  const RecommendedMoviesList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: movies.length,
      itemBuilder: (context, index) => Text(movies[index]),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
