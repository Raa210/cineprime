import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../services/api_service_dio.dart';
import 'movie_detail_page.dart';
 
class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});
 
  @override
  State<MovieListPage> createState() => _MovieListPageState();
}
 
class _MovieListPageState extends State<MovieListPage> {
  final ApiServiceDio _apiService = ApiServiceDio();
  late Future<MovieResponse> _futureMovies;
 
  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    _futureMovies = _apiService.getDiscoverMovies();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Movies'),
      ),
      body: FutureBuilder<MovieResponse>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final movies = snapshot.data!.results;
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return ListTile(
                title: Text(movie.title),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movieId: movie.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
