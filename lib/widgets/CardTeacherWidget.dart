// ignore: file_names
import 'package:app1f/Screens/add_teacher.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/teachermodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class CardTeacherWidget extends StatelessWidget {
  CardTeacherWidget({super.key, required this.teacherModel, this.agendaDB});

  TeacherModel teacherModel;
  AgendaDB? agendaDB;
  int? reg; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.orangeAccent),
      child: Row(
        children: [
          const Column(
            children: [Icon(Icons.account_circle)],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [
              Text(teacherModel.nameTeacher!,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(teacherModel.email!),
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
                        builder: (context) =>
                            AddTeacher(teacherModel: teacherModel))),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Mensaje del System"),
                            backgroundColor: Colors.amberAccent,
                            content: Text('Quieres borrar el profesor ???'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    agendaDB! 
                                        .GETTASKIDTEACHER(
                                            teacherModel.idTeacher!)
                                        .then((value) {
                                      if (value == 0) {
                                        agendaDB!
                                            .DELETE('tblProfesor', 'idTeacher',
                                                teacherModel.idTeacher!)
                                            .then((value) {
                                          Navigator.pop(context);
                                          GlobalValues.flagTeacher.value =
                                              !GlobalValues.flagTeacher.value;
                                        });
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                                ' Error!! Este profesor tiene tareas registradas');
                                        Navigator.pop(context);
                                      }
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
