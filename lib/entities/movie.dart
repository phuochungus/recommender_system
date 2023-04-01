// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String name;
  double? rating;

  Movie(this.name, {this.rating});

  @override
  List<Object?> get props => [name, rating];
}
