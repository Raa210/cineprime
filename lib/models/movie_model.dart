import '../services/api_constants.dart';

class MovieResponse {
  final List<Movie> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
      results: (json['results'] as List)
          .map((item) => Movie.fromJson(item))
          .toList(),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String backdropUrl;
  final double voteAverage;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.backdropUrl,
    required this.voteAverage,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      posterUrl: json['poster_path'] != null
          ? '${ApiConstants.imageBaseUrl}${json['poster_path']}'
          : '',
      backdropUrl: json['backdrop_path'] != null
          ? '${ApiConstants.imageBaseUrl}${json['backdrop_path']}'
          : '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      overview: json['overview'] ?? '',
    );
  }
}
