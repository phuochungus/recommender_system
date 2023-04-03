import 'package:equatable/equatable.dart';

class HomeScreenState extends Equatable {
  final List<String> movieNames;
  final List<String> predictUserMovies;

  const HomeScreenState(
      {this.movieNames = const <String>[],
      this.predictUserMovies = const <String>[]});

  HomeScreenState copyWith(
      {List<String>? moviesList, List<String>? predictUserMoviesList}) {
    return HomeScreenState(
        movieNames: moviesList ?? movieNames,
        predictUserMovies: predictUserMoviesList ?? predictUserMovies);
  }

  @override
  List<Object?> get props => [movieNames, predictUserMovies];
}
