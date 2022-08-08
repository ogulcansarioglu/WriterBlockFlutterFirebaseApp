import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';



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
        const Text("Please verify your email adress"),
        TextButton(onPressed: () async {
          final user = FirebaseAuth.instance.currentUser;
          await user?.sendEmailVerification();
        }, child: const Text('Send email verification'))
      ]),
    );
  }
}