import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:peliculas_app/search/movie_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en Cines',
            style: TextStyle(color: Colors.white)),
        actions: [
         IconButton(
           icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () => showSearch(
            context: context,
            delegate: MovieSearchDelegate(),
    ),
  ),
],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProvider.onDisplayMovies),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
      ),
    );
  }
}