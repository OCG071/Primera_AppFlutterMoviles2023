import 'package:app1f/database/agendadb.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.task),
          )
        ],
      ),
      body: FutureBuilder(
        future: agendaDB!.GETALLTASK(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TaskModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: 5, // snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return Text('Hola');
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
      ),
    );
  }
}
