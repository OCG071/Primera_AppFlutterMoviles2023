class TaskModel {
  int? idTask;
  String? nameTask;
  String? descTask;
  bool? sttTask;

  TaskModel({this.idTask, this.descTask, this.nameTask, this.sttTask});
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      idTask: map['idTask'],
      descTask: map['descTask'],
      nameTask: map['nameTask'],
      sttTask: map['sttTask']
    );
  }
}
