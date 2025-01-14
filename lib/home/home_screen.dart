import 'package:flutter/material.dart';
import 'package:network_app/Utilities/custom_loader.dart';
import 'package:network_app/home/viewModel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/NetworkResponse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeViewModel viewModel;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    prefs = Provider.of<SharedPreferences>(context, listen: false);
    _fetchPosts();
  }

  _fetchPosts() async {
    var userId = await _getUserId();
    print("UserID:-$userId");
    viewModel.fetchPosts(userId);
  }

  Future<String> _getUserId() async {
    int? userId = prefs.getInt("userId");
    return "${userId ?? 0}";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, child) {
      return SafeArea(
          child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: const Text("Home",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              body: Builder(builder: (context) {
                if (viewModel.networkResponse.status == Status.LOADING) {
                  return const CustomLoader();
                } else {
                  return ListView.builder(
                      itemCount: viewModel.postList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var item = viewModel.postList[index];
                        return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(item.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12)),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Views: ${item.views}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      const SizedBox(width: 10),
                                      Text("Likes: ${item.reactions.likes}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      const SizedBox(width: 10),
                                      Text(
                                          "Dislikes: ${item.reactions.dislikes}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      const SizedBox(width: 20),
                                      const Text("Tags: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      Expanded(
                                          child: Row(
                                            children: item.tags
                                                .map((tag) => Padding(
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 4.0),
                                                child: Text(tag,
                                                    style: const TextStyle(
                                                        fontSize: 10))))
                                                .toList(),
                                          )),
                                    ],
                                  )
                                ],
                              )),
                        );

                        return null;
                      });
                }
              }),
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {}
            ),
          )
      );
    });
  }
}
