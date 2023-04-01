// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  String? movieName;
  String? movieRating;

  @override
  List<Object?> get props => [movieName, movieRating];
}

class DataFetchEvent extends HomeScreenEvent {}

class CalculateResultEvent extends HomeScreenEvent {}

class InsertMovieEvent extends HomeScreenEvent {}

class UpdateMovieEvent extends HomeScreenEvent {}

class DeleteMovieEvent extends HomeScreenEvent {}
