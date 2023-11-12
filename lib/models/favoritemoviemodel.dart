class FavoriteMovieModel {
  int? idFavorite;
  String? nameMovie;
  String? image;

  FavoriteMovieModel({this.idFavorite, this.nameMovie, this.image});
  factory FavoriteMovieModel.fromMap(Map<String, dynamic> map) {
    return FavoriteMovieModel(
        idFavorite: map['idFavorite'], 
        nameMovie: map['nameMovie'],
        image: map['image']);
  }
}
