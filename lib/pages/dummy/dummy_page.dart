import 'package:flutter/material.dart';
import 'package:jin_widget_helper/jin_widget_helper.dart';

import '../../api_service/index.dart';
import '../../models/response/user/user_model.dart';
import '../../services/async_future_controller.dart';
import '../../widgets/state_widgets/async_future_controller_builder.dart';

class DummyPage extends StatefulWidget {
  DummyPage({Key key}) : super(key: key);
  @override
  _DummyPageState createState() => _DummyPageState();
}

class _DummyPageState extends State<DummyPage> {
  AsyncFutureController<UserResponse> userController = AsyncFutureController();
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
      onSuccess: (response) {
        if (userController.hasData) {
          response.users = [...userController.data.users, ...response.users];
        }
        if (response.users.isNotEmpty) {
          currentPage += 1;
        }
        totalPage = response.pagination.totalPage;
        return response;
      },
      reloading: reload,
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
      body: AsyncFutureControllerBuilder<UserResponse>(
        futureController: userController,
        ready: (context, UserResponse data) {
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
