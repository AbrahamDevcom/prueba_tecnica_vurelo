import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String originalImageUrl = 'https://image.tmdb.org/t/p/original';
  static const String youtubeBaseUrl = 'https://www.youtube.com/watch?v=';

  static final String apiKey = dotenv.env['TMDB_API_KEY']!;

  // Endpoints
  static const String upcomingMovies = '/movie/upcoming';
  static const String trendingMovies = '/trending/movie/day';
  static const String movieDetails = '/movie';
  static const String movieVideos = '/movie/{id}/videos';
  static const String genres = '/genre/movie/list';
}
