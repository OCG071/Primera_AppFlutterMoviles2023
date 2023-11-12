// ignore: file_names
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/favoritemoviemodel.dart';
import 'package:app1f/models/popular_model.dart';
import 'package:app1f/network/api_popular.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardFavMovWidget extends StatefulWidget {
  CardFavMovWidget({super.key, required this.favmovmodel, this.agendaDB});

  FavoriteMovieModel favmovmodel; 
  AgendaDB? agendaDB;

  @override
  State<CardFavMovWidget> createState() => _CardFavMovWidgetState();
}

class _CardFavMovWidgetState extends State<CardFavMovWidget> {
  ApiPopular? apiPopular;
  PopularModel? movie;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
    apiPopular!.getMovie(widget.favmovmodel.idFavorite!).then((list) {
      movie = list;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 10),
      leading: Container(
          height: 200,
          child: Image(
            image: NetworkImage(
                'https://image.tmdb.org/t/p/w500/${widget.favmovmodel.image}'),
            height: 150,
          ),
        ),

      title: Hero(
        tag: widget.favmovmodel.idFavorite.toString(),
        child: Text(widget.favmovmodel.nameMovie!)),
      trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.pink,
          onPressed: () {
            widget.agendaDB!
                .DELETE('tblFavoritaPelicula', 'idFavorite',
                    widget.favmovmodel.idFavorite!)
                .then((value) {
              GlobalValues.flagFavMov.value = !GlobalValues.flagFavMov.value;
            });
          }),
      onTap: () {
        Navigator.pushNamed(context, '/detail', arguments: movie);
      },
    );
  }
}
