import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:recommender_system/entities/user.dart';
import 'package:recommender_system/repository_abstract_class/mock_repository.dart';
import '../entities/movie.dart';
import '../repository_abstract_class/user_repository.dart';

class MockUsersRepository extends UsersRepository implements MockRepository {
  List<User> users = List.empty(growable: true);
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
          var list = List<Movie>.empty(growable: true);
          movieMaps.forEach((movieName, rating) {
            list.add(Movie(movieName, rating: rating + 0.0));
          });
          users.add(User(fullname, list));
        });
        _isLoaded = true;
      },
    );
  }

  @override
  Future<List<User>> findAll() async {
    if (_isLoaded == false) {
      await loadData();
    }
    return users;
  }

  @override
  Future<void> create(String name, List<Movie> movies) async {
    users.add(User(name, movies));
  }
}
