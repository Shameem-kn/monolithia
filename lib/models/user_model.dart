import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  int id;
  String? name;

  UserModel({
    required this.id,
    required this.name,
  });
  //  UserModel.data({
  //   this.id,
  //   this.name,
  // });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
