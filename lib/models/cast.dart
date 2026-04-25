class Cast {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;

  Cast({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
  });

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        id: json['id'],
        name: json['name'],
        character: json['character'],
        profilePath: json['profile_path'],
      );
}

class CreditsResponse {
  final int movieId;
  final List<Cast> cast;

  CreditsResponse({required this.movieId, required this.cast});

  factory CreditsResponse.fromMap(Map<String, dynamic> json) => CreditsResponse(
        movieId: json['id'],
        cast: List<Cast>.from(json['cast'].map((x) => Cast.fromMap(x))),
      );
}