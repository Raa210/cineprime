import '../services/api_constants.dart';

class MovieDetail {
  final String backdropUrl;
  final String posterUrl;
  final String title;
  final double voteAverage;
  final int runtime;
  final List<String> genres;
  final String overview;

  MovieDetail({
    required this.backdropUrl,
    required this.posterUrl,
    required this.title,
    required this.voteAverage,
    required this.runtime,
    required this.genres,
    required this.overview,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      backdropUrl: json['backdrop_path'] != null
          ? '${ApiConstants.imageBaseUrl}${json['backdrop_path']}'
          : '',
      posterUrl: json['poster_path'] != null
          ? '${ApiConstants.imageBaseUrl}${json['poster_path']}'
          : '',
      title: json['title'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      genres: json['genres'] != null
          ? (json['genres'] as List).map((g) => g['name'].toString()).toList()
          : [],
      overview: json['overview'] ?? '',
    );
  }
}
