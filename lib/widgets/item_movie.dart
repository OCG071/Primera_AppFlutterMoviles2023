import 'package:app1f/models/popular_model.dart';
import 'package:flutter/material.dart';

Widget itemMovieWidget(PopularModel movie) { 
  print('https://image.tmdb.org/t/p/w500/${movie.posterPath}');
  return FadeInImage(
    fadeInDuration: Duration(milliseconds: 2000),
    placeholder: AssetImage('assets/giphy.gif') ,
   
    image: NetworkImage('https://image.tmdb.org/t/p/w500/${movie.posterPath}') ,
  );
}
 