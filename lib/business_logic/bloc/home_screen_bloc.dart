import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/movie.dart';
import '../../repository_abstract_class/movie_repository.dart';
import '../../repository_abstract_class/user_repository.dart';
import '../events/home_screen_events.dart';
import '../states/home_screen_states.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenBloc(this._moviesRepository, this._usersRepository)
      : super(const HomeScreenState()) {
    on<CalculateResultEvent>(_onCalculatingResult);
    on<DataFetchEvent>(_onDataFetching);
  }

  final MoviesRepository _moviesRepository;
  final UsersRepository _usersRepository;
  List<Movie> movies = List<Movie>.empty(growable: true);
  List<Movie> userMovies = List<Movie>.empty(growable: true);

  Future<void> _onDataFetching(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    await _usersRepository.findAll();
    var movies = await _moviesRepository.findAll();
    emit(state.copyWith(moviesList: movies));
  }

  Future<void> _onCalculatingResult(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {}
}
