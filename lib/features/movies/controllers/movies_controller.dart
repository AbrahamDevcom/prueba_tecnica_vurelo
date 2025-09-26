import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/di/providers.dart';

class MoviesState {
  final List<Movie> upcoming;
  final List<Movie> trending;
  final List<Movie> recommendations;
  final bool loadingUpcoming;
  final bool loadingTrending;
  final String? error;
  final String selectedLanguage;
  final int selectedYear;

  const MoviesState({
    this.upcoming = const [],
    this.trending = const [],
    this.recommendations = const [],
    this.loadingUpcoming = false,
    this.loadingTrending = false,
    this.error,
    this.selectedLanguage = 'all',
    this.selectedYear = 0,
  });

  MoviesState copyWith({
    List<Movie>? upcoming,
    List<Movie>? trending,
    List<Movie>? recommendations,
    bool? loadingUpcoming,
    bool? loadingTrending,
    String? error,
    String? selectedLanguage,
    int? selectedYear,
  }) {
    return MoviesState(
      upcoming: upcoming ?? this.upcoming,
      trending: trending ?? this.trending,
      recommendations: recommendations ?? this.recommendations,
      loadingUpcoming: loadingUpcoming ?? this.loadingUpcoming,
      loadingTrending: loadingTrending ?? this.loadingTrending,
      error: error,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}

class MoviesController extends Notifier<MoviesState> {
  @override
  MoviesState build() => const MoviesState();

  Future<void> loadAll() async {
    await Future.wait([loadUpcoming(), loadTrending()]);
  }

  Future<void> loadUpcoming() async {
    state = state.copyWith(loadingUpcoming: true, error: null);
    try {
      final usecase = ref.read(getUpcomingMoviesProvider);
      final movies = await usecase();
      state = state.copyWith(upcoming: movies);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loadingUpcoming: false);
      _updateRecommendations();
    }
  }

  Future<void> loadTrending() async {
    state = state.copyWith(loadingTrending: true, error: null);
    try {
      final usecase = ref.read(getTrendingMoviesProvider);
      final movies = await usecase();
      state = state.copyWith(trending: movies);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loadingTrending: false);
      _updateRecommendations();
    }
  }

  void setLanguageFilter(String language) {
    state = state.copyWith(selectedLanguage: language);
    _updateRecommendations();
  }

  void setYearFilter(int year) {
    state = state.copyWith(selectedYear: year);
    _updateRecommendations();
  }

  void clearFilters() {
    state = state.copyWith(selectedLanguage: 'all', selectedYear: 0);
    _updateRecommendations();
  }

  void _updateRecommendations() {
    var filtered = List<Movie>.from(state.trending);

    if (state.selectedLanguage != 'all') {
      filtered = filtered.where((m) => m.originalLanguage == state.selectedLanguage).toList();
    }

    if (state.selectedYear > 0) {
      filtered = filtered.where((m) => m.releaseYear == state.selectedYear).toList();
    }

    state = state.copyWith(recommendations: filtered.take(6).toList());
  }

  List<String> get availableLanguages {
    final langs = state.trending.map((m) => m.originalLanguage).toSet().toList();
    langs.sort();
    return ['all', ...langs];
  }

  List<int> get availableYears {
    final years = state.trending.map((m) => m.releaseYear).where((y) => y > 0).toSet().toList();
    years.sort((a, b) => b.compareTo(a));
    return [0, ...years];
  }

  Future<void> refresh() async {
    await loadAll();
  }
}

final moviesControllerProvider = NotifierProvider<MoviesController, MoviesState>(MoviesController.new);
