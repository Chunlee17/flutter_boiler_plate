import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/api_service/index.dart';
import 'package:flutter_boiler_plate/services/async_subject.dart';
import 'package:jin_widget_helper/jin_widget_helper.dart';

import '../../models/response/user_model.dart';

class DummyPage extends StatefulWidget {
  DummyPage({Key key}) : super(key: key);
  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  AsyncSubject<UserResponse> userController = AsyncSubject();
  int currentPage = 1;
  int totalPage = 10;

  Future fetchData([bool reload = false]) async {
    if (reload) {
      currentPage = 1;
    }
    userController.asyncOperation(
      () => mockApiService.fetchUserList(
        count: 10,
        page: currentPage,
      ),
      onDone: (response) {
        if (userController.hasData) {
          response.users = [...userController.value.users, ...response.users];
        }
        if (response.users.isNotEmpty) {
          currentPage += 1;
        }
        totalPage = response.pagination.totalPage;
        return response;
      },
      resetStream: reload,
    );
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fetch all users with pagination")),
      body: StreamHandler<UserResponse>(
        stream: userController.stream,
        ready: (UserResponse data) {
          return RefreshIndicator(
            onRefresh: () => fetchData(true),
            child: PaginatedListView(
              itemCount: data.users.length,
              padding: EdgeInsets.zero,
              onGetMoreData: fetchData,
              hasMoreData: currentPage <= totalPage,
              itemBuilder: (context, index) {
                final user = data.users[index];
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
