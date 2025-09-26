import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';
import 'package:cinepulse/core/services/api_service.dart';
import 'package:cinepulse/core/services/cache_service.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final ApiService api;
  final CacheService cache;

  MoviesRepositoryImpl({required this.api, required this.cache});

  @override
  Future<List<Movie>> getUpcomingMovies() async {
    // Try cache first
    try {
      final cached = await cache.getCachedUpcomingMovies();
      if (cached != null && cached.isNotEmpty) {
        // fire-and-forget refresh
        _silentRefreshUpcoming();
        return cached;
      }
    } catch (_) {}

    // Fallback to API
    final movies = await api.getUpcomingMovies();
    await cache.cacheUpcomingMovies(movies);
    return movies;
  }

  Future<void> _silentRefreshUpcoming() async {
    try {
      final fresh = await api.getUpcomingMovies();
      if (fresh.isNotEmpty) {
        await cache.cacheUpcomingMovies(fresh);
      }
    } catch (_) {}
  }

  @override
  Future<List<Movie>> getTrendingMovies() async {
    try {
      final cached = await cache.getCachedTrendingMovies();
      if (cached != null && cached.isNotEmpty) {
        _silentRefreshTrending();
        return cached;
      }
    } catch (_) {}

    final movies = await api.getTrendingMovies();
    await cache.cacheTrendingMovies(movies);
    return movies;
  }

  Future<void> _silentRefreshTrending() async {
    try {
      final fresh = await api.getTrendingMovies();
      if (fresh.isNotEmpty) {
        await cache.cacheTrendingMovies(fresh);
      }
    } catch (_) {}
  }

  @override
  Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final cached = await cache.getCachedMovieDetail(movieId);
      if (cached != null) {
        _silentRefreshDetail(movieId);
        return cached;
      }
    } catch (_) {}

    final detail = await api.getMovieDetails(movieId);
    await cache.cacheMovieDetail(detail);
    return detail;
  }

  Future<void> _silentRefreshDetail(int movieId) async {
    try {
      final fresh = await api.getMovieDetails(movieId);
      await cache.cacheMovieDetail(fresh);
    } catch (_) {}
  }

  @override
  Future<List<MovieVideo>> getMovieVideos(int movieId) {
    return api.getMovieVideos(movieId);
  }
}
