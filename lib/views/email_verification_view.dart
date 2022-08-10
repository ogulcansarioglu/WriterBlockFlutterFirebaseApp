
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';

import '../constants/routes.dart';
import '../services/auth/auth_service.dart';



class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title : const Text("Verify E-mail")
      ),
      body: Column(children: [
        const Text("We've sent you an email verification, please open it to verify"),
        const Text("If you haven't recieved a verification email yet, press the button below"),
        TextButton(onPressed: () async {
          await AuthService.firebase().sendEmailVerification();
        }, child: const Text('Send email verification')),
        TextButton(onPressed: () async {
          await AuthService.firebase().Logout();
          Navigator.of(context).pushNamedAndRemoveUntil(
            registerRoute,
           (route) =>false);
        },
        child: const Text('Restart')
        )
      ]),
    );
  }
}