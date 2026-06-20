class ReviewResponse {
  final List<Review> results;

  ReviewResponse({required this.results});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) {
    return ReviewResponse(
      results: (json['results'] as List?)
              ?.map((item) => Review.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class Review {
  final String author;
  final String content;

  Review({
    required this.author,
    required this.content,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author'] ?? 'Unknown',
      content: json['content'] ?? '',
    );
  }
}
