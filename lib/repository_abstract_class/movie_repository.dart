abstract class MoviesRepository {
  Future<List<String>> findAll();

  Future<void> create(String name);
}
