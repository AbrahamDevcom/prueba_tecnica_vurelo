import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:cinepulse/features/movies/controllers/movies_controller.dart';
import 'package:cinepulse/features/movies/widgets/movie_section.dart';
import 'package:cinepulse/features/movies/widgets/filter_chips.dart';
import 'package:cinepulse/features/movies/widgets/movie_grid_item.dart';
import 'package:cinepulse/features/movies/screens/movie_detail_screen.dart';
import 'package:cinepulse/core/models/movie.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(moviesControllerProvider.notifier).loadAll();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moviesControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(moviesControllerProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              _buildContent(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
      title: FadeTransition(
        opacity: _fadeAnimation,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.movie,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CinePulse',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, MoviesState state) {
    final hasError = state.error != null &&
        !state.loadingUpcoming &&
        !state.loadingTrending &&
        state.upcoming.isEmpty &&
        state.trending.isEmpty;

    return SliverToBoxAdapter(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: hasError
              ? _buildErrorState(context, state.error!)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    MovieSection(
                      title: 'Próximos estrenos',
                      movies: state.upcoming,
                      onMovieTap: _navigateToMovieDetail,
                      // Show shimmer while loading or while list is still empty and no error yet
                      isLoading: state.loadingUpcoming || (state.upcoming.isEmpty && state.error == null),
                    ),

                    const SizedBox(height: 32),

                    MovieSection(
                      title: 'Tendencia',
                      movies: state.trending,
                      onMovieTap: _navigateToMovieDetail,
                      // Show shimmer while loading or while list is still empty and no error yet
                      isLoading: state.loadingTrending || (state.trending.isEmpty && state.error == null),
                    ),

                    const SizedBox(height: 32),

                    _buildRecommendationsSection(context, state),

                    const SizedBox(height: 32),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildRecommendationsSection(BuildContext context, MoviesState state) {
    final controller = ref.read(moviesControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Recomendados para ti',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),

        const SizedBox(height: 16),

        if (state.trending.isNotEmpty || state.loadingTrending) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Skeletonizer(
              enabled: state.loadingTrending,
              child: FilterChips(
                selectedLanguage: state.selectedLanguage,
                selectedYear: state.selectedYear,
                availableLanguages: controller.availableLanguages,
                availableYears: controller.availableYears,
                onLanguageChanged: controller.setLanguageFilter,
                onYearChanged: controller.setYearFilter,
                onClearFilters: controller.clearFilters,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        if (state.loadingTrending)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return const Skeletonizer(child: _SkeletonMovieCard());
              },
            ),
          )
        else if (state.recommendations.isEmpty)
          _buildEmptyRecommendations(context)
        else
          _buildMovieGrid(context, state.recommendations),
      ],
    );
  }

  Widget _buildMovieGrid(BuildContext context, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOutQuart,
            child: MovieGridItem(
              movie: movie,
              onTap: () => _navigateToMovieDetail(movie),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyRecommendations(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.filter_alt_off,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No se encontraron películas con los filtros seleccionados',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar las películas',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(moviesControllerProvider.notifier).loadAll(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMovieDetail(Movie movie) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MovieDetailScreen(movie: movie),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          final slideTween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );

          return SlideTransition(
            position: slideTween.animate(curvedAnimation),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class _SkeletonMovieCard extends StatelessWidget {
  const _SkeletonMovieCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 16,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 14,
          width: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
