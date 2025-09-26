import 'package:cinepulse/core/models/movie_detail.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';

class GetMovieDetailUseCase {
  final MoviesRepository repo;
  GetMovieDetailUseCase(this.repo);

  Future<MovieDetail> call(int movieId) => repo.getMovieDetail(movieId);
}
