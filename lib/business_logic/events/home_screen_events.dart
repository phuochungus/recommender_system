// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  String? movieName;
  double? movieRating;

  HomeScreenEvent({this.movieName, this.movieRating});

  @override
  List<Object?> get props => [movieName, movieRating];
}

class DataFetchEvent extends HomeScreenEvent {}

class CalculateResultEvent extends HomeScreenEvent {}

class InsertMovieEvent extends HomeScreenEvent {
  InsertMovieEvent(String movie, double rating)
      : super(movieName: movie, movieRating: rating);
}

class UpdateOrInsertMovieEvent extends HomeScreenEvent {
  UpdateOrInsertMovieEvent(String movie, double rating)
      : super(movieName: movie, movieRating: rating);
}

class DeleteMovieEvent extends HomeScreenEvent {
  DeleteMovieEvent(String movie) : super(movieName: movie);
}
