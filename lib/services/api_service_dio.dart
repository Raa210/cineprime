import 'package:dio/dio.dart';
import 'api_constants.dart';
import '../models/movie_model.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';

class ApiServiceDio {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    headers: ApiConstants.headers,
  ));

  Future<MovieResponse> getDiscoverMovies() async {
    try {
      final response = await _dio.get('/discover/movie');
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load discover movies: $e');
    }
  }

  Future<MovieDetail> getMovieDetail(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      return MovieDetail.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie detail: $e');
    }
  }

  Future<ReviewResponse> getMovieReviews(int id) async {
    try {
      final response = await _dio.get('/movie/$id/reviews');
      return ReviewResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load movie reviews: $e');
    }
  }

  Future<MovieResponse> getSimilarMovies(int id) async {
    try {
      final response = await _dio.get('/movie/$id/similar');
      return MovieResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load similar movies: $e');
    }
  }
}
