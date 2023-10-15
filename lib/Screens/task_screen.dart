import 'package:app1f/database/agendadb.dart';
import 'package:app1f/delegates/taskDelegate.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:app1f/widgets/CardTaskWidget.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  AgendaDB? agendaDB;
  List<String> dataT = [];
  int? selectedIndex;
  List<String> options = ['En proceso', 'Completado', 'Pendiente'];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    agendaDB = AgendaDB();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: agendaDB!.GETALLTASK(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Task Manager'),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                tooltip: 'Search Task',
                onPressed: !snapshot.hasData
                    ? null
                    : () {
                        dataT = [];
                        agendaDB!.GETALLTASK().then((list) {
                          list.map((map) {
                            dataT.add(map.nameTask.toString());
                          }).forEach((item) {
                            setState(() {});
                          });
                        });
                        showSearch(
                          context: context,
                          delegate:
                              taskDelegate(dataT, agendaDB!, snapshot.data!),
                        );
                      },
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/addTask').then((value) {
                  setState(() {});
                }),
                icon: Icon(Icons.task),
              )
            ],
          ),
          body: <Widget>[
            ValueListenableBuilder(
              valueListenable: GlobalValues.flagTask,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETALLTASK(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardTaskWidget(
                              taskModel: snapshot.data![index],
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
              },
            ),
            ValueListenableBuilder(
              valueListenable: GlobalValues.flagTask,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETTASKSST('C'),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardTaskWidget(
                              taskModel: snapshot.data![index],
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
              },
            ),
            ValueListenableBuilder(
              valueListenable: GlobalValues.flagTask,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETTASKSST('E'),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardTaskWidget(
                              taskModel: snapshot.data![index],
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
              },
            ),
            ValueListenableBuilder(
              valueListenable: GlobalValues.flagTask,
              builder: (context, value, _) {
                return FutureBuilder(
                  future: agendaDB!.GETTASKSST('P'),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TaskModel>> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount:
                            snapshot.data!.length, // snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CardTaskWidget(
                              taskModel: snapshot.data![index],
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
              },
            ),
          ][currentPageIndex],
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            indicatorColor: Colors.amber[700],
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.clear_all_outlined),
                icon: Icon(Icons.clear_all),
                label: 'All',
              ),
              NavigationDestination(
                  icon: Icon(Icons.task_alt), label: 'Complete'),
              NavigationDestination(
                  icon: Icon(Icons.access_alarm), label: 'In Progress'),
              NavigationDestination(
                  icon: Icon(Icons.lock_clock), label: 'Oustanding'),
            ],
          ),
        );
      },
    );
  }
}
