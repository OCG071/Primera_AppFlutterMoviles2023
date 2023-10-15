// ignore: file_names
import 'package:app1f/Screens/add_task.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

// ignore: must_be_immutable
class CardTaskWidget extends StatelessWidget {
  CardTaskWidget({super.key, required this.taskModel, this.agendaDB});

  TaskModel taskModel;
  AgendaDB? agendaDB;
  String status = '';

  @override
  Widget build(BuildContext context) {
    
    switch(taskModel.sttTask)
    {
      case 'E':
        status = 'En proceso';
        break;
      case 'C':
        status = 'Completado';
        break;
      case 'P':
        status= 'Pendiente';
    }
    

    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.cyan),
      child: Row(
        children: [
          Column(
            children: [
              Text(taskModel.nameTask!),
              Text(taskModel.descTask!),
              Text('Expiración: ' + taskModel.dateE!.substring(0, 10)),
              Text('Estatus: '+ status)
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
