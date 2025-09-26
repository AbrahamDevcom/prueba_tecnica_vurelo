import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinepulse/core/models/movie_detail.dart';
import 'package:cinepulse/core/di/providers.dart';

class MovieDetailState {
  final MovieDetail? detail;
  final List<MovieVideo> videos;
  final bool loading;
  final String? error;

  const MovieDetailState({
    this.detail,
    this.videos = const [],
    this.loading = false,
    this.error,
  });

  MovieDetailState copyWith({
    MovieDetail? detail,
    List<MovieVideo>? videos,
    bool? loading,
    String? error,
  }) {
    return MovieDetailState(
      detail: detail ?? this.detail,
      videos: videos ?? this.videos,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class MovieDetailController extends Notifier<MovieDetailState> {
  @override
  MovieDetailState build() => const MovieDetailState();

  Future<void> load(int movieId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final getDetail = ref.read(getMovieDetailProvider);
      final getVideos = ref.read(getMovieVideosProvider);
      final detail = await getDetail(movieId);
      final videos = await getVideos(movieId);
      state = state.copyWith(detail: detail, videos: videos);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    } finally {
      state = state.copyWith(loading: false);
    }
  }

  MovieVideo? get trailerVideo {
    final vids = state.videos;
    if (vids.isEmpty) return null;
    try {
      return vids.firstWhere(
        (v) => v.type.toLowerCase() == 'trailer' && v.site.toLowerCase() == 'youtube',
      );
    } catch (_) {
      return vids.first;
    }
  }
}

final movieDetailControllerProvider = NotifierProvider<MovieDetailController, MovieDetailState>(MovieDetailController.new);
