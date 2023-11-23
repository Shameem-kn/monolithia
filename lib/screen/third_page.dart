import 'package:flutter/material.dart';
import 'package:get_api/models/user_model.dart';
import 'package:get_api/services/http_services.dart';
import 'package:get_api/widgets/dropdown_widget.dart';
import 'package:get_api/widgets/text_field.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postTitleController = TextEditingController();
  final TextEditingController _postdescriptionController =
      TextEditingController();

  UserModel? selectedUser;

  @override
  // initState() {
  //   super.initState();
  //   getSelectedPostsDetails(widget.selectedPost.userId);
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _postTitleController.dispose();
    _postdescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("create new post"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * .1,
                  child: customTextField("POST TITLE", _postTitleController)),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * .3,
                  child: customTextField(
                      "POST \nDESCRIPTION", _postdescriptionController)),
              SizedBox(
                height: MediaQuery.of(context).size.height * .03,
              ),
              DropDownBuilder(
                isPostUserDownButton: true,
                onUserChanged: (user) {
                  setState(() {
                    selectedUser = user;
                  });
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .1,
              ),
              ElevatedButton(
                onPressed: () {
                  addPosts(selectedUser, _postTitleController.text,
                      _postdescriptionController.text);
                  _postTitleController.clear();
                  _postdescriptionController.clear();
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  elevation: 0,
                  fixedSize: const Size(200, 50),
                ),
                child: const Text('SAVE POST'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  addPosts(UserModel? user, String title, String description) async {
    try {
      await HttpService()
          .postData(user?.id, 101, title, description)
          .whenComplete(
              () => const SnackBar(content: Text("DATA POSTED SUCCESFULLY")));
    } catch (e) {
      SnackBar(
        content: Text(e.toString()),
      );
    }
  }
}
