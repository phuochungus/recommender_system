import 'package:recommender_system/entities/movie.dart';

abstract class RecommenderService {
  Future<List<Movie>> predictMovies(List<Movie> userMovies);
}
