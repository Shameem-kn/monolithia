import 'dart:convert';

List<CommentModel> commentModelFromJson(String str) => List<CommentModel>.from(
    json.decode(str).map((x) => CommentModel.fromJson(x)));

class CommentModel {
  int postId;
  int id;

  String email;
  String body;

  CommentModel({
    required this.postId,
    required this.id,
    required this.email,
    required this.body,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        postId: json["postId"],
        id: json["id"],
        email: json["email"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "id": id,
        "email": email,
        "body": body,
      };
}
