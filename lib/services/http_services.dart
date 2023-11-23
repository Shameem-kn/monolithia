import 'dart:convert';
import 'dart:io';
import 'package:get_api/models/comments_model.dart';
import 'package:get_api/models/post_model.dart';
import 'package:get_api/models/user_model.dart';
import 'package:http/http.dart' as http;

class HttpService {
  List<PostModel> postList = [];
  List<UserModel> userList = [];
  Future<List<PostModel>> getPosts() async {
    try {
      var response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        var data = response.body;
        postList = postModelFromJson(data);
        return postList;
      }
    } on SocketException {
      throw Exception("no internet");
    }
    throw Exception("no internet");
  }

  Future<List<UserModel?>> getUsers() async {
    try {
      final response = await http
          .get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      // final body = json.decode(response.body).toString() as List;
      if (response.statusCode == 200) {
        var data = response.body;
        userList = userModelFromJson(data);
        return userList;
      }
    } on SocketException {
      throw Exception("no internet");
    }
    throw Exception("no internet");
  }

  Future<List<CommentModel>> getComments(String id) async {
    try {
      var response = await http.get(
          Uri.parse("https://jsonplaceholder.typicode.com/posts/$id/comments"));
      if (response.statusCode == 200) {
        var data = response.body;
        return commentModelFromJson(data);
      }
    } on SocketException {
      throw Exception("no internet");
    }
    throw Exception("no internet");
  }

  Future postData(
      int? userId, int? id, String title, String description) async {
    PostModel a =
        PostModel(userId: userId!, id: 101, title: title, body: description);

    var response = await http.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        body: jsonEncode(a));
    if (response.statusCode == 201) {
      print("succesfull");
      var data = jsonDecode(response.body.toString());
      print(data);
    } else {
      var data = jsonDecode(response.body.toString());
      print(data);
    }
  }

  deletePosts(String id) async {
    try {
      var response = await http
          .delete(Uri.parse("https://jsonplaceholder.typicode.com/posts/$id"));
      if (response.statusCode == 200) {
        var data = response.body;
        print(data.toString());
        return json.decode(data);
      }
    } on SocketException {
      throw Exception("no internet");
    }
    throw Exception("no internet");
  }
}
