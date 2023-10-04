import 'package:app1f/Screens/login_screen.dart';
import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  AddTask({super.key, this.taskModel});

  TaskModel? taskModel;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String? dropDownValue = 'Pendiente';
  TextEditingController txtController = TextEditingController();
  TextEditingController txtContDsc = TextEditingController();
  List<String> DropDownValues = ['Pendiente', 'Completado', 'En proceso'];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();

    if (widget.taskModel != null) {
      txtController.text =
          widget.taskModel != null ? widget.taskModel!.nameTask! : '';
      txtContDsc.text =
          widget.taskModel != null ? widget.taskModel!.descTask! : '';
      switch (widget.taskModel!.sttTask) {
        case 'E':
          dropDownValue = 'En proceso';
          break;
        case 'C':
          dropDownValue = 'Completado';
          break;
        case 'P':
          dropDownValue = 'Pendiente';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameTask = TextFormField(
      decoration: const InputDecoration(
          label: Text('Task Name'), border: OutlineInputBorder()),
      controller: txtController,
    );

    final txtDescTask = TextField(
      maxLines: 6,
      controller: txtContDsc,
      decoration: const InputDecoration(
          label: Text('Task Description'), border: OutlineInputBorder()),
    );

    final space = SizedBox(
      height: 10,
    );

    final DropdownButton ddBStatus = DropdownButton(
        value: dropDownValue,
        items: DropDownValues.map((status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            )).toList(),
        onChanged: (value) {
          dropDownValue = value;
          setState(() {});
        });

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: () {
        if (widget.taskModel == null) {
          agendaDB!.INSERT('tblTareas', {
            'nameTask': txtController.text,
            'descTask': txtContDsc.text,
            'sttTask': dropDownValue!.substring(0, 1)
          }).then((value) {
            var msj =
                (value > 0) ? "La insercción fue exitosa" : "Ocurrio un error";
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        } else {
          agendaDB!.UPDATE('tblTareas', {
            'idTask': widget.taskModel!.idTask,
            'nameTask': txtController.text,
            'descTask': txtContDsc.text,
            'sttTask': dropDownValue!.substring(0, 1)
          }).then((value) {
            GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
            var msj = (value > 0)
                ? "La actualización fue exitosa"
                : "Ocurrio un error";
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        }
      },
      child: Text('Save Task'),
    );

    return Scaffold(
      appBar: AppBar(
          title: widget.taskModel == null
              ? Text('Add Task')
              : Text('Update Task')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameTask,
            space,
            txtDescTask,
            space,
            ddBStatus,
            space,
            btnGuardar
          ],
        ),
      ),
    );
  }
}
