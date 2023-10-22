// ignore: file_names
import 'package:app1f/Screens/add_carrer.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/carrermodel.dart'; 
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class CardCarrerWidget extends StatelessWidget {
  CardCarrerWidget({super.key, required this.carrerModel, this.agendaDB});

  CarrerModel carrerModel;
  AgendaDB? agendaDB;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(color: Colors.lightBlue),
      child: Row(
        children: [
          const Column(
            children: [Icon(Icons.account_balance_sharp)],
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: [Text(carrerModel.nameCarrer!)],
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
                            AddCarrer(carrerModel: carrerModel))),
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Mensaje del System"),
                            backgroundColor: Colors.greenAccent,
                            content: Text('Quieres borrar la carrera ???'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    agendaDB!
                                        .GETTEACHERIDCARRER(
                                            carrerModel.idCarrer!)
                                        .then((value) {
                                          if (value == 0) {
                                        agendaDB!
                                        .DELETE('tblCarrera', 'idCarrer',
                                            carrerModel.idCarrer!)
                                        .then((value) {
                                      Navigator.pop(context);
                                      GlobalValues.flagCarrer.value =
                                          !GlobalValues.flagCarrer.value;
                                    });
                                    }
                                    else{
                                      Fluttertoast.showToast(
                                      msg:
                                      ' Error!! Esta carrera tiene profesores registrados');
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
