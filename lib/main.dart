import 'dart:async';

import 'package:app1f/Screens/Dashboard_screen.dart';
import 'package:app1f/Screens/login_screen.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/routes.dart';
import 'package:app1f/styles/styles_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  Future checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("theme") != null && prefs.getBool("theme") != false) {
      GlobalValues.flagTheme.value = true;
    } else {
      GlobalValues.flagTheme.value = false;
    }
  }

  Future<bool?> checkSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("session") != null && prefs.getBool("session") != false) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkTheme();
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return MaterialApp(
              home: FutureBuilder<bool?>(
                future: checkSession(),
                builder: (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                  if (snapshot.data == false) {
                    return LoginScreen();
                  } else {
                    return DashboardScreen();
                  }
                },
              ),
              routes: getRoutes(),
              theme: GlobalValues.flagTheme.value
                  ? StylesApp.darkTheme(context)
                  : StylesApp.lightTheme(context));
        });
  }
}
