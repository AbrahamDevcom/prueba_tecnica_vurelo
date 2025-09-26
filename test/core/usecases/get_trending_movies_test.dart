import 'package:cinepulse/core/repositories/movies_repository.dart';
import 'package:cinepulse/core/services/sample_data_service.dart';
import 'package:cinepulse/core/usecases/get_trending_movies.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMoviesRepository extends Mock implements MoviesRepository {}

void main() {
  late MockMoviesRepository repo;
  late GetTrendingMoviesUseCase useCase;

  setUp(() {
    repo = MockMoviesRepository();
    useCase = GetTrendingMoviesUseCase(repo);
  });

  test('should return list of movies from repository', () async {
    // arrange
    final movies = SampleDataService.getUpcomingMovies();
    when(() => repo.getTrendingMovies()).thenAnswer((_) async => movies);

    // act
    final result = await useCase();

    // assert
    expect(result, equals(movies));
    verify(() => repo.getTrendingMovies()).called(1);
  });

  test('should propagate exception if repository fails', () async {
    when(() => repo.getTrendingMovies()).thenThrow(Exception('error'));

    expect(() => useCase(), throwsException);
  });
}
