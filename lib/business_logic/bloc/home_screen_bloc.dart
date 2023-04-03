import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ML_model/model/recommender_service_v1.dart';
import '../../entities/movie.dart';
import '../../repository_abstract_class/movie_repository.dart';
import '../../repository_abstract_class/user_repository.dart';
import '../events/home_screen_events.dart';
import '../states/home_screen_states.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(this._moviesRepository, this._usersRepository)
      : super(const HomeScreenState()) {
    on<DataFetchEvent>(_onDataFetching);
    on<InsertMovieEvent>(_insertMovie);
    on<DeleteMovieEvent>(_deleteMovie);
    on<UpdateOrInsertMovieEvent>(_updateOrInsertEvent);
    on<CalculateResultEvent>(_onCalculatingResult);
  }

  final MoviesRepository _moviesRepository;
  final UsersRepository _usersRepository;
  List<Movie> predictMovies = List<Movie>.empty(growable: true);
  Map<String, double> userMovies = <String, double>{};
  final RecommenderServiceV1 recommendationService = RecommenderServiceV1();

  Future<void> _onDataFetching(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    recommendationService.dataset = await _usersRepository.findAll();
    var movies = await _moviesRepository.findAll();
    emit(state.copyWith(moviesList: movies));
  }

  Future<void> _onCalculatingResult(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    List<Movie> movies =
        userMovies.entries.map((e) => Movie(e.key, rating: e.value)).toList();
    List<Movie> predictMovies =
        await recommendationService.predictMovies(movies);
    // print("emit: " + predictMovies);
    emit(state.copyWith(
        predictUserMoviesList: predictMovies.map((e) => e.name).toList()));
  }

  FutureOr<void> _insertMovie(
      InsertMovieEvent event, Emitter<HomeScreenState> emit) {
    userMovies.addAll({event.movieName!: event.movieRating!});
    add(CalculateResultEvent());
  }

  FutureOr<void> _deleteMovie(
      DeleteMovieEvent event, Emitter<HomeScreenState> emit) {
    userMovies.remove(event.movieName);
    add(CalculateResultEvent());
  }

  FutureOr<void> _updateOrInsertEvent(
      UpdateOrInsertMovieEvent event, Emitter<HomeScreenState> emit) {
    userMovies.update(
      event.movieName!,
      (value) => event.movieRating!,
      ifAbsent: () => event.movieRating!,
    );
    add(CalculateResultEvent());
  }
}
