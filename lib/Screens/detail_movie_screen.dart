import 'package:app1f/models/castmodel.dart';
import 'package:app1f/models/popular_model.dart';
import 'package:app1f/models/trailersmodel.dart';
import 'package:app1f/network/api_cast.dart';
import 'package:app1f/network/api_trailer.dart';
import 'package:app1f/widgets/ActorsWidget.dart';
import 'package:circular_image/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  PopularModel? movie;
  ApiTrailer? trailer;
  ApiCast? cast;

  String res = '';
  bool favorited = true;
  double review = 0.0;

  Future<void> getID(int id) async {
    trailer!.getTrailer(id).then((list) {
      list!.map((e) {
        if (e.type == 'Trailer') {
          setState(() {
            res = e.key!.toString();
            print(e.key.toString());
            print('res: $res');
          });
        }
      }).forEach((element) {});
    });
  }

  @override
  void initState() {
    super.initState();
    trailer = ApiTrailer();
    cast = ApiCast();
  }

  void _toggleFavorite() {
    favorited = !favorited;
  }

  @override
  Widget build(BuildContext context) {
    movie = ModalRoute.of(context)!.settings.arguments as PopularModel;
    review = (movie!.voteAverage! / 10) * 5;
    return FutureBuilder(
        future: trailer!.getTrailer(movie!.id!),
        builder: (context, AsyncSnapshot<List<TrailerModel>?> snapshot) {
          if (snapshot.hasData) {
            snapshot.data!.map((e) {
              if (e.type == 'Trailer') {
                res = e.key!;
              }
            }).forEach((element) {});
          }
          return Scaffold(
            appBar: AppBar(title: Text(movie!.title!),
            actions: [
                IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/addTask').then((value) {
                  setState(() {});
                }),
                icon: Icon(Icons.favorite),
                color: Colors.pink,
            )
            ]),
            
            body: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.6,
                        image: NetworkImage(
                            'https://image.tmdb.org/t/p/w500/${movie!.posterPath}'),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    res != ''
                        ? YoutubePlayer(
                            controller: YoutubePlayerController(
                                initialVideoId: res,
                                flags: const YoutubePlayerFlags(
                                    autoPlay: false, mute: false)))
                        : Row(children: [
                            Text(
                              'Lo sentimos. Trailer no disponible.',
                              style: TextStyle(
                                  backgroundColor: Colors.red,
                                  color: Colors.white,
                                  fontSize: 26.9),
                            ),
                          ]),
                    const SizedBox(
                      height: 25,
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              movie!.title!,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              movie!.overview!,
                              style: TextStyle(fontSize: 16),
                              maxLines: 3,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RatingBar.builder(
                                  initialRating: review,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) {
                                    return Icon(Icons.star,
                                        color: Colors.amber);
                                  },
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      review = review;
                                    });
                                  },
                                ),
                                Text(
                                  'Rating: ' + movie!.voteAverage!.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.amber,
                            height: 190,
                            child: FutureBuilder(
                                future: cast!.getCast(movie!.id!),
                                builder: (context,
                                    AsyncSnapshot<List<CastModel>?> shot) {
                                  if (shot.hasData) {
                                    return SizedBox(
                                      width: 100,
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.all(12),
                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 12);
                                        },
                                        itemCount: shot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ActorsWidget(
                                              castModel: shot.data![index]);
                                        },
                                      ),
                                    );
                                  } else {
                                    return Row(children: [
                                      Text(
                                        'Lo sentimos. Actores no disponibles.',
                                        style: TextStyle(
                                            backgroundColor: Colors.red,
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                    ]);
                                  }
                                }),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal),
                                ),
                                child: IconButton(
                                    icon: favorited
                                        ? Icon(
                                            Icons.favorite_border,
                                            color: Colors.pink,
                                          )
                                        : Icon(
                                            Icons.favorite,
                                            color: Colors.pink,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _toggleFavorite();
                                      });
                                    }),
                                onPressed: () {
                                  setState(() {
                                    _toggleFavorite();
                                  });
                                }),
                          )
                        ])
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: true,
          );
        }

        /*body: FutureBuilder(
            future: trailer!.getTrailer(movie!.id!),
            builder: (context, AsyncSnapshot<List<TrailerModel>?> snapshot) {
              if (snapshot.hasData) {
                snapshot.data!.map((e) {
                  if (e.type == 'Trailer') {
                    res = e.key!;
                  }
                }).forEach((element) {});
                if (res != '') {
                  return YoutubePlayer(
                      controller: YoutubePlayerController(
                          initialVideoId: res,
                          flags: const YoutubePlayerFlags(
                              autoPlay: false, mute: false)
                              )
                              );
                } else {
                  return const Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: Text(
                        'Lo sentimos. Trailer no disponible.',
                        style: TextStyle(
                            backgroundColor: Colors.red,
                            fontSize: 26.9),
                                          ),
                      ),]
                  );
                }
              } else {
                return const Text('Error en carga de trailer');
              }
            }
            ),*/
        );
  }
}
