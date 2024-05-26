// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously

import 'package:demo/constant/routes.dart';
import 'package:demo/services/auth/auth_exception.dart';
import 'package:demo/services/auth/auth_service.dart';
//import 'package:demo/utilites/show_error_dialog.dart';

import 'package:flutter/material.dart';

import '../utilites/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: Text('Login'),
        backgroundColor: Color.fromARGB(178, 34, 135, 229),
      ),
      body: Column(children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(hintText: 'Enter your Email'),
        ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(hintText: 'Enter your password'),
        ),
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            try {
              await AuthService.firebase()
                  .logIn(email: email, password: password);
              final user = AuthService.firebase().currentUser;
              if (user?.isEmailVerified ?? false) {
                //user is verified
                Navigator.of(context).pushNamedAndRemoveUntil(
                  notesRoute,
                  (route) => false,
                );
              } else {
                //user isn't verified
                Navigator.of(context).pushNamedAndRemoveUntil(
                  verifyEmailRoute,
                  (route) => false,
                );
              }
            } on UserNotFoundAuthException {
              await showErrorDialog(context, 'User not found!');
            } on WrongPasswordAuthException {
              await showErrorDialog(context, 'Wrong credential!');
            } on GenericAuthException {
              await showErrorDialog(context, 'Authentication Error!');
            }
          },
          child: const Text('Login'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(regiterRoute, (route) => false);
            },
            child: Text('Registor here!'))
      ]),
    );
  }
}
