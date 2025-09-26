import 'package:cinepulse/core/models/movie_detail.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';

class GetMovieVideosUseCase {
  final MoviesRepository repo;
  GetMovieVideosUseCase(this.repo);

  Future<List<MovieVideo>> call(int movieId) => repo.getMovieVideos(movieId);
}
