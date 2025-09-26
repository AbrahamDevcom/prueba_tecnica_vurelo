import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinepulse/core/constants/api_constants.dart';
import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Movie>> getUpcomingMovies() async {
    // Sample data
    // if (ApiConstants.apiKey == 'your_api_key_here') {
    //   await Future.delayed(
    //       const Duration(milliseconds: 500)); // Simulate network delay
    //   return SampleDataService.getUpcomingMovies();
    // }

    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.upcomingMovies}?api_key=${ApiConstants.apiKey}&language=es-ES&page=1');

      final response = await _client.get(url, headers: {
        "Authorization": "Bearer ${ApiConstants.apiKey}",
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      throw Exception('Error fetching upcoming movies: $e');
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    // Sample data
    // if (ApiConstants.apiKey == 'your_api_key_here') {
    //   await Future.delayed(
    //       const Duration(milliseconds: 500)); // Simulate network delay
    //   return SampleDataService.getTrendingMovies();
    // }

    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.trendingMovies}?api_key=${ApiConstants.apiKey}&language=es-ES');

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (e) {
      throw Exception('Error fetching trending movies: $e');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    // Sample data
    // if (ApiConstants.apiKey == 'your_api_key_here') {
    //   await Future.delayed(
    //       const Duration(milliseconds: 500)); // Simulate network delay
    //   return SampleDataService.getMovieDetail(movieId);
    // }

    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.movieDetails}/$movieId?api_key=${ApiConstants.apiKey}&language=es-ES');

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return MovieDetail.fromJson(data);
      } else {
        throw Exception('Failed to load movie details');
      }
    } catch (e) {
      throw Exception('Error fetching movie details: $e');
    }
  }

  Future<List<MovieVideo>> getMovieVideos(int movieId) async {
    // Sample data
    // if (ApiConstants.apiKey == 'your_api_key_here') {
    //   await Future.delayed(
    //       const Duration(milliseconds: 300)); // Simulate network delay
    //   return SampleDataService.getMovieVideos(movieId);
    // }

    try {
      final url = Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.movieDetails}/$movieId/videos?api_key=${ApiConstants.apiKey}&language=es-ES');

      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];
        return results.map((json) => MovieVideo.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
