import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getUpcomingMovies();
  Future<List<Movie>> getTrendingMovies();
  Future<MovieDetail> getMovieDetail(int movieId);
  Future<List<MovieVideo>> getMovieVideos(int movieId);
}
