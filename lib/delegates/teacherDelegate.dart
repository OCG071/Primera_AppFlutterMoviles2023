import 'package:app1f/database/agendadb.dart';
import 'package:app1f/models/teachermodel.dart';
import 'package:app1f/widgets/CardTeacherWidget.dart';
import 'package:flutter/material.dart';

class teacherDelegate extends SearchDelegate<TeacherModel> {
  List<String>? data;
  AgendaDB? agendaDB;
  List<TeacherModel>? dataT;

  teacherDelegate(List<String> data, AgendaDB agendaDB, List<TeacherModel> dataT) {
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
    final List<TeacherModel> searchResults = dataT!
        .where((element) =>
            element.nameTeacher.toString().toLowerCase().contains(query.toLowerCase()) ||
            element.email.toString().toLowerCase().contains(query.toLowerCase())
            )
            
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return CardTeacherWidget(
          teacherModel: searchResults[index],
          agendaDB: agendaDB,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<TeacherModel> suggestionList = query.isEmpty
        ? []
        : dataT!
            .where((element) =>
            element.nameTeacher.toString().toLowerCase().contains(query.toLowerCase()) ||
            element.email.toString().toLowerCase().contains(query.toLowerCase())                
                )
            
                        .toList();
    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return CardTeacherWidget(
          teacherModel: suggestionList[index],
          agendaDB: agendaDB,
        );
      },
    );
  }
}
