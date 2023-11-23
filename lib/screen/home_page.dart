import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get_api/models/post_model.dart';
import 'package:get_api/models/user_model.dart';
import 'package:get_api/screen/second_page.dart';
import 'package:get_api/screen/third_page.dart';
import 'package:get_api/services/http_services.dart';
import 'package:get_api/widgets/dismissable_background.dart';
import 'package:get_api/widgets/dropdown_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? selectedUser;
  HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: ((context) => const CreatePostPage())));
        }),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("HEADER"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            DropDownBuilder(
              isPostUserDownButton: false,
              onUserChanged: (user) {
                setState(() {
                  selectedUser = user;
                });
              },
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * .67,
              child: FutureBuilder<List<PostModel>>(
                  future: httpService.getPosts(),
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
                      List<PostModel> filteredPosts = selectedUser == null
                          ? snapshot.data!
                          : snapshot.data!
                              .where((post) => post.userId == selectedUser!.id)
                              .toList();

                      return ListView.builder(
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              onDismissed: (direction) {
                                deletePosts(filteredPosts, index);
                              },
                              key: ValueKey<int>(index),
                              background: slideBackground(),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Secondpage(
                                            selectedPost: filteredPosts[index],
                                          )));
                                },
                                child: Card(
                                  child: ListTile(
                                    leading: const CircleAvatar(
                                        backgroundColor: Colors.blue),
                                    title: Text(
                                      "Title ${index + 1}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(filteredPosts[index].title),
                                        Text(
                                            "user: ${filteredPosts[index].userId.toString()}"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                  }),
            )
          ],
        ),
      )),
    );
  }

  deletePosts(posts, index) async {
    print(posts[index].id.toString());
    var response = await httpService.deletePosts(posts[index].id.toString());
    // print(response.body.toString());

    setState(() {
      posts.removeAt(index);
    });
  }
}
