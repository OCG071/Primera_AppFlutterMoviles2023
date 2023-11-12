import 'dart:async';

import 'package:app1f/Screens/Dashboard_screen.dart';
import 'package:app1f/Screens/login_screen.dart';
import 'package:app1f/global_values.dart';
import 'package:app1f/provider/test_provider.dart';
import 'package:app1f/routes.dart'; 
import 'package:app1f/styles/styles_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainApp());
}
 
// ignore: must_be_immutable
class MainApp extends StatelessWidget {
  bool? ischecked = false;
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
      ischecked = true;
      return true;
    } else {
      ischecked = false;
      return false;
    }
  }
 
  saveSession() async { 
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("session", isChecked);
  }

  @override
  Widget build(BuildContext context) {
    checkSession();
    checkTheme();
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return ChangeNotifierProvider(
            create: (context) => TestProvider(),
            child: MaterialApp(
                home: FutureBuilder<bool?>(
                  future: checkSession(),
                  builder:
                      (BuildContext context, AsyncSnapshot<bool?> snapshot) {
                    if (isChecked == false) {
                      return LoginScreen();
                    } else {
                      print(snapshot.data);
                      return DashboardScreen();
                    }
                  },
                ),
                routes: getRoutes(),
                theme: GlobalValues.flagTheme.value
                    ? StylesApp.darkTheme(context)
                    : StylesApp.lightTheme(context)),
          );
        });
  }
}
