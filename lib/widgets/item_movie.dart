import 'package:app1f/models/popular_model.dart';
import 'package:flutter/material.dart';

Widget itemMovieWidget(PopularModel movie) {
  return FadeInImage(
    fadeInDuration: Duration(milliseconds: 1000),
    placeholder: AssetImage('assets/giphy.gif') ,
    image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie.posterPath}') ,
  );
}
