import 'package:flutter/material.dart';
import 'package:jin_widget_helper/jin_widget_helper.dart';

import './../dummy_page/dummy_page.dart';
import '../../api_service/index.dart';
import '../../constant/resource_path.dart';
import '../../model/response/user_model.dart';
import '../../services/base_stream.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BaseStream<UserResponse> userController = BaseStream();

  Future<void> fetchUsers([bool loading = false]) async {
    await userController.asyncOperation(() async {
      return mockApiService.fetchUserList();
    }, loadingOnRefresh: loading);
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  void dispose() {
    userController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Boilerplate"),
        actions: <Widget>[
          IconButton(
            icon: Image.asset(ImageAssets.APP_ICON),
            onPressed: () => PageNavigator.push(context, DummyPage()),
          )
        ],
      ),
      body: StreamHandler<UserResponse>(
        stream: userController.stream,
        ready: (UserResponse response) {
          return RefreshIndicator(
            onRefresh: () => fetchUsers(true),
            child: ListView.builder(
              itemCount: response.users.length,
              itemBuilder: (BuildContext context, int index) {
                final user = response.users[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  onTap: () {},
                  title: Text("${user.firstName} ${user.lastName}"),
                  subtitle: Text(user.email),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
