class CarrerModel {
  int? idCarrer;
  String? nameCarrer;

  CarrerModel({this.idCarrer, this.nameCarrer});
  factory CarrerModel.fromMap(Map<String, dynamic> map) {
    return CarrerModel(
        idCarrer: map['idCarrer'], 
        nameCarrer: map['nameCarrer']
        );
  }
}
 