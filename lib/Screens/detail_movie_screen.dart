import 'package:app1f/models/popular_model.dart';
import 'package:flutter/material.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  PopularModel? movie;

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as PopularModel;
    return Scaffold(
      body: Center(child: Text(movie!.title!)),
    );
  }
}
