import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/teachermodel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddTeacher extends StatefulWidget {
  AddTeacher({super.key, this.teacherModel});

  TeacherModel? teacherModel;

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  String? dropDownValue = 'Ingeniería Industrial';
  var idC;
  TextEditingController txtConName = TextEditingController();
  TextEditingController txtConEmail = TextEditingController();
  List<DropdownMenuItem<String>> DropDownValues = [];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();

    agendaDB!.GETALLCARRERNAME().then((list) {
      list.map((map) {
        print(map.toString());
        return getDropDownWidget(map);
      }).forEach((dropDownItem) {
        DropDownValues.add(dropDownItem);
      });
      setState(() {});
    });

    if (widget.teacherModel != null) {
      txtConName.text =
          widget.teacherModel != null ? widget.teacherModel!.nameTeacher! : '';
      txtConEmail.text =
          widget.teacherModel != null ? widget.teacherModel!.email! : '';
      agendaDB!.GETCARRERNAME(widget.teacherModel!.idCarrer!).then((value) {
        value.map((e) {
          dropDownValue = e['nameCarrer'].toString();
        }).forEach((element) {
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final txtNameTeacher = TextFormField(
      decoration: const InputDecoration(
          label: Text('Teacher Name'), border: OutlineInputBorder()),
      controller: txtConName,
    );

    final txtEmail = TextFormField(
      controller: txtConEmail,
      decoration: const InputDecoration(
          label: Text('Teacher Email'), border: OutlineInputBorder()),
    );

    final space = SizedBox(
      height: 10,
    );

    final DropdownButtonFormField ddBStatus = DropdownButtonFormField(
        decoration: InputDecoration(
          labelText: 'Carrera '
        ),
        value: dropDownValue,
        items: DropDownValues,
        onChanged: (value) {
          dropDownValue = value;
          setState(() {});
        });

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: () {
        if (widget.teacherModel == null) {
          agendaDB!.GETCARRERID(dropDownValue!).then((list) {
            list.map((e) {
              idC = int.parse(e['idCarrer'].toString());
            }).forEach((element) {
              setState(() {});
            });
          }).whenComplete(() => agendaDB!.INSERT('tblProfesor', {
                'nameTeacher': txtConName.text,
                'email': txtConEmail.text,
                'idCarrer': idC
              }).then((value) {
                var msj = (value > 0)
                    ? "La insercción fue exitosa"
                    : "Ocurrio un error";
                var snackbar = SnackBar(content: Text(msj));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                Navigator.pop(context);
              }));
        } else {
            agendaDB!.GETCARRERID(dropDownValue!).then((list) {
            list.map((e) {
              idC = int.parse(e['idCarrer'].toString());
            }).forEach((element) {
              setState(() {});
            });
          }).whenComplete(() =>
          agendaDB!.UPDATE('tblProfesor', 'idTeacher', {
            'idTeacher': widget.teacherModel!.idTeacher,
            'nameTeacher': txtConName.text,
            'email': txtConEmail.text,
            'idCarrer': idC
          }).then((value) {
            GlobalValues.flagTeacher.value = !GlobalValues.flagTeacher.value;
            var msj = (value > 0)
                ? "La actualización fue exitosa"
                : "Ocurrio un error";
            var snackbar = SnackBar(content: Text(msj));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
            Navigator.pop(context);
          }));
        }
      },
      child: Text('Save Teacher'),
    );

    return Scaffold(
      appBar: AppBar(
          title: widget.teacherModel == null
              ? Text('Add Teacher')
              : Text('Update Teacher')),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            txtNameTeacher,
            space,
            txtEmail,
            space,
            ddBStatus,
            space,
            btnGuardar
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> getDropDownWidget(Map<String, dynamic> map) {
    return DropdownMenuItem<String>(
      value: map['nameCarrer'],
      child: Text(map['nameCarrer']),
    );
  }
}
