import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/movie_detail_model.dart';
import '../models/review_model.dart';
import '../models/movie_model.dart';
import '../models/video_model.dart';
import '../services/api_service_dio.dart';
import 'all_reviews_page.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({super.key, required this.movieId});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final ApiServiceDio _apiService = ApiServiceDio();

  late Future<MovieDetail> _futureDetail;
  late Future<ReviewResponse> _futureReviews;
  late Future<MovieResponse> _futureSimilar;

  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _cardColor = Color(0xFF1A1A2E);
  static const Color _accentColor = Color(0xFFE50914);
  static const Color _goldColor = Color(0xFFFFD700);
  static const Color _textPrimary = Color(0xFFF0F0F0);
  static const Color _textSecondary = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    _futureDetail = _apiService.getMovieDetail(widget.movieId);
    _futureReviews = _apiService.getMovieReviews(widget.movieId);
    _futureSimilar = _apiService.getSimilarMovies(widget.movieId);
  }

  Future<void> _openYoutube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: FutureBuilder<MovieDetail>(
        future: _futureDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: _accentColor),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: _textPrimary),
              ),
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // ── SliverAppBar + Backdrop ──
              SliverAppBar(
                backgroundColor: _bgColor,
                expandedHeight: 260,
                pinned: true,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      movie.backdropUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: movie.backdropUrl,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(color: _cardColor),
                            )
                          : Container(color: _cardColor),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Color(0xB30D0D1A), Color(0xFF0D0D1A)],
                            stops: [0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Konten ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Poster + Info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: movie.posterUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: movie.posterUrl,
                                    width: 110,
                                    height: 165,
                                    fit: BoxFit.cover,
                                    errorWidget: (_, __, ___) => Container(
                                      width: 110,
                                      height: 165,
                                      color: _cardColor,
                                      child: const Icon(Icons.movie, color: _textSecondary),
                                    ),
                                  )
                                : Container(
                                    width: 110,
                                    height: 165,
                                    color: _cardColor,
                                    child: const Icon(Icons.movie, color: _textSecondary),
                                  ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: const TextStyle(
                                    color: _textPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (movie.releaseDate.isNotEmpty)
                                  Text(
                                    movie.releaseDate.split('-').first,
                                    style: const TextStyle(color: _textSecondary, fontSize: 13),
                                  ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: _goldColor, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(color: _goldColor, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.timer_outlined, color: _textSecondary, size: 15),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${movie.runtime} min',
                                      style: const TextStyle(color: _textSecondary, fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                movie.genres.isNotEmpty
                                    ? Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        children: movie.genres.map((g) => Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: _accentColor, width: 1),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(g, style: const TextStyle(color: _accentColor, fontSize: 11)),
                                        )).toList(),
                                      )
                                    : const Text('Genre tidak tersedia', style: TextStyle(color: _textSecondary, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Sinopsis ──
                      const _SectionTitle(title: 'Sinopsis'),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty ? movie.overview : 'Sinopsis tidak tersedia.',
                        style: const TextStyle(color: _textSecondary, fontSize: 14, height: 1.5),
                      ),

                      const SizedBox(height: 24),

                      // ── Trailer ──
                      const _SectionTitle(title: 'Trailer'),
                      const SizedBox(height: 8),
                      _buildVideoSection(movie.videos),

                      const SizedBox(height: 24),

                      // ── Ulasan ──
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const _SectionTitle(title: 'Ulasan'),
                          FutureBuilder<ReviewResponse>(
                            future: _futureReviews,
                            builder: (_, snap) {
                              if (snap.hasData && snap.data!.results.isNotEmpty) {
                                return TextButton(
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AllReviewsPage(
                                        movieId: widget.movieId,
                                        movieTitle: movie.title,
                                      ),
                                    ),
                                  ),
                                  child: const Text('Lihat Semua', style: TextStyle(color: _accentColor)),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _buildReviewSection(),

                      const SizedBox(height: 24),

                      // ── Film Serupa ──
                      const _SectionTitle(title: 'Film Serupa'),
                      const SizedBox(height: 8),
                      _buildSimilarSection(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVideoSection(List<VideoModel> videos) {
    final trailers = videos
        .where((v) => v.site == 'YouTube' && (v.type == 'Trailer' || v.type == 'Teaser'))
        .toList();

    if (trailers.isEmpty) {
      return Container(
        height: 60,
        decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12)),
        child: const Center(
          child: Text('Tidak ada trailer tersedia.', style: TextStyle(color: _textSecondary)),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: trailers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final v = trailers[i];
          return GestureDetector(
            onTap: () => _openYoutube(v.youtubeUrl),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: v.youtubeThumbnail,
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(width: 180, height: 120, color: _cardColor),
                  ),
                ),
                Container(
                  width: 180,
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0x660D0D1A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: _accentColor, shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewSection() {
    return FutureBuilder<ReviewResponse>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _accentColor, strokeWidth: 2));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('Gagal memuat ulasan.', style: TextStyle(color: _textSecondary));
        }

        final reviews = snapshot.data!.results;
        if (reviews.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('Belum ada ulasan.', style: TextStyle(color: _textSecondary))),
          );
        }

        return Column(children: reviews.take(3).map((r) => _ReviewCard(review: r)).toList());
      },
    );
  }

  Widget _buildSimilarSection() {
    return FutureBuilder<MovieResponse>(
      future: _futureSimilar,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: _accentColor, strokeWidth: 2));
        }
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.results.isEmpty) {
          return const Text('Tidak ada film serupa.', style: TextStyle(color: _textSecondary));
        }

        final movies = snapshot.data!.results;
        return SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final m = movies[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MovieDetailPage(movieId: m.id)),
                ),
                child: SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: m.posterUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: m.posterUrl,
                                width: 110,
                                height: 155,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) => Container(
                                  width: 110,
                                  height: 155,
                                  color: _cardColor,
                                  child: const Icon(Icons.movie, color: _textSecondary),
                                ),
                              )
                            : Container(
                                width: 110,
                                height: 155,
                                color: _cardColor,
                                child: const Icon(Icons.movie, color: _textSecondary),
                              ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        m.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _textPrimary, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Reusable Widgets ──

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE50914),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(color: Color(0xFFF0F0F0), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final Review review;
  const _ReviewCard({required this.review});

  static const Color _cardColor = Color(0xFF1A1A2E);
  static const Color _textPrimary = Color(0xFFF0F0F0);
  static const Color _textSecondary = Color(0xFF9E9E9E);
  static const Color _goldColor = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: _cardColor, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFF252538),
                backgroundImage: review.avatarPath != null
                    ? CachedNetworkImageProvider(review.avatarPath!)
                    : null,
                child: review.avatarPath == null
                    ? Text(
                        review.author.isNotEmpty ? review.author[0].toUpperCase() : '?',
                        style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              if (review.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: _goldColor),
                    const SizedBox(width: 2),
                    Text(review.rating!.toStringAsFixed(1), style: const TextStyle(color: _goldColor, fontSize: 12)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: _textSecondary, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }
}
