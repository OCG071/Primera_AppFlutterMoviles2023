import 'package:app1f/database/agendadb.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

// ignore: must_be_immutable
class AddTask extends StatefulWidget {
  AddTask({super.key, this.taskModel});

  TaskModel? taskModel;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launch_background');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> mostrarnotificacion(String tarea, DateTime fecha) async {
    print('entrar not');
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'channel_ame');
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    tz.initializeTimeZones();
    final String timeZoneName = tz.getLocation('America/Chihuahua').toString();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await flutterLocalNotificationsPlugin.show(
      idT,
      tarea,
      'Recordatorio de realización',
      notificationDetails      
    );
  }

  String? auxFechaR;
  String? auxFechaE; 
  var idT;

  String? dropDownValue = 'Pendiente';
  String? dropDownValueP = 'Rubén Torres Frías';
  TextEditingController txtController = TextEditingController();
  TextEditingController txtContDsc = TextEditingController();
  List<String> DropDownValues = ['Pendiente', 'Completado', 'En proceso'];

  List<DropdownMenuItem<String>> DropDownValuesP = [];
  DateTime dateE = DateTime.now();
  DateTime dateR = DateTime.now();

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB(); 
    agendaDB!.GETALLTEACHERNAME().then((list) {
      list.map((map) {
        print(map.toString());
        return getDropDownWidget(map);
      }).forEach((dropDownItem) {
        DropDownValuesP.add(dropDownItem);
      });
      setState(() {});
    });

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
      agendaDB!.GETTEACHERNAME(widget.taskModel!.idTeacher!).then((value) {
        value.map((e) {
          dropDownValueP = e['nameTeacher'].toString();
        }).forEach((element) {
          setState(() {});
        });
      });
      dateE = DateTime.parse(widget.taskModel!.dateE!);
      auxFechaE = dateE.toIso8601String();
      dateR = DateTime.parse(widget.taskModel!.dateR!);
      auxFechaR = dateR.toIso8601String();
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

    final DropdownButtonFormField ddBStatus = DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Estado de la tarea '),
        value: dropDownValue,
        items: DropDownValues.map((status) => DropdownMenuItem(
              value: status,
              child: Text(status),
            )).toList(),
        onChanged: (value) {
          dropDownValue = value;
          setState(() {});
        });

    final DropdownButtonFormField ddBProfesor = DropdownButtonFormField(
        decoration: InputDecoration(labelText: 'Profesor '),
        value: dropDownValueP,
        items: DropDownValuesP,
        onChanged: (value) {
          dropDownValueP = value;
          setState(() {});
        });

    final SizedBox btnDateExpiracion = SizedBox(
      width: 300,
      child: ElevatedButton(
        child: Text('Expiration Date'),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: dateE,
              firstDate: DateTime.utc(2020, 01, 01),
              lastDate: DateTime.utc(2025, 12, 31));
          if (newDate == null) return;
          setState(() => dateE = newDate);
          auxFechaE = dateE.toIso8601String();
        },
      ),
    );

    final SizedBox btnDateReminder = SizedBox(
      width: 300,
      child: ElevatedButton(
        child: Text('Reminder Date'),
        onPressed: () async {
          DateTime? newDate = await showDatePicker(
              context: context,
              initialDate: dateR,
              firstDate: DateTime.utc(2020, 01, 01),
              lastDate: DateTime.utc(2025, 12, 31));
          if (newDate == null) return;
          setState(() => dateR = newDate);
          auxFechaR = dateR.toIso8601String();
        },
      ),
    );

    final ElevatedButton btnGuardar = ElevatedButton(
      onPressed: () async {
        WidgetsFlutterBinding.ensureInitialized();
        await initNotifications();
        if (widget.taskModel == null) {
          agendaDB!.GETTEACHERID(dropDownValueP!).then((list) {
            list.map((e) {
              idT = int.parse(e['idTeacher'].toString());
            }).forEach((element) {
              setState(() {});
            }); 
          }).whenComplete(() {
            mostrarnotificacion(txtController.text,dateR);
            agendaDB!.INSERT('tblTareas', {
              'nameTask': txtController.text,
              'descTask': txtContDsc.text,
              'sttTask': dropDownValue!.substring(0, 1),
              'dateE': auxFechaE,
              'dateR': auxFechaR,
              'idTeacher': idT
            }).then((value) {
              var msj = (value > 0)
                  ? "La insercción fue exitosa"
                  : "Ocurrio un error";
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
              setState(() {});
            });
          });
        } else {
          agendaDB!.GETTEACHERID(dropDownValueP!).then((list) {
            list.map((e) {
              idT = int.parse(e['idTeacher'].toString());
            }).forEach((element) {
              setState(() {});
            }); 
          }).whenComplete(() {
            agendaDB!.UPDATE('tblTareas', 'idTask', { 
              'idTask': widget.taskModel!.idTask,
              'nameTask': txtController.text,
              'descTask': txtContDsc.text,
              'sttTask': dropDownValue!.substring(0, 1),
              'dateE': auxFechaE,
              'dateR': auxFechaR,
              'idTeacher': idT
            }).then((value) {
              GlobalValues.flagTask.value = !GlobalValues.flagTask.value;
              var msj = (value > 0)
                  ? "La actualización fue exitosa"
                  : "Ocurrio un error";
              var snackbar = SnackBar(content: Text(msj));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pop(context);
            });
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
            btnDateExpiracion,
            space,
            btnDateReminder,
            space,
            ddBProfesor,
            space,
            btnGuardar
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  DropdownMenuItem<String> getDropDownWidget(Map<String, dynamic> map) {
    return DropdownMenuItem<String>(
      value: map['nameTeacher'],
      child: Text(map['nameTeacher']),
    );
  }
}
