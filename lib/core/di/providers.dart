import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinepulse/core/services/api_service.dart';
import 'package:cinepulse/core/services/cache_service.dart';
import 'package:cinepulse/core/repositories/movies_repository.dart';
import 'package:cinepulse/core/repositories/movies_repository_impl.dart';
import 'package:cinepulse/core/usecases/get_movie_detail.dart';
import 'package:cinepulse/core/usecases/get_movie_videos.dart';
import 'package:cinepulse/core/usecases/get_trending_movies.dart';
import 'package:cinepulse/core/usecases/get_upcoming_movies.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());
final cacheServiceProvider = Provider<CacheService>((ref) => CacheService());

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  final api = ref.watch(apiServiceProvider);
  final cache = ref.watch(cacheServiceProvider);
  return MoviesRepositoryImpl(api: api, cache: cache);
});

final getUpcomingMoviesProvider = Provider<GetUpcomingMoviesUseCase>((ref) {
  return GetUpcomingMoviesUseCase(ref.watch(moviesRepositoryProvider));
});

final getTrendingMoviesProvider = Provider<GetTrendingMoviesUseCase>((ref) {
  return GetTrendingMoviesUseCase(ref.watch(moviesRepositoryProvider));
});

final getMovieDetailProvider = Provider<GetMovieDetailUseCase>((ref) {
  return GetMovieDetailUseCase(ref.watch(moviesRepositoryProvider));
});

final getMovieVideosProvider = Provider<GetMovieVideosUseCase>((ref) {
  return GetMovieVideosUseCase(ref.watch(moviesRepositoryProvider));
});
