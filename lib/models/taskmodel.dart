class TaskModel {
  int? idTask;
  String? nameTask;
  String? descTask;
  String? sttTask;
  String? dateE;
  String? dateR;
  int? idTeacher;

  TaskModel(
      {this.idTask,
      this.descTask,
      this.nameTask,
      this.sttTask,
      this.dateE,
      this.dateR,
      this.idTeacher});
      
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
        idTask: map['idTask'],
        descTask: map['descTask'],
        nameTask: map['nameTask'],
        sttTask: map['sttTask'],
        dateE: map['dateE'],
        dateR: map['dateR'],
        idTeacher: map['idTeacher']);
  }
}
