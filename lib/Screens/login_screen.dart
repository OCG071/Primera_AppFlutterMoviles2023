import 'package:app1f/firebase/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// /isctorres10 github
TextEditingController txtConUser = TextEditingController();
TextEditingController txtConPass = TextEditingController();

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;

  final emailAuth = EmailAuth();

  saveSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("session", isChecked);
  }

  final txtPass = TextField(
    controller: txtConPass,
    obscureText: false,
    decoration: InputDecoration(border: OutlineInputBorder()),
  );

  final txtUser = TextField(
    controller: txtConUser,
    obscureText: false,
    decoration: InputDecoration(border: OutlineInputBorder()),
  );

  final imgLogo = Container(
      width: 200,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  'https://assets.stickpng.com/thumbs/58429658a6515b1e0ad75ad4.png'))));

  //@override
  Widget build(BuildContext context) {
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

    final btnEntrar = FloatingActionButton.extended(
        icon: const Icon(Icons.login),
        label: const Text('Entrar'),
        onPressed: () async {
          bool res = await emailAuth.validateUser(emailUser: txtConUser.text, pwdUser: txtConPass.text);
          if (res) {
            Navigator.pushNamed(context, '/dash');
          }
          else{
            Navigator.pushNamed(context, '/dash');
          }
          /*saveSession();
          Navigator.pushNamed(context, '/dash');*/
        });

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height, //fill
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://i.pinimg.com/736x/dd/c3/b5/ddc3b5875baaa18b3fab3cad4373f418.jpg'))),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
 
              Positioned(
                child: Container(
                  height: 210,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueGrey,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      txtUser,
                      const SizedBox(
                        height: 20,
                      ),
                      txtPass,
                    ],
                  ),
                ),
              ),
              imgLogo,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Colors.black,
                    fillColor: MaterialStateProperty.resolveWith(getColor),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                        saveSession();
                        print("Session Remeber me: $isChecked");
                      });
                    },
                  ),
                  const Text(
                    "Remeber Me",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Registrarse: ",
                    style: TextStyle(fontSize: 20),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: btnEntrar,
    );
  }
}
