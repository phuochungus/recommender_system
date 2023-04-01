import 'package:equatable/equatable.dart';
import 'package:recommender_system/entities/movie.dart';

class HomeScreenState extends Equatable {
  final List<String> movieNames;
  final List<Movie> predictUserMovies;

  const HomeScreenState(
      {this.movieNames = const <String>[],
      this.predictUserMovies = const <Movie>[]});

  HomeScreenState copyWith(
      {List<String>? moviesList, List<Movie>? predictUserMoviesList}) {
    return HomeScreenState(
        movieNames: moviesList ?? movieNames,
        predictUserMovies: predictUserMoviesList ?? predictUserMovies);
  }

  @override
  List<Object?> get props => [movieNames];
}
