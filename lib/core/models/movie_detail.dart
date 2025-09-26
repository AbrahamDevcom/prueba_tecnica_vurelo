class MovieDetail {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final List<Genre> genres;
  final String originalLanguage;
  final double popularity;
  final bool adult;
  final int runtime;
  final String status;
  final String tagline;
  final int budget;
  final int revenue;

  MovieDetail({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.genres,
    required this.originalLanguage,
    required this.popularity,
    required this.adult,
    required this.runtime,
    required this.status,
    required this.tagline,
    required this.budget,
    required this.revenue,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      originalTitle: json['original_title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      genres: (json['genres'] as List? ?? [])
          .map((g) => Genre.fromJson(g))
          .toList(),
      originalLanguage: json['original_language'] ?? '',
      popularity: (json['popularity'] ?? 0).toDouble(),
      adult: json['adult'] ?? false,
      runtime: json['runtime'] ?? 0,
      status: json['status'] ?? '',
      tagline: json['tagline'] ?? '',
      budget: json['budget'] ?? 0,
      revenue: json['revenue'] ?? 0,
    );
  }

  String get fullPosterUrl => 'https://image.tmdb.org/t/p/w500$posterPath';
  String get fullBackdropUrl => 'https://image.tmdb.org/t/p/original$backdropPath';
  
  int get releaseYear {
    if (releaseDate.isEmpty) return 0;
    return int.tryParse(releaseDate.split('-').first) ?? 0;
  }

  String get formattedRuntime {
    if (runtime == 0) return '';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h ${minutes}m';
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class MovieVideo {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  MovieVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      official: json['official'] ?? false,
    );
  }

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$key';
}