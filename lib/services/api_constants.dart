class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/original';

  // Ganti dengan API Read Access Token milik Anda
  static const String bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4OGZlMjZkZGQ3ODFiNGUwZmQ0MGE4MThiZjAzYzQ1NSIsIm5iZiI6MTc3OTE1NTgzOS4zNjMwMDAyLCJzdWIiOiI2YTBiYzM3ZjgyMjFhM2VkM2Y0NjZkYzAiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.v3Us_FntbthPkZxWT10tya4_Lfmb_bg2-QwWc17TzwE';

  static Map<String, String> get headers => {
    'Authorization': 'Bearer $bearerToken',
    'Content-Type': 'application/json;charset=utf-8',
  };
}
