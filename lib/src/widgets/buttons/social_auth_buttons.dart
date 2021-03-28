import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/src/utils/app_utils.dart';

import '../../models/response/user/social_auth_data.dart';
import '../../services/social_auth_service.dart';
import '../../widgets/buttons/primary_button.dart';

class SocialAuthButtons extends StatelessWidget {
  final void Function(SocialAuthData) onLoginCompleted;
  final void Function(bool) onAuthStateChange;
  const SocialAuthButtons({
    Key key,
    @required this.onLoginCompleted,
    this.onAuthStateChange,
  }) : super(key: key);

  Future<void> onLoginWithFacebook(BuildContext context) async {
    await exceptionWatcher(
      () async {
        SocialAuthData data = await SocialAuthService.loginWithFacebook();
        if (data == null) return;
        onAuthStateChange?.call(true);
        //Login to server
        //data.authResponse = await userApiService.......;
        //
        onLoginCompleted?.call(data);
      },
      context: context,
      onDone: () {
        onAuthStateChange?.call(false);
      },
    );
  }

  Future<void> onLoginWithGoogle(BuildContext context) async {
    await exceptionWatcher(
      () async {
        SocialAuthData data = await SocialAuthService.loginWithGoogle();
        if (data == null) return;
        onAuthStateChange?.call(true);
        //Login to server
        //data.authResponse = await userApiService.......;
        //
        onLoginCompleted?.call(data);
      },
      context: context,
      onDone: () {
        onAuthStateChange?.call(false);
      },
    );
  }

  Future<void> onLoginWithApple(BuildContext context) async {
    await exceptionWatcher(
      () async {
        SocialAuthData data = await SocialAuthService.loginWithApple();
        if (data == null) return;
        onAuthStateChange?.call(true);
        //Login to server
        //data.authResponse = await userApiService.......;
        //
        onLoginCompleted?.call(data);
      },
      context: context,
      onDone: () {
        onAuthStateChange?.call(false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          PrimaryButton(
            onPressed: () => onLoginWithFacebook(context),
            child: Text("Sign In with Facebook"),
          ),
          PrimaryButton(
            onPressed: () => onLoginWithGoogle(context),
            child: Text("Sign In with Google"),
          ),
          PrimaryButton(
            onPressed: () => onLoginWithApple(context),
            child: Text("Sign In with Apple"),
          ),
        ],
      ),
    );
  }
}
