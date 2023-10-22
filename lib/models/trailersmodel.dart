class TrailerModel {
  String? type;
  String? key;

  TrailerModel({this.type,this.key});

  factory TrailerModel.fromMap(Map<String, dynamic> map) {
    return TrailerModel(type: map['type'], key: map['key']);
  }
}
