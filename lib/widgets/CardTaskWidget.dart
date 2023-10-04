import 'package:app1f/Screens/add_task.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';

class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({super.key, required this.taskModel, this.agendaDB});

  TaskModel taskModel;
  AgendaDB? agendaDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.purple),
      child: Row(
        children: [
          Column(
            children: [
              Text(taskModel.nameTask!),
              Text(taskModel.descTask!)
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: [
              GestureDetector(
                child: Image.asset(
                  'assets/uva.png',
                  height: 50,
                ),
                onTap: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddTask(taskModel: taskModel))
                ),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Mensaje del System"),
                            backgroundColor: Colors.amberAccent,
                            content: Text('Quieres borrar la tarea ???'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    agendaDB!
                                        .DELETE('tblTareas',
                                            taskModel.idTask!)
                                        .then((value) {
                                      Navigator.pop(context);
                                      GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
                                    });
                                  },
                                  child: Text("Simonky")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Nel")),
                            ],
                          );
                        });
                  },
                  icon: Icon(Icons.delete))
            ],
          )
        ],
      ),
    );
  }
}
