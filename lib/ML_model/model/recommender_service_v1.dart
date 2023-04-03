// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:recommender_system/ML_model/model_abstract_class.dart';
import 'package:recommender_system/entities/movie.dart';
import 'package:recommender_system/entities/user.dart';

class RecommenderServiceV1 extends RecommenderService {
  late List<User> dataset;

  List<String> _getCommonMovieNames(User user1, User user2) {
    List<String> movieNames = List.empty(growable: true);

    for (var element1 in user1.movies) {
      for (var element2 in user2.movies) {
        if (element1.name == element2.name) {
          movieNames.add(element1.name);
          break;
        }
      }
    }

    return movieNames;
  }

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

  double? _getRatingOfMovie(String name, User user) {
    for (var movie in user.movies) {
      if (movie.name == name) return movie.rating;
    }
    return null;
  }

  double _caculatePearsonDistance(User user1, User user2) {
    var commonMovies = _getCommonMovieNames(user1, user2);

    int numOfRatings = commonMovies.length;
    double user1Sum = 0;
    double user2Sum = 0;
    double user1SquaredSum = 0;
    double user2SquaredSum = 0;
    double sumOfProducts = 0;

    for (var element in commonMovies) {
      var user1Rate = _getRatingOfMovie(element, user1)!;
      var user2Rate = _getRatingOfMovie(element, user2)!;
      user1Sum += user1Rate;
      user2Sum += user2Rate;
      user1SquaredSum += user1Rate * user1Rate;
      user2SquaredSum += user2Rate * user2Rate;
      sumOfProducts += user1Rate * user2Rate;
    }

    var Sxy = sumOfProducts - (user1Sum * user2Sum / numOfRatings);
    var Sxx = user1SquaredSum - (user1Sum) * (user1Sum) / numOfRatings;
    var Syy = user2SquaredSum - (user2Sum) * (user2Sum) / numOfRatings;

    if (Sxx * Syy == 0) return 0;
    return Sxy / sqrt(Sxx * Syy);
  }

  @override
  Future<List<Movie>> predictMovies(List<Movie> userMovies) async {
    if (userMovies.isEmpty) return [];
    var inputUser = User("", userMovies);

    var overallScores = <String, double>{};
    var similarityScores = <String, double>{};

    for (var user in dataset) {
      var similarity_score = _caculatePearsonDistance(inputUser, user);
      if (similarity_score <= 0) continue;

      var filterd_list = user.movies.where((element1) {
        for (var element2 in userMovies) {
          if (element1.name == element2.name) return false;
        }
        return true;
      });

      for (var element in filterd_list) {
        overallScores.update(
          element.name,
          (value) => element.rating! * similarity_score,
          ifAbsent: () => element.rating! * similarity_score,
        );

        similarityScores.update(
          element.name,
          (value) => similarity_score,
          ifAbsent: () => similarity_score,
        );
      }
    }

    if (overallScores.isEmpty) return List.empty();

    List<Movie> movie_scores = [];
    overallScores.forEach((key, value) {
      movie_scores.add(Movie(key, rating: value / similarityScores[key]!));
    });

    movie_scores.sort((a, b) => b.rating!.compareTo(a.rating!));
    return movie_scores.sublist(0, (min(movie_scores.length, 5)));
  }
}
