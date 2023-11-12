// ignore: file_names
import 'package:app1f/Screens/add_task.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({super.key, required this.taskModel, this.agendaDB});

  TaskModel taskModel;
  AgendaDB? agendaDB;
  String status = '';
  Color? colorfondo;
  Icon? icono;

  @override
  Widget build(BuildContext context) {
    switch (taskModel.sttTask) {
      case 'E':
        status = 'En proceso';
        colorfondo = Colors.indigoAccent;
        icono = Icon(Icons.access_alarm);
        break;
      case 'C':
        status = 'Completado';
        colorfondo = Colors.green;
        icono = Icon(Icons.task_alt);
        break;
      case 'P':
        status = 'Pendiente';
        colorfondo = Colors.orangeAccent;
        icono = Icon(Icons.lock_clock);
    }

    return Container(
      margin: EdgeInsets.only(top: 10), 
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(color: colorfondo!),
      child: Row(
        children: [
           Column(
            children: [icono!],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(taskModel.nameTask!),
              Text(taskModel.descTask!),
              Text('Expiración: ' + taskModel.dateE!.substring(0, 10)),
              Text('Estatus: ' + status)
            ],
          ),
          Expanded(child: Container()),
          Column(
            children: [
              GestureDetector(
                child: Icon(Icons.preview_rounded),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddTask(taskModel: taskModel))),
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
                                        .DELETE('tblTareas', 'idTask',
                                            taskModel.idTask!)
                                        .then((value) { 
                                      Navigator.pop(context);
                                      GlobalValues.flagTask.value =
                                          !GlobalValues.flagTask.value;
                                    });
                                  },
                                  child: Text("Si")),
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("No")),
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
