import 'package:app1f/firebase/email_auth.dart';
import 'package:flutter/material.dart';

class Register_Screen extends StatefulWidget {
  const Register_Screen({super.key});

  @override
  State<Register_Screen> createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  final TextEditingController conNameUser = TextEditingController();
  final TextEditingController conEmailUser = TextEditingController();
  final TextEditingController conPwdUser = TextEditingController();

  final emailAuth = EmailAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register a User'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: conNameUser,
          ),
          TextFormField(
            controller: conEmailUser,
          ),
          TextFormField(
            controller: conPwdUser,
          ),
          ElevatedButton(
              onPressed: () {
                var email = conEmailUser.text;
                var pwd = conPwdUser.text;
                emailAuth.createUser(emailUser: email, pwdUser: pwd);
              },
              child: const Text('Save'))
        ],
      ),
    );
  }
}
