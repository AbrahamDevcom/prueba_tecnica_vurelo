import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';

class GetTrendingMoviesUseCase {
  final MoviesRepository repo;
  GetTrendingMoviesUseCase(this.repo);

  Future<List<Movie>> call() => repo.getTrendingMovies();
}
