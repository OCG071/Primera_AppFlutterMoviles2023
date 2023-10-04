import 'package:app1f/database/agendadb.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/eventmodel.dart';

class Calendar extends StatefulWidget {
   Calendar({super.key, this.eventModel});

  EventModel? eventModel;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  Map<DateTime, List<EventModel>>? selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  String? dropDownValue = 'Pendiente';

  TextEditingController txtDescEvent = TextEditingController();
  List<String> DropDownValues = ['Pendiente', 'Completado', 'En proceso'];

  AgendaDB? agendaDB;

  @override
  void initState() {
    super.initState();
    agendaDB = AgendaDB();

    if (widget.eventModel != null) {
      txtDescEvent.text =
          widget.eventModel != null ? widget.eventModel!.descEvent! : '';

      switch (widget.eventModel!.sttEvent) {
        case 'E':
          dropDownValue = 'En proceso';
          break;
        case 'C':
          dropDownValue = 'Completado';
          break;
        case 'P':
          dropDownValue = 'Pendiente';
      }
      selectedEvents = {};
    }
  }

  List<EventModel> getEventsDay(DateTime date) {
    return selectedEvents?[date] ?? [];
  }

  final space = const SizedBox(
    height: 30,
  );

  @override
  Widget build(BuildContext context) {

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

      final textDescEvent = TextField(
      maxLines: 6,
      controller: txtDescEvent,
      decoration: const InputDecoration(
          label: Text('Event Description'), border: OutlineInputBorder()),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Events'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.list))],
      ),
      body: ListView(
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
          space,
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              child: const Icon(Icons.add),
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Add Event'),
                        content: Column(
                          children: [
                            space,
                            textDescEvent,
                            space,
                            ddBStatus,
                          ],
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
