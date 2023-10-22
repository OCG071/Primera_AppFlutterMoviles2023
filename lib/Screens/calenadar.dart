import 'package:app1f/database/agendadb.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<dynamic>> events = {};
  String estatus='';
  var e = [];
  CalendarFormat format = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  late final ValueNotifier<List<dynamic>> selectedEvents;

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getElementsDay(selectedDay!));
    loadevents();
  }

  @override
  void dispose() {
    selectedEvents.dispose();
    super.dispose();
  }

  void ondayselected(DateTime selectedday, DateTime focusedday) {
    if (!isSameDay(selectedDay, selectedday)) {
      setState(() {
        selectedDay = selectedday;
        focusedDay = focusedday;
      });
      selectedEvents.value = getElementsDay(selectedday);
    }
  }

  void loadevents() async {
    final eventss = await agendaDB!.GETTASKS();
    if (eventss != null) {
      Map<DateTime, List> formatedEvents = {};
      eventss.forEach((event) {
        switch (event['sttTask']) {
            case 'E':
              estatus = 'En proceso';
              break;
            case 'C':
              estatus = 'Completado';
              break;
            case 'P':
              estatus = 'Pendiente';
          }

        final date = DateTime.parse(event['dateE']
                .toString()
                .replaceRange(10, null, ' 00:00:00.000Z'))
            .toUtc();
        formatedEvents.update(date, (value) {

          value.add('Tarea: ' + event['nameTask'] + '\nEstatus: '+ estatus+'\n Descripción: '+event['descTask']);
          return value;
        }, ifAbsent: () => ['Tarea: ' + event['nameTask'] + '\nEstatus: '+ estatus+'\n Descripción: '+event['descTask']]);
      });
      setState(() {
        events = formatedEvents;
      });
    }
  }

  List<dynamic> getElementsDay(DateTime day) {
    print(events);
    return events[day] ?? [];
  }

  final space = const SizedBox(
    height: 30,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Tasks'),
      ),
      body: Column(
        children: [
          space,
          TableCalendar(
            eventLoader: getElementsDay,
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2020, 01, 01),
            lastDay: DateTime.utc(2025, 12, 31),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: ondayselected,
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            calendarStyle: const CalendarStyle(
              selectedTextStyle: TextStyle(color: Colors.white),
              todayDecoration: ShapeDecoration(
                  color: Colors.blueAccent,
                  shape: CircleBorder(eccentricity: 0.5)),
              selectedDecoration: BoxDecoration(
                  color: Colors.orangeAccent, shape: BoxShape.circle),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: const TextStyle(
                color: Colors.white,
              ),
              leftChevronVisible: true,
              rightChevronVisible: true,
              headerPadding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            ),
          ),
          SizedBox(height: 8.0),
          ValueListenableBuilder(
              valueListenable: selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Card(
                          child: Text('${value[index]}'),
                        ),
                      );
                    });
              })
        ],
      ),
    );
  }
}
