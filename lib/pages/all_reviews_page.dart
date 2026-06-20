import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/review_model.dart';
import '../services/api_service_dio.dart';

class AllReviewsPage extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const AllReviewsPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  final ApiServiceDio _apiService = ApiServiceDio();
  final ScrollController _scrollController = ScrollController();

  final List<Review> _reviews = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _hasError = false;

  static const Color _bgColor = Color(0xFF0D0D1A);
  static const Color _accentColor = Color(0xFFE50914);
  static const Color _textPrimary = Color(0xFFF0F0F0);
  static const Color _textSecondary = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    _loadPage(1);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _currentPage < _totalPages) {
        _loadPage(_currentPage + 1);
      }
    }
  }

  Future<void> _loadPage(int page) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final response =
          await _apiService.getMovieReviews(widget.movieId, page: page);
      setState(() {
        _reviews.addAll(response.results);
        _currentPage = response.page;
        _totalPages = response.totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Semua Ulasan',
              style: TextStyle(color: _textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.movieTitle,
              style: const TextStyle(color: _textSecondary, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: _reviews.isEmpty && _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _accentColor),
            )
          : _reviews.isEmpty && _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: _accentColor, size: 48),
                      const SizedBox(height: 12),
                      const Text('Gagal memuat ulasan.',
                          style: TextStyle(color: _textPrimary)),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: _accentColor),
                        onPressed: () => _loadPage(1),
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                )
              : _reviews.isEmpty
                  ? const Center(
                      child: Text('Belum ada ulasan.',
                          style: TextStyle(color: _textSecondary)),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _reviews.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _reviews.length) {
                          if (_isLoading) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                    color: _accentColor, strokeWidth: 2),
                              ),
                            );
                          }
                          if (_currentPage >= _totalPages) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  'Semua ulasan telah ditampilkan.',
                                  style: TextStyle(color: _textSecondary, fontSize: 12),
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        }

                        final review = _reviews[index];
                        return _FullReviewCard(review: review);
                      },
                    ),
    );
  }
}

class _FullReviewCard extends StatefulWidget {
  final Review review;
  const _FullReviewCard({required this.review});

  @override
  State<_FullReviewCard> createState() => _FullReviewCardState();
}

class _FullReviewCardState extends State<_FullReviewCard> {
  bool _expanded = false;

  static const Color _cardColor = Color(0xFF1A1A2E);
  static const Color _textPrimary = Color(0xFFF0F0F0);
  static const Color _textSecondary = Color(0xFF9E9E9E);
  static const Color _accentColor = Color(0xFFE50914);
  static const Color _goldColor = Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF252538),
                backgroundImage: widget.review.avatarPath != null
                    ? CachedNetworkImageProvider(widget.review.avatarPath!)
                    : null,
                child: widget.review.avatarPath == null
                    ? Text(
                        widget.review.author.isNotEmpty
                            ? widget.review.author[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                            color: _textPrimary, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.review.author,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (widget.review.rating != null)
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 15, color: _goldColor),
                    const SizedBox(width: 2),
                    Text(
                      widget.review.rating!.toStringAsFixed(1),
                      style: const TextStyle(color: _goldColor, fontSize: 12),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Content
          Text(
            widget.review.content,
            maxLines: _expanded ? null : 5,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: const TextStyle(
              color: _textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          // Expand/collapse button
          if (widget.review.content.length > 300)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  _expanded ? 'Tampilkan lebih sedikit' : 'Tampilkan selengkapnya',
                  style: const TextStyle(color: _accentColor, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
