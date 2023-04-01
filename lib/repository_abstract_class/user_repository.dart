import '../entities/movie.dart';
import '../entities/user.dart';

abstract class UsersRepository {
  Future<List<User>> findAll();

  Future<void> create(String name, List<Movie> movies);
}
