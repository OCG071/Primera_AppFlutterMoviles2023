import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/favoritemoviemodel.dart';
import 'package:app1f/widgets/CardFavMovWidget%20.dart';
import 'package:flutter/material.dart';

class FavMovScreen extends StatefulWidget {
  const FavMovScreen({super.key});

  @override
  State<FavMovScreen> createState() => _FavMovScreenState();
}

class _FavMovScreenState extends State<FavMovScreen> {
  AgendaDB? agendaDB;
  List<String> dataT = [];

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: agendaDB!.GETALLFAVMOV(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('YOUR FAVORITE MOVIES'),
          ),
          body: ValueListenableBuilder(
              valueListenable: GlobalValues.flagFavMov,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETALLFAVMOV(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FavoriteMovieModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount: 
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardFavMovWidget(
                              favmovmodel: snapshot.data![index],
                              agendaDB: agendaDB);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 10,
                          );
                        },
                      );
                    } else {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something was wrong !!'),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }
                  },
                );
              }),
        );
      }, 
    );
  }
}
