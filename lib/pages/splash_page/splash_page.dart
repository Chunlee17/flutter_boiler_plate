import 'package:flutter/material.dart';
import 'package:flutter_boiler_plate/pages/login_page/login_page.dart';
import 'package:jin_widget_helper/jin_widget_helper.dart';
import '../../services/local_strorage_service.dart';
import '../../constant/colors.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  void onSplashing() async {
    await LocalStorage.initialize();
    await Future.delayed(const Duration(seconds: 1));
    PageNavigator.pushReplacement(context, LoginPage());
  }

  @override
  void initState() {
    onSplashing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text(
          "Loading...",
          style: TextStyle(fontSize: 32, color: Colors.white),
        ),
      ),
    );
  }
}
