import 'package:app1f/Screens/Dashboard_screen.dart';
import 'package:app1f/Screens/add_carrer.dart';
import 'package:app1f/Screens/add_task.dart';
import 'package:app1f/Screens/add_teacher.dart';
import 'package:app1f/Screens/calenadar.dart';
import 'package:app1f/Screens/carrer_screen.dart';
import 'package:app1f/Screens/detail_location.dart';
import 'package:app1f/Screens/detail_movie_screen.dart';
import 'package:app1f/Screens/favMov_screen.dart';
import 'package:app1f/Screens/map.dart';
import 'package:app1f/Screens/popular_screen.dart';
import 'package:app1f/Screens/provider_screen.dart';
import 'package:app1f/Screens/register_screen.dart';
import 'package:app1f/Screens/task_screen.dart';
import 'package:app1f/Screens/teacher_screen.dart';
import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> getRoutes() {
  return {
    '/dash' : (BuildContext context) => DashboardScreen(),
    '/task' : (BuildContext context) => TaskScreen() ,
    '/carrer': (BuildContext context) => CarrerScreen(),
    '/teacher': (BuildContext context) => TeacherScreen(),
    '/addTask' : (BuildContext context) => AddTask(),
    '/addCarrer' : (BuildContext context) => AddCarrer(),
    '/addTeacher' : (BuildContext context) => AddTeacher(),
    '/calendar' : (BuildContext context) => Calendar(), 
    '/popular' : (BuildContext context) => POpularScreen(),
    '/detail': (BuildContext context) => DetailMovieScreen(),
    '/prov': (BuildContext context) => ProviderScreeen(),
    '/favmov': (BuildContext context) => FavMovScreen(),
    '/map': (BuildContext context) => Map_Screen(),
    '/register':(BuildContext context) => Register_Screen(),
    '/detaillocation':(BuildContext context) => DetailLocation(),

  };
}
