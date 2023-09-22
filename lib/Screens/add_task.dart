import 'package:app1f/database/agendadb.dart';
import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String dropDownValue = "Pendiente";
  TextEditingController txtController = TextEditingController();
  TextEditingController txtContDsc = TextEditingController();
  List<String> DropDownValues = ['Pendiente', 'Completado', 'En proceso'];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
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
        agendaDB!.INSERT('tblTareas', {
          'nameTask': txtController.text,
          'descTask': txtContDsc.text,
          'sttTask': dropDownValue.substring(1, 1)
        }).then((value) {
          var msj =
              (value > 0) ? "La insercción fue exitosa" : "Ocurrio un error";
          var snackbar = SnackBar(content: Text(msj));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          Navigator.pop(context);
        });
      },
      child: Text('Save Tak'),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
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
