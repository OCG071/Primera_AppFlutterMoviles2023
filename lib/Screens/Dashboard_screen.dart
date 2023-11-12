import 'dart:async';

import 'package:app1f/Screens/login_screen.dart';
import 'package:app1f/global_values.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isChecked = true;

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
} 

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  initState() {
    checkSession().whenComplete(() async {
      print(" checked : $isChecked"); 
      Timer(Duration(seconds: 2),
          () => isChecked == true ? isChecked = true : isChecked = false);
    });
    super.initState();
  }

  saveSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("session", false);
  }

  Future checkSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var obtainSession = prefs.getBool("session");
    setState(() {
      if (obtainSession != true) {
        isChecked = false;
      } else {
        isChecked = true;
      }
    });
  }

  saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("theme", GlobalValues.flagTheme.value);
  }

  Future checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("theme") != null && prefs.getBool("theme") != false) {
      GlobalValues.flagTheme.value = true;
    } else {
      GlobalValues.flagTheme.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenidos :)'),
      ),
      drawer: createDrawer(context),
    );
  }

  Widget createDrawer(context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.yellow;
    }
 
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3607/3607444.png'),
              ),
              accountName: Text('Omar A Carmona González'),
              accountEmail: Text('omarcg071@gmail.com')),
          ListTile(
            leading: Image.network(
                'https://cdn1.iconfinder.com/data/icons/fruits-5/128/lemon-256.png'),
            trailing: Icon(Icons.chevron_right),
            title: Text('FruitApp'),
            subtitle: Text('Carrusel'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.task_alt_outlined),
            trailing: Icon(Icons.chevron_right),
            title: Text('Tasks'),
            onTap: () => Navigator.pushNamed(context, '/task'),
          ),
          ListTile(
            leading: const Icon(Icons.assignment_ind_rounded),
            trailing: Icon(Icons.chevron_right),
            title: Text('Teachers'),
            onTap: () => Navigator.pushNamed(context, '/teacher'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            trailing: Icon(Icons.chevron_right),
            title: Text('Carrers'),
            onTap: () => Navigator.pushNamed(context, '/carrer'),
          ),
          ListTile(
            leading: const Icon(Icons.abc),
            trailing: Icon(Icons.chevron_right),
            title: Text('Test Provider'),
            onTap: () => Navigator.pushNamed(context, '/prov'),
          ),
          Visibility(
            child: ListTile(
              leading: const Icon(Icons.exit_to_app),
              trailing: Icon(Icons.chevron_right),
              title: Text("Log Out"),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) {
                saveSession();
                return LoginScreen();
              })),
            ),
            visible: isChecked,
          ),
         ListTile(
            leading: const Icon(Icons.event),
            trailing: Icon(Icons.chevron_right),
            title: Text('Events'),
            onTap: () => Navigator.pushNamed(context, '/calendar'),
          ),
          ListTile(
            leading: const Icon(Icons.play_arrow_outlined),
            trailing: Icon(Icons.chevron_right),
            title: Text('Movies'),
            onTap: () => Navigator.pushNamed(context, '/popular'),
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () => Navigator.pushNamed(context, '/map'),
          ),

          DayNightSwitcher(
            isDarkModeEnabled: GlobalValues.flagTheme.value,
            onStateChanged: (isDarkModeEnabled) {
              GlobalValues.flagTheme.value = isDarkModeEnabled;
              saveTheme();
            },
          ),
        ],
      ),
    );
  }
}
