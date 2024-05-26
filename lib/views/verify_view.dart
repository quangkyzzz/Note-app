// ignore_for_file: use_build_context_synchronously

import 'package:demo/constant/routes.dart';
import 'package:demo/services/auth/auth_service.dart';

import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: const Color.fromARGB(178, 34, 135, 229),
      ),
      body: Column(children: [
        const Text(
            "We've send you a email verification. Please open it and verify your email"),
        const Text(
            "If you haven't received a verification email, please press button bellow"),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text('Send Email verification')),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logOut();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(regiterRoute, (route) => false);
          },
          child: const Text("Back to register"),
        )
      ]),
    );
  }
}
