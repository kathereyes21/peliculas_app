import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/models/now_playing_response.dart';
import 'package:peliculas_app/models/cast.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = 'f7baea359ce18783053eda3ea74bc4cf';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> movieCredits = {};

  int _popularPage = 1;
  bool _isLoadingPopular = false;

  MoviesProvider() {
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<void> getNowPlayingMovies() async {
    final url = Uri.https(_baseUrl, '/3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });
    final response = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromMap(json.decode(response.body));
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  Future<void> getPopularMovies() async {
    if (_isLoadingPopular) return;
    _isLoadingPopular = true;

    final url = Uri.https(_baseUrl, '/3/movie/popular', {
      'api_key': _apiKey,
      'language': _language,
      'page': '$_popularPage',
    });
    final response = await http.get(url);
    final data = json.decode(response.body);
    final List<Movie> movies = List<Movie>.from(data['results'].map((x) => Movie.fromMap(x)));

    popularMovies = [...popularMovies, ...movies];
    _popularPage++;
    _isLoadingPopular = false;
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (movieCredits.containsKey(movieId)) return movieCredits[movieId]!;

    final url = Uri.https(_baseUrl, '/3/movie/$movieId/credits', {
      'api_key': _apiKey,
      'language': _language,
    });
    final response = await http.get(url);
    final credits = CreditsResponse.fromMap(json.decode(response.body));
    movieCredits[movieId] = credits.cast;
    return credits.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.https(_baseUrl, '/3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });
    final response = await http.get(url);
    final data = json.decode(response.body);
    return List<Movie>.from(data['results'].map((x) => Movie.fromMap(x)));
  }
}