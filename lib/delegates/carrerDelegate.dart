import 'package:app1f/database/agendadb.dart';
import 'package:app1f/models/carrermodel.dart';
import 'package:app1f/widgets/CardCarrerWidget.dart';
import 'package:flutter/material.dart';

class carrerDelegate extends SearchDelegate<CarrerModel> {
  List<String>? data;
  AgendaDB? agendaDB;
  List<CarrerModel>? dataT;

  carrerDelegate(List<String> data, AgendaDB agendaDB, List<CarrerModel> dataT) {
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
    final List<CarrerModel> searchResults = dataT!
        .where((element) =>
            element.nameCarrer.toString().toLowerCase().contains(query.toLowerCase()) )
            
        .toList();
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return CardCarrerWidget(
          carrerModel: searchResults[index],
          agendaDB: agendaDB,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<CarrerModel> suggestionList = query.isEmpty
        ? []
        : dataT!
            .where((element) =>
            element.nameCarrer.toString().toLowerCase().contains(query.toLowerCase()) )
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return CardCarrerWidget(
          carrerModel: suggestionList[index],
          agendaDB: agendaDB,
        );
      },
    );
  }
}
