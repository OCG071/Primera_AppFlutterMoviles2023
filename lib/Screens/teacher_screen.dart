import 'package:app1f/database/agendadb.dart';
import 'package:app1f/delegates/teacherDelegate.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/teachermodel.dart';
import 'package:app1f/widgets/CardTeacherWidget.dart';
import 'package:flutter/material.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
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
      future: agendaDB!.GETALLTEACHER(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Teachers Manager'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search Teacher',
                onPressed: !snapshot.hasData
                    ? null
                    : () {
                        dataT = [];
                        agendaDB!.GETALLTEACHER().then((list) { 
                          list.map((map) {
                            dataT.add(map.nameTeacher.toString());
                          }).forEach((item) {
                            setState(() {});
                          });
                        });
                        showSearch(
                          context: context,
                          delegate:
                              teacherDelegate(dataT, agendaDB!, snapshot.data!),
                        );
                      },
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/addTeacher').then((value) {
                  setState(() {});
                }),
                icon: Icon(Icons.task),
              )
            ],
          ),
          body: ValueListenableBuilder(
              valueListenable: GlobalValues.flagTeacher,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETALLTEACHER(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TeacherModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardTeacherWidget(
                              teacherModel: snapshot.data![index],
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
