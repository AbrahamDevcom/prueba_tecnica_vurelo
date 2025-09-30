import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cinepulse/core/models/movie.dart';
import 'package:cinepulse/core/models/movie_detail.dart';
import 'package:cinepulse/features/movies/controllers/movie_detail_controller.dart';

class MovieDetailScreen extends ConsumerStatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final DraggableScrollableController _dragController =
      DraggableScrollableController();
  double _sheetSize = 0.35;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _dragController.addListener(() {
      setState(() {
        _sheetSize = _dragController.size;
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieDetailControllerProvider.notifier).load(widget.movie.id);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _dragController.dispose();
    Future.microtask(() {
      if (mounted) {
        ref.read(movieDetailControllerProvider.notifier).clear();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieDetailControllerProvider);

    final detail = state.detail;
    final posterUrl = detail?.fullPosterUrl.isNotEmpty == true
        ? detail!.fullPosterUrl
        : (widget.movie.posterPath.isNotEmpty
            ? widget.movie.fullPosterUrl
            : (detail?.fullBackdropUrl.isNotEmpty == true
                ? detail!.fullBackdropUrl
                : widget.movie.fullBackdropUrl));

    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    // Dynamic opacities based on sheet size
    final t = ((_sheetSize - 0.28) / (0.92 - 0.28)).clamp(0.0, 1.0);
    final sheetBgAlpha = lerpDouble(0.55, 1.0, t);
    final scrimBottomAlpha = lerpDouble(0.35, 0.65, t);
    final appBarBgAlpha = lerpDouble(0.0, 0.85, t);

    return Scaffold(
      backgroundColor: surface,
      body: Stack(
        children: [
          // Background image full-bleed
          Positioned.fill(
            child: posterUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: posterUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: surface),
                    errorWidget: (context, url, error) => Container(
                      color: surface,
                      child: Icon(
                        Icons.movie,
                        size: 64,
                        color: onSurface.withValues(alpha: 0.3),
                      ),
                    ),
                  )
                : Container(
                    color: surface,
                    child: Icon(
                      Icons.movie,
                      size: 64,
                      color: onSurface.withValues(alpha: 0.3),
                    ),
                  ),
          ),

          // Gradient scrim
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black
                          .withValues(alpha: (scrimBottomAlpha ?? 0.55)),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Top app bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black
                          .withValues(alpha: (appBarBgAlpha ?? 0.0)),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),

          // Draggable content sheet
          _buildDraggableSheet(context, state,
              backgroundColor:
                  surface.withValues(alpha: (sheetBgAlpha ?? 0.85))),
        ],
      ),
    );
  }

  Widget _buildDraggableSheet(
    BuildContext context,
    MovieDetailState state, {
    required Color backgroundColor,
  }) {
    final trailer = state.videos.isEmpty
        ? null
        : ref.read(movieDetailControllerProvider.notifier).trailerVideo;

    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        setState(() {
          _sheetSize = notification.extent;
        });
        return false;
      },
      child: DraggableScrollableSheet(
        controller: _dragController,
        initialChildSize: 0.35,
        minChildSize: 0.25,
        maxChildSize: 0.92,
        snap: true,
        snapSizes: const [0.35, 0.6, 0.92],
        builder: (context, scrollController) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Grab handle - área interactiva para drag
                    GestureDetector(
                      onTap: () {
                        // Alternar entre collapsed y expanded
                        if (_sheetSize < 0.5) {
                          _dragController.animateTo(
                            0.6,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          _dragController.animateTo(
                            0.35,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        color: Colors.transparent,
                        child: Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Header con título, rating y botón de trailer
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: _buildHeaderRow(context, state, trailer),
                    ),

                    const SizedBox(height: 4),

                    // Body scrollable
                    Expanded(
                      child: state.loading
                          ? _buildLoadingList(context, scrollController)
                          : state.error != null
                              ? _buildErrorList(
                                  context, state.error!, scrollController)
                              : _buildDetailList(
                                  context, state, scrollController),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderRow(
      BuildContext context, MovieDetailState state, MovieVideo? trailer) {
    final title = state.detail?.title ?? widget.movie.title;
    final rating = state.detail?.voteAverage ?? widget.movie.voteAverage;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
        const SizedBox(width: 12),
        _buildRatingBadge(context, rating),
        const SizedBox(width: 8),
        if (trailer != null && trailer.key.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () => _launchTrailer(trailer.youtubeUrl),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Tráiler'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingList(BuildContext context, ScrollController controller) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Skeletonizer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 60,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 18,
                width: 220,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 18,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 18,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildErrorList(
      BuildContext context, String message, ScrollController controller) {
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
      children: [
        Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar los detalles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.75),
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref
                  .read(movieDetailControllerProvider.notifier)
                  .load(widget.movie.id),
              child: const Text('Reintentar'),
            )
          ],
        )
      ],
    );
  }

  Widget _buildDetailList(BuildContext context, MovieDetailState state,
      ScrollController controller) {
    final movieDetail = state.detail;

    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: [
        // Meta row
        _buildMovieInfoRow(context, movieDetail),
        const SizedBox(height: 14),

        if (movieDetail != null && movieDetail.genres.isNotEmpty) ...[
          _buildGenres(context, movieDetail.genres),
          const SizedBox(height: 20),
        ],

        Text(
          'Sinopsis',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          movieDetail?.overview ?? widget.movie.overview,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.86),
              ),
        ),

        const SizedBox(height: 24),

        if (movieDetail != null) _buildAdditionalInfo(context, movieDetail),
      ],
    );
  }

  Widget _buildRatingBadge(BuildContext context, double rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieInfoRow(BuildContext context, MovieDetail? movieDetail) {
    return Row(
      children: [
        if (movieDetail?.releaseDate.isNotEmpty ??
            widget.movie.releaseDate.isNotEmpty) ...[
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            movieDetail?.releaseDate ?? widget.movie.releaseDate,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
        ],
        if ((movieDetail?.formattedRuntime.isNotEmpty ?? false)) ...[
          const SizedBox(width: 16),
          Icon(
            Icons.access_time,
            size: 16,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 4),
          Text(
            movieDetail?.formattedRuntime ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildGenres(BuildContext context, List<Genre> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            genre.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAdditionalInfo(BuildContext context, MovieDetail movieDetail) {
    if (movieDetail.tagline.isEmpty &&
        movieDetail.originalTitle == movieDetail.title) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movieDetail.tagline.isNotEmpty) ...[
          Text(
            'Lema',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            movieDetail.tagline,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
          const SizedBox(height: 16),
        ],
        if (movieDetail.originalTitle != movieDetail.title) ...[
          Text(
            'Título original',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            movieDetail.originalTitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.8),
                ),
          ),
        ],
      ],
    );
  }

  Future<void> _launchTrailer(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No se pudo abrir el tráiler'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al abrir el tráiler'),
          ),
        );
      }
    }
  }
}
