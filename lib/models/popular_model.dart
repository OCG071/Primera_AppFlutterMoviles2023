import 'dart:convert';

class PopularModel {
  String? backdropPath;
  int? id;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  String? releaseDate;
  String? title;
  double? voteAverage;
  int? voteCount;

  PopularModel({
    this.backdropPath,
    this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.voteAverage,
    this.voteCount,
  });

  factory PopularModel.fromMap(Map<String, dynamic> map) {
    return PopularModel(
      backdropPath: map['backdrop_path'] ?? '',
      id: map['id'],
      originalLanguage: map['original_language'],
      originalTitle: map['original_title'],
      overview: map['overview'],
      popularity: map['popularity'],
      posterPath: map['poster_path'] ?? '',
      releaseDate: map['release_date'],
      title: map['title'],
      voteAverage: (map['vote_average'] is int)
          ? (map['vote_average'] as int).toDouble()
          : map['vote_average'],
      voteCount: map['vote_count'],
    );
  }
  factory PopularModel.fromJSON(Map<String,dynamic> json) {
    return PopularModel(
      backdropPath: json['backdrop_path'] ?? '',
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'],
      title: json['title'],
      voteAverage: (json['vote_average'] is int)
          ? (json['vote_average'] as int).toDouble()
          : json['vote_average'],
      voteCount: json['vote_count'],
    );
  }
}
