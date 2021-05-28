import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/src/api/index.dart';
import 'package:provider/provider.dart';
import 'package:sura_flutter/sura_flutter.dart';

import '../models/response/user/user_model.dart';

class UserProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  FutureManager<UserModel> userController = FutureManager<UserModel>();

  UserModel? get userData => userController.data;

  static UserProvider getProvider(BuildContext context, [bool listen = false]) => Provider.of<UserProvider>(
        context,
        listen: listen,
      );

  void setLoginStatus(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  Future<void> getUserInfo() async {
    await userController.asyncOperation(
      () => userRepository.fetchUserInfo(),
      reloading: true,
    );
  }
}
