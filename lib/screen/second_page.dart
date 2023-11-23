import 'package:flutter/material.dart';
import 'package:get_api/models/comments_model.dart';
import 'package:get_api/models/post_model.dart';
import 'package:get_api/models/user_model.dart';
import 'package:get_api/services/http_services.dart';

class Secondpage extends StatefulWidget {
  final PostModel selectedPost;

  const Secondpage({
    super.key,
    required this.selectedPost,
  });

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  HttpService httpService = HttpService();
  late UserModel? user;
  @override
  initState() {
    super.initState();
    getSelectedUserDetails(widget.selectedPost.userId);
  }

  Future<void> getSelectedUserDetails(int id) async {
    var userDetails = await httpService.getUsers().then((value) {
      return value.firstWhere((user) => user?.id == id);
    });

    setState(() {
      user = userDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Title"),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<List<CommentModel>>(
                  future: httpService
                      .getComments(widget.selectedPost.id.toString()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.error != null) {
                      return const Center(
                        child: Text('An error occured'),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "posted by ${user?.name} (user : ${user?.id})",
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(widget.selectedPost.body),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text("Comments",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * .5,
                              child: ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: ListTile(
                                          title:
                                              Text(snapshot.data![index].body),
                                          subtitle:
                                              Text(snapshot.data![index].email),
                                        ));
                                  }),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ]));
  }
}
