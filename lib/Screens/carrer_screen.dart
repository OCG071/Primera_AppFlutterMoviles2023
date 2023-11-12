import 'package:app1f/database/agendadb.dart';
import 'package:app1f/delegates/carrerDelegate.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/carrermodel.dart';
import 'package:app1f/widgets/CardCarrerWidget.dart';
import 'package:flutter/material.dart';

class CarrerScreen extends StatefulWidget {
  const CarrerScreen({super.key});

  @override
  State<CarrerScreen> createState() => _CarrerScreenState();
}

class _CarrerScreenState extends State<CarrerScreen> {
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
      future: agendaDB!.GETALLCARRER(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Carrers Manager'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search Teacher',
                onPressed: !snapshot.hasData
                    ? null
                    : () {
                        dataT = [];
                        agendaDB!.GETALLCARRER().then((list) {
                          list.map((map) {
                            dataT.add(map.nameCarrer.toString());
                          }).forEach((item) {
                            setState(() {});
                          });
                        });
                        showSearch(
                          context: context,
                          delegate:
                              carrerDelegate(dataT, agendaDB!, snapshot.data!),
                        );
                      },
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/addCarrer').then((value) {
                  setState(() {});
                }),
                icon: Icon(Icons.task),
              )
            ],
          ),
          body: ValueListenableBuilder(
              valueListenable: GlobalValues.flagCarrer,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETALLCARRER(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CarrerModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardCarrerWidget(
                              carrerModel: snapshot.data![index],
                              agendaDB: agendaDB);
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
