import 'package:app1f/models/popular_model.dart';
import 'package:flutter/material.dart';

Widget itemMovieWidget(PopularModel movie, context) {
  print('https://image.tmdb.org/t/p/w500/${movie.posterPath}');
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/detail', arguments: movie);
    },
    child: FadeInImage(
      fit: BoxFit.fill,
      fadeInDuration: Duration(milliseconds: 2000),
      placeholder: AssetImage('assets/giphy.gif'),
      image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie.posterPath}'),
    ),
  );
}
