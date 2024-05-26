// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'package:demo/constant/routes.dart';
import 'package:demo/services/auth/auth_exception.dart';
import 'package:demo/services/auth/auth_service.dart';
//import 'package:demo/utilites/show_error_dialog.dart';
import 'package:flutter/material.dart';

import '../utilites/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registor'),
        backgroundColor: const Color.fromARGB(178, 34, 135, 229),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your Email'),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration(hintText: 'Enter your password'),
        ),
        TextButton(
          //register button
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              await AuthService.firebase()
                  .createUser(email: email, password: password);
              await AuthService.firebase().sendEmailVerification();
              Navigator.of(context).pushNamed(verifyEmailRoute);
            } on WeekPasswordAuthException {
              await showErrorDialog(context, 'Week password!');
            } on EmailAlreadyInUseAuthException {
              await showErrorDialog(context, 'Email already in use');
            } on InvalidEmailAuthException {
              await showErrorDialog(context, 'Invalid email');
            } on GenericAuthException {
              await showErrorDialog(context, 'Failed to register');
            }
          },
          child: const Text('Register'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already have a acount? Login here!'))
      ]),
    );
  }
}
