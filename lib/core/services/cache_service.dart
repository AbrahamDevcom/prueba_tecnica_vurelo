import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';

class CacheService {
  static const String _upcomingMoviesKey = 'upcoming_movies';
  static const String _trendingMoviesKey = 'trending_movies';
  static const String _movieDetailsKey = 'movie_details_';
  static const String _lastUpdateKey = 'last_update_';

  Future<void> cacheUpcomingMovies(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJson = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_upcomingMoviesKey, json.encode(moviesJson));
    await prefs.setInt(
        '${_lastUpdateKey}upcoming', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Movie>?> getCachedUpcomingMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_upcomingMoviesKey);

    if (cachedData != null && await _isCacheValid('upcoming')) {
      final List<dynamic> moviesJson = json.decode(cachedData);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    }

    return null;
  }

  Future<void> cacheTrendingMovies(List<Movie> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final moviesJson = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_trendingMoviesKey, json.encode(moviesJson));
    await prefs.setInt(
        '${_lastUpdateKey}trending', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<Movie>?> getCachedTrendingMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_trendingMoviesKey);

    if (cachedData != null && await _isCacheValid('trending')) {
      final List<dynamic> moviesJson = json.decode(cachedData);
      return moviesJson.map((json) => Movie.fromJson(json)).toList();
    }

    return null;
  }

  Future<void> cacheMovieDetail(MovieDetail movieDetail) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_movieDetailsKey${movieDetail.id}',
        json.encode(movieDetail.toJson()));
    await prefs.setInt('${_lastUpdateKey}detail_${movieDetail.id}',
        DateTime.now().millisecondsSinceEpoch);
  }

  Future<MovieDetail?> getCachedMovieDetail(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('$_movieDetailsKey$movieId');

    if (cachedData != null && await _isCacheValid('detail_$movieId')) {
      final movieJson = json.decode(cachedData);
      return MovieDetail.fromJson(movieJson);
    }

    return null;
  }

  Future<bool> _isCacheValid(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt('$_lastUpdateKey$key');

    if (lastUpdate == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    const cacheValidDuration = Duration(hours: 1); // Cache válido por 1 hora

    return (now - lastUpdate) < cacheValidDuration.inMilliseconds;
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs
        .getKeys()
        .where((key) =>
            key.startsWith(_upcomingMoviesKey) ||
            key.startsWith(_trendingMoviesKey) ||
            key.startsWith(_movieDetailsKey) ||
            key.startsWith(_lastUpdateKey))
        .toList();

    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}

extension MovieDetailJson on MovieDetail {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'genres': genres.map((g) => {'id': g.id, 'name': g.name}).toList(),
      'original_language': originalLanguage,
      'popularity': popularity,
      'adult': adult,
      'runtime': runtime,
      'status': status,
      'tagline': tagline,
      'budget': budget,
      'revenue': revenue,
    };
  }
}
