import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recommender_system/widgets/recommend_movies_list.dart';

import '../business_logic/bloc/home_screen_bloc.dart';
import '../business_logic/events/home_screen_events.dart';
import '../business_logic/states/home_screen_states.dart';
import '../repository_abstract_class/movie_repository.dart';
import '../repository_abstract_class/user_repository.dart';
import '../repository_implementations_class/mock_movies_repository.dart';
import '../repository_implementations_class/mock_users_repository.dart';
import '../widgets/movies_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final nameController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<MoviesRepository>(
              create: (context) => MockMoviesRepository()),
          RepositoryProvider<UsersRepository>(
              create: (context) => MockUsersRepository()),
        ],
        child: BlocProvider(
          create: (context) => HomeScreenBloc(
              RepositoryProvider.of<MoviesRepository>(context),
              RepositoryProvider.of<UsersRepository>(context))
            ..add(DataFetchEvent()),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 1,
                child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                  buildWhen: (previous, current) =>
                      !(current.movieNames == previous.movieNames),
                  builder: (context, state) =>
                      MoviesListView(moviesName: state.movieNames),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.cyan[100],
                    child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
                        buildWhen: (previous, current) =>
                            previous.predictUserMovies !=
                            current.predictUserMovies,
                        builder: (context, state) {
                          return RecommendedMoviesList(
                              movies: state.predictUserMovies);
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
