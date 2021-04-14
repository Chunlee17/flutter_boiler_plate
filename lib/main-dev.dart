import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './src/utils/hive_db_adapter.dart';
import './src/utils/service_locator.dart';
import 'app.dart';
import 'flavors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  registerHiveAdapter();
  registerLocator();
  setupDevEnvConfig();
  return runApp(MyApp());
}
