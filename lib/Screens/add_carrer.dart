import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/carrermodel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddCarrer extends StatefulWidget {
  AddCarrer({super.key, this.carrerModel});

  CarrerModel? carrerModel;

  @override
  State<AddCarrer> createState() => _AddCarrerState();
}

class _AddCarrerState extends State<AddCarrer> {

  TextEditingController txtCarrerName = TextEditingController();

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    if(widget.carrerModel != null){
      txtCarrerName.text = widget.carrerModel != null  ? widget.carrerModel!.nameCarrer! : '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameCarrer = TextFormField(
      decoration: const InputDecoration(
          label: Text('Carrer Name'), border: OutlineInputBorder()),
      controller: txtCarrerName,
    );

    final space = SizedBox(
      height: 10,
    );

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: () {
        if (widget.carrerModel == null) {
          agendaDB!.INSERT('tblCarrera', {
            'nameCarrer': txtCarrerName.text, 
          }).then((value) {
            var msj =
                (value > 0) ? "La insercción fue exitosa" : "Ocurrio un error";
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        } else {
          agendaDB!.UPDATE('tblCarrera','idCarrer', {
            'idCarrer': widget.carrerModel!.idCarrer,
            'nameCarrer': txtCarrerName.text,
          }).then((value) {
            GlobalValues.flagCarrer.value = !GlobalValues.flagCarrer.value;
            var msj = (value > 0)
                ? "La actualización fue exitosa"
                : "Ocurrio un error";
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          });
        } 
      },
      child: Text('Save Carrer'),
    );

    return Scaffold(
      appBar: AppBar(
          title: widget.carrerModel == null
              ? Text('Add Carrer')
              : Text('Update Carrer')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameCarrer,
            space,
            btnGuardar
          ],
        ),
      ),
    );
  }
}