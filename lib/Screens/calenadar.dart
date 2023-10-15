import 'package:app1f/database/agendadb.dart';
import 'package:app1f/models/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class Calendar extends StatefulWidget {
  Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<TaskModel>>? events;
  CalendarFormat format = CalendarFormat.month;
  DateTime? selectedDay;
  DateTime focusedDay = DateTime.now();
  late final ValueNotifier<List<TaskModel>> selectedEvents;

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();
    selectedDay = focusedDay;
    selectedEvents = ValueNotifier(getEventsDay(selectedDay!));
    selectedEvents.value = getEventsDay(selectedDay!);
  }

  final space = const SizedBox(
    height: 30,
  );

  List<TaskModel> getEventsDay(DateTime day) {
    print(day.toString());
    List<TaskModel> e = [];
    agendaDB!.GETTASKDATE(day.toIso8601String()).then((value) {
      e = value;
    });
    return e;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Tasks'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.task))],
      ),
      body: Column(
        children: [
          space,
          TableCalendar(
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
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
                selectedEvents.value = getEventsDay(selectedDay!);
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            eventLoader: getEventsDay,
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
