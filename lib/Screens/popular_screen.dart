import 'package:app1f/models/popular_model.dart';
import 'package:app1f/network/api_popular.dart';
import 'package:app1f/widgets/item_movie.dart';
import 'package:flutter/material.dart';

class POpularScreen extends StatefulWidget {
  const POpularScreen({super.key});

  @override
  State<POpularScreen> createState() => _POpularScreenState();
}

class _POpularScreenState extends State<POpularScreen> {
  ApiPopular? apiPopular;

  @override
  void initState() {
    super.initState();
    apiPopular = ApiPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular Movies !!!!!!!!')),
      body: FutureBuilder(
          future: apiPopular!.getAllPopular(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .9, 
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return itemMovieWidget(snapshot.data![index],context);
                  });
            } else {
              if (snapshot.hasError) {
                return Center(child: Text('Algo salio mal !!!!'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }
          }),
    );
  }
}
