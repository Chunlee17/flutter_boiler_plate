import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/api_service/mock_api_provider.dart';
import 'package:flutter_boiler_plate/main.dart';
import 'package:flutter_boiler_plate/model/response/user_model.dart';
import 'package:flutter_boiler_plate/pages/root_page/root_page.dart';
import 'package:flutter_boiler_plate/services/local_strorage_service.dart';
import 'package:flutter_boiler_plate/widgets/ui_helper.dart';
import 'package:jin_widget_helper/jin_widget_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  MockApiProvider mockApiProvider = getIt<MockApiProvider>();
  final isLoading = false.obs<bool>();
  TextEditingController emailTC;
  TextEditingController passwordTC;

  void onLogin() async {
    if (formKey.currentState.validate()) {
      handleLoading();
      try {
        String token = await mockApiProvider.loginUser(email: emailTC.text, password: passwordTC.text);
        LocalStorage.save(key: LocalStorage.TOKEN_KEY, value: token);
        PageNavigator.pushReplacement(context, RootPage());
      } catch (e) {
        UIHelper.showGeneralMessageDialog(context, e.toString());
      } finally {
        handleLoading();
      }
    }
  }

  void handleLoading() {
    isLoading.value = !isLoading.value;
  }

  @override
  void initState() {
    emailTC = TextEditingController();
    passwordTC = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailTC.dispose();
    isLoading.dispose();
    passwordTC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 200, horizontal: 12),
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) => JinFormValidator.validateEmail(value),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            SpaceY(16),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => JinFormValidator.validatePassword(value),
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
              ),
            ),
            ActionButton(
              onPressed: onLogin,
              isLoading: isLoading,
              child: Text("LOGIN"),
            ),
          ],
        ),
      ),
    );
  }
}
