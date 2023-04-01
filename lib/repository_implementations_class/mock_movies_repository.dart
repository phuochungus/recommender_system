import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:recommender_system/repository_abstract_class/mock_repository.dart';
import '../repository_abstract_class/movie_repository.dart';

class MockMoviesRepository extends MoviesRepository implements MockRepository {
  Set<String> movies = {};
  bool _isLoaded = false;

  Future<dynamic> _loadJson() async {
    final String response = await rootBundle.loadString('assets/ratings.json');
    final data = await json.decode(response);
    return data;
  }

  @override
  Future<void> loadData() async {
    await _loadJson().then(
      (jsonMaps) {
        jsonMaps.forEach((fullname, movieMaps) {
          movieMaps.forEach((movieName, rating) {
            movies.add(movieName);
          });
        });
        _isLoaded = true;
      },
    );
  }

  @override
  Future<List<String>> findAll() async {
    if (_isLoaded == false) {
      await loadData();
    }
    return movies.toList();
  }

  @override
  Future<void> create(String name) async {
    movies.add(name);
  }
}
