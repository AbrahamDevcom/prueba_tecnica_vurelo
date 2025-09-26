import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';

class GetUpcomingMoviesUseCase {
  final MoviesRepository repo;
  GetUpcomingMoviesUseCase(this.repo);

  Future<List<Movie>> call() => repo.getUpcomingMovies();
}
