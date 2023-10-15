class TeacherModel {
  int? idTeacher;
  String? nameTeacher;
  String? email;
  int? idCarrer;

  TeacherModel({this.idTeacher, this.nameTeacher, this.email, this.idCarrer});
  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
      idTeacher: map['idTeacher'],
      nameTeacher: map['nameTeacher'],
      email: map['email'],
      idCarrer: map['idCarrer']
    );
  }
} 
