import 'dart:math';

import 'package:recommender_system/ML_model/model_abstract_class.dart';
import 'package:recommender_system/entities/movie.dart';
import 'package:recommender_system/entities/user.dart';

class RecommenderServiceV1 extends RecommenderService {
  final List<User> dataset;

  RecommenderServiceV1(this.dataset);

  // List<String> getCommonMovieNames(User user1, User user2) {
  //   List<String> movieNames = List.empty(growable: true);

  //   for (var element1 in user1.movies) {
  //     for (var element2 in user2.movies) {
  //       if (element1.name == element2.name) {
  //         movieNames.add(element1.name);
  //         break;
  //       }
  //     }
  //   }

  //   return movieNames;
  // }

  double _calculateEuclideanDistance(User user1, User user2) {
    List<double> squaredDiff = [];

    for (var movie1 in user1.movies) {
      for (var movie2 in user2.movies) {
        if (movie1.name == movie2.name) {
          squaredDiff.add(((movie1.rating! - movie2.rating!) *
              (movie1.rating! - movie2.rating!)));
        }
      }
    }

    if (squaredDiff.isEmpty) return 0;
    return 1 /
        (1 + sqrt(squaredDiff.reduce((value, element) => value + element)));
  }

  @override
  Future<List<Movie>> predictMovies(List<Movie> userMovies) async {
    return List.empty();
  }
}
