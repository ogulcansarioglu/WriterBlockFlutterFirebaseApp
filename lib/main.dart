

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
     
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register/' : (context) => const RegisterView(),
      }
    ));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Login'),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
          
            case ConnectionState.done:
            /*final user = FirebaseAuth.instance.currentUser;
            if (user?.emailVerified ?? false) {
                  
                  print("You are a verified user");
                } else {

                  return const VerifyEmailView();
                }
              return Text("Done");*/
            return const LoginView();
          
          default:
            return const Text('Loading...');
          }
              // TODO: Handle this case.
              
        
          }
        ),
        ),
        );
    
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Please verify your email adress"),
      TextButton(onPressed: () async {
        final user = FirebaseAuth.instance.currentUser;
        await user?.sendEmailVerification();
      }, child: const Text('Send email verification'))
    ]);
  }
}