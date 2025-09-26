import 'package:cinepulse/core/repositories/movies_repository_impl.dart';
import 'package:cinepulse/core/services/api_service.dart';
import 'package:cinepulse/core/services/cache_service.dart';
import 'package:cinepulse/core/services/sample_data_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockApi extends Mock implements ApiService {}

class MockCache extends Mock implements CacheService {}

void main() {
  late MockApi api;
  late MockCache cache;
  late MoviesRepositoryImpl repo;

  setUp(() {
    api = MockApi();
    cache = MockCache();
    repo = MoviesRepositoryImpl(api: api, cache: cache);
  });

  test('returns cached movies when available and triggers silent refresh',
      () async {
    final cachedMovies = SampleDataService.getUpcomingMovies();
    final freshMovies = SampleDataService.getUpcomingMovies();

    when(() => cache.getCachedTrendingMovies())
        .thenAnswer((_) async => cachedMovies);
    when(() => api.getTrendingMovies()).thenAnswer((_) async => freshMovies);
    when(() => cache.cacheTrendingMovies(any())).thenAnswer((_) async {});

    final result = await repo.getTrendingMovies();

    expect(result, equals(cachedMovies));

    // silent refresh debe haberse llamado
    await Future.delayed(Duration.zero); // dejar async completar
    verify(() => api.getTrendingMovies()).called(1);
    verify(() => cache.cacheTrendingMovies(freshMovies)).called(1);
  });

  test('fetches from API and caches when no cache available', () async {
    final movies = SampleDataService.getUpcomingMovies();

    when(() => cache.getCachedTrendingMovies()).thenAnswer((_) async => []);
    when(() => api.getTrendingMovies()).thenAnswer((_) async => movies);
    when(() => cache.cacheTrendingMovies(movies)).thenAnswer((_) async {});

    final result = await repo.getTrendingMovies();

    expect(result, equals(movies));
    verify(() => api.getTrendingMovies()).called(1);
    verify(() => cache.cacheTrendingMovies(movies)).called(1);
  });

  test('returns API movies if cache throws exception', () async {
    final movies = SampleDataService.getUpcomingMovies();

    when(() => cache.getCachedTrendingMovies())
        .thenThrow(Exception('cache error'));
    when(() => api.getTrendingMovies()).thenAnswer((_) async => movies);
    when(() => cache.cacheTrendingMovies(movies)).thenAnswer((_) async {});

    final result = await repo.getTrendingMovies();

    expect(result, equals(movies));
    verify(() => api.getTrendingMovies()).called(1);
    verify(() => cache.cacheTrendingMovies(movies)).called(1);
  });
}
