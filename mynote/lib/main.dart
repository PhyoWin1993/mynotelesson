import 'package:flutter/material.dart';

import 'package:mynote/db/db_helper.dart';
import 'package:mynote/ui/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();

  runApp(const MaterialApp(
    home: HomePage(),
    // home: AddTaskPage(),
  ));
}
