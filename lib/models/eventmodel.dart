class EventModel {
  int? idEvent;
  String? descEvent;
  String? dateEvent;
  String? sttEvent;

  EventModel({this.idEvent, this.descEvent, this.dateEvent, this.sttEvent});
  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      idEvent: map['idEvent'],
      descEvent: map['descEvent'],
      dateEvent: map['dateEvent'],
      sttEvent: map['sttEvent']
    );
  }
}