import 'package:app1f/Screens/Dashboard_screen.dart';
import 'package:app1f/Screens/add_task.dart';
import 'package:app1f/Screens/task_screen.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/dash' : (BuildContext context) => DashboardScreen(),
    '/task' : (BuildContext context) => TaskScreen() ,
    '/add' : (BuildContext context) => AddTask()
  };
}
