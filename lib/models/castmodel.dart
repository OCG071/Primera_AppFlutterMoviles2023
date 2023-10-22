class CastModel {
  String? name;
  String? character;
  String? profile;

  CastModel({this.name, this.character, this.profile});

  factory CastModel.fromMap(Map<String, dynamic> map) {
    return CastModel(
      name: map['name'],
      character: map['character'],
      profile: map['profile_path'] ?? ''
    );
  }
}
