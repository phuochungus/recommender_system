import 'package:equatable/equatable.dart';

import 'movie.dart';

class User extends Equatable {
  final String name;
  final List<Movie> movies;

  const User(this.name, this.movies);

  @override
  List<Object?> get props => [name, movies];
}
