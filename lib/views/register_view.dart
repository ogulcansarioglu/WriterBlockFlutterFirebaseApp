

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:learningdart/constants/routes.dart';
import 'package:learningdart/services/auth/auth_exceptions.dart';
import 'package:learningdart/services/auth/auth_service.dart';

import '../utility/dialogs/error_dialog.dart';


class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

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
      appBar: AppBar(title: const Text('Register')),
      body: Column(
        children: [
          TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  const InputDecoration(hintText: 'Enter your email here')),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: true,
              decoration:
                  const InputDecoration(hintText: 'Enter your password here')),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              try {
                AuthService.firebase().createUser(email: email,
                password: password,
                );
                AuthService.firebase().sendEmailVerification();
                final user = AuthService.firebase().currentUser;
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on EmailAlreadyInUsedAuthException {
                  await showErrorDialog(context, "E-mail already in use");
              } on WeakPasswordAuthException {
                  await showErrorDialog(context, "Weak  Password");
              } on InvalidEmailAuthException {
                  await showErrorDialog(context, "Invalid email");
              } on GenericAuthException {
                  await showErrorDialog(context, 'Authentication Error');
              }
              TextButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      loginRoute,
                      (route) => false,
                    );
                  }),
                  child: const Text('Already Registered? Login here!'));
            },
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
