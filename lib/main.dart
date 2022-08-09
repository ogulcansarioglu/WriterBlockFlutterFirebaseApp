

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/email_verification_view.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';
import 'firebase_options.dart';
import 'dart:developer';

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
    return FutureBuilder(
            future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),

          builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
          
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              }
              else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
            /*final user = FirebaseAuth.instance.currentUser;
            if (user?.emailVerified ?? false) {
                  
                  print("You are a verified user");
                } else {

                  return const VerifyEmailView();
                }
              return Text("Done");*/
            
          
          default:
            return const CircularProgressIndicator();
          }
              // TODO: Handle this case.
              
        
          }
        ),
    );
        
    
  }
}

enum MenuAction {
  logout
}

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction> (onSelected: (value) {
            
          },
          itemBuilder: (context) {
          return const [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text("Log Out")
            ),
            ];
        }
          )

        ], 
        ),
      body: const Text('Hello World'),

    );
    
  }
}