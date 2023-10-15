import 'package:app1f/Screens/task_screen.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:app1f/widgets/CardCarrerWidget.dart';
import 'package:app1f/widgets/CardTaskWidget.dart';
import 'package:flutter/material.dart';

class taskDelegate extends SearchDelegate<TaskModel> {
  List<String>? data;
  AgendaDB? agendaDB;
  List<TaskModel>? dataT;

  taskDelegate(List<String> data, AgendaDB agendaDB, List<TaskModel> dataT) {
    this.data = data;
    this.agendaDB = agendaDB;
    this.dataT = dataT;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {}

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<TaskModel> searchResults = dataT!
        .where((element) =>
            element.nameTask.toString().toLowerCase().contains(query.toLowerCase()) ||
            element.descTask.toString().toLowerCase().contains(query.toLowerCase()) ||
            element.dateE.toString().toLowerCase().contains(query.toLowerCase())
            )
            
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return CardTaskWidget(
          taskModel: searchResults[index],
          agendaDB: agendaDB,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<TaskModel> suggestionList = query.isEmpty
        ? []
        : dataT!
            .where((element) =>
                element.nameTask.toString().toLowerCase().contains(query.toLowerCase()) ||
                element.descTask.toString().toLowerCase().contains(query.toLowerCase()) ||
                element.dateE.toString().toLowerCase().contains(query.toLowerCase())
                )
            
                        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return CardTaskWidget(
          taskModel: suggestionList[index],
          agendaDB: agendaDB,
        );
      },
    );
  }
}
