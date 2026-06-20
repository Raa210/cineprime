class ReviewResponse {
  final List<Review> results;
  final int page;
  final int totalPages;

  ReviewResponse({
    required this.results,
    required this.page,
    required this.totalPages,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      results: (json['results'] as List?)
              ?.map((item) => Review.fromJson(item))
              .toList() ??
          [],
      page: json['page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class Review {
  final String author;
  final String content;
  final double? rating;
  final String? avatarPath;

  Review({
    required this.author,
    required this.content,
    this.rating,
    this.avatarPath,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final details = json['author_details'];
    double? rating;
    if (details != null && details['rating'] != null) {
      rating = (details['rating'] as num).toDouble();
    }

    String? avatarPath;
    if (details != null && details['avatar_path'] != null) {
      String raw = details['avatar_path'].toString();
      if (raw.startsWith('/https')) {
        avatarPath = raw.substring(1);
      } else if (raw.isNotEmpty) {
        avatarPath = 'https://image.tmdb.org/t/p/w185$raw';
      }
    }

    return Review(
      author: json['author'] ?? 'Unknown',
      content: json['content'] ?? '',
      rating: rating,
      avatarPath: avatarPath,
    );
  }
}
