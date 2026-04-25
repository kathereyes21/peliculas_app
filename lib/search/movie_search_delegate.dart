import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar película...';

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final provider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: provider.searchMovies(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.isEmpty) {
          return const Center(child: Text('No se encontraron resultados'));
        }
        return _MovieList(movies: snapshot.data!);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'Busca tu película favorita',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return buildResults(context);
  }
}

class _MovieList extends StatelessWidget {
  final List<Movie> movies;
  const _MovieList({required this.movies});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (_, index) {
        final movie = movies[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullPosterImg),
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(movie.title),
          subtitle: Text(
            movie.overview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => Navigator.pushNamed(
            context,
            'details',
            arguments: movie,
          ),
        );
      },
    );
  }
}